#include "qmlinterface.h"

QmlInterface::QmlInterface(QObject *parent) : QObject(parent)
{
    m_processingUserLogin = m_processingUserRegistration=false;
    m_previousSyncDateTime = QDateTime::currentDateTime();
    m_isOnline = false;
    m_userState = "user";

    m_doctorSyncTimer = new QTimer(this);
    m_doctorSyncTimer->setInterval(20000);
    connect(m_doctorSyncTimer, &QTimer::timeout, this, &QmlInterface::onDoctorSynctTimerTimeout);

    m_vitalsTimer = new QTimer(this);
    m_vitalsTimer->setInterval(7000);
    connect(m_vitalsTimer, &QTimer::timeout, this, &QmlInterface::onVitalsTimerTimeout);


    applicationDir=qApp->applicationDirPath();

    qApp->setApplicationName("myHealth App");
    qApp->setApplicationVersion("1.0.0");
    qApp->setApplicationDisplayName("myHealth");
    qApp->setOrganizationName("lalanke");
    qApp->setWindowIcon(QIcon(":/assets/myHealth-logo-small.png"));
    qApp->setOrganizationDomain("lalanke.com");
    settings = new QSettings(qApp->organizationName(),qApp->applicationDisplayName());


    QUuid uniqueDeviceId = QUuid::createUuid();
    QUuid::createUuidV5(uniqueDeviceId, QDateTime::currentDateTime().toString("yyyy-MM-dd hh:mm:ss").toUtf8());

    QVariant deviceId = settings->value("device_id").toString();

    if(!deviceId.isValid() || deviceId=="")
    {
        settings->setValue("device_id", deviceId.toString().replace("{","").replace("}",""));
    }

    m_uniqueDeviceID  = settings->value("device_id").toString();

    qDebug() << "Unique ID: " << m_uniqueDeviceID;

    m_ThreadPool.setMaxThreadCount(5);
    m_SocketInterface = new SocketClientInterface(this);

    // (m_SocketInterface, &SocketClientInterface::vitalsStringReceived, this, &QmlInterface::onHealthRecordReceived);
    // connect(m_SocketInterface, &SocketClientInterface::socketDisconnected, this, &QmlInterface::onSocketDisconnected);
    connect(this, &QmlInterface::socketStateChanged, m_SocketInterface, &SocketClientInterface::onSocketStatusChanged);
    connect(this, &QmlInterface::sendToCloudChanged, this, &QmlInterface::connect2Web);

    // Read the json schema for sending web requests
    QJsonObject userObj, userContentObj;
    userContentObj.insert("name", "Full Name");
    userContentObj.insert("age", 30);
    userContentObj.insert("enrolled_on", "2020-12-12T10:44:00.000+00:00");
    userContentObj.insert("email","john254@email.com");
    userContentObj.insert("phone_no", "254703412212");
    userContentObj.insert("password", "--");
    userContentObj.insert("change_password", true);
    userObj.insert("state", "AddUser");
    userObj.insert("content", userContentObj);
    m_addUserJson = userObj;


    QJsonObject recordObj, contentObj;
    contentObj.insert("uuid", m_uniqueDeviceID);
    contentObj.insert("vitalsString", "36.7:17:72:90:120:80");
    contentObj.insert("date", "2020-12-01T13:00:00.000+03:00");
    recordObj.insert("state", "AddHealthRecord");
    recordObj.insert("content", contentObj);
    m_addHealthRecordJson = recordObj;


    std::random_shuffle(bodyTemperatureArray.begin(), bodyTemperatureArray.end());
    std::random_shuffle(respirationRateArray.begin(), respirationRateArray.end());
    std::random_shuffle(spo2Array.begin(), spo2Array.end());
    std::random_shuffle(heartBeatArray.begin(), heartBeatArray.end());
    std::random_shuffle(systolicPressureArray.begin(), systolicPressureArray.end());
    std::random_shuffle(diastolicPressureArray.begin(), diastolicPressureArray.end());
}

void QmlInterface::connect2Web(const QString &state, const QJsonObject &data)
{
    if(!m_isOnline)
    {
        m_isOnline = true;
        emit isOnlineChanged(true);
    }

    WebInterfaceRunnable * web = new WebInterfaceRunnable(this);
    connect(web, &WebInterfaceRunnable::finished, this, &QmlInterface::onWebRunnableFinished);

    web->setValues( state, data);

    m_ThreadPool.start(web);
}

void QmlInterface::addUser(const QString &name, const int &age, const QString &email, const QString &phone, const QString &pswd)
{
    QString dt = QDateTime::currentDateTime().toString("yyyy-MM-ddThh:mm:ss.zzz+03:00");

    QJsonObject content = m_addUserJson["content"].toObject();
    content["name"] = name;
    content["age"] = age;
    content["enrolled_on"] = dt;
    content["email"] = email;
    content["phone_no"] = phone;
    content["password"] = hashPassword(pswd);
    content["change_password"] = false;
    m_addUserJson["state"] = "AddUser";
    m_addUserJson["content"] = content;

    emit sendToCloudChanged("AddUser", m_addUserJson);

}

void QmlInterface::loginUser(const QString &uname, const QString &pswd)
{
    m_loggedUserPass = pswd;

    QJsonObject userObj, contentObj;
    contentObj.insert("email", uname);
    userObj.insert("state", "GetUser");
    userObj.insert("content", contentObj);

    emit sendToCloudChanged("GetUser", userObj);
}

int QmlInterface::getTimerIntervalBetweenSync()
{
    return QDateTime::currentSecsSinceEpoch() - m_previousSyncDateTime.toSecsSinceEpoch();
}

void QmlInterface::setDoctorMode(bool state)
{

    if(state)
    {
        if(!m_doctorSyncTimer->isActive())
        {
            m_doctorSyncTimer->start();
            onDoctorSynctTimerTimeout();
        }

        m_userState = "doctor";
        emit socketStateChanged("doctor");

        if(m_vitalsTimer->isActive())
            m_vitalsTimer->stop();
    }
    else
    {
        m_vitalsTimer->start();
        qDebug() << "Timer started? " << m_vitalsTimer->isActive();

        if(m_doctorSyncTimer->isActive())
            m_doctorSyncTimer->stop();

        m_userState = "user";
        emit socketStateChanged("user");
    }
}

void QmlInterface::sendReply(const QString &str)
{
    QJsonObject getRecordObj, getContentObj;
    getContentObj.insert("reply_on", QDateTime::currentSecsSinceEpoch());
    getContentObj.insert("msg", str);
    getContentObj.insert("read", false);
    getRecordObj.insert("state", "AddDoctorsReply");
    getRecordObj.insert("content", getContentObj);
    m_GetHealthRecordJson = getRecordObj;

    emit sendToCloudChanged("AddDoctorsReply", getRecordObj);
}

QString QmlInterface::hashPassword(const QString &pswd)
{
    QString salt = QString::number(QDateTime::currentSecsSinceEpoch());
    QCryptographicHash hash(QCryptographicHash::Sha3_256);
    hash.addData(pswd.toUtf8() + salt.toUtf8());
    QString hashedP = hash.result().toHex()+":"+salt;
    qDebug() << "Hashed! = " << hashedP;
    // lalan = bda84ebcb0d5cdf3cc2b14cfbf02a3d7d67eb8df8e3d9e62e478ada3effd313a:1609077498
    return hashedP;
}

bool QmlInterface::checkHashedPassword(const QString &pswd, const QString &hashedPswd)
{
    qDebug() << "Hashed Pass: " << hashedPswd;

    QString _pswd = hashedPswd.split(":").at(0);
    QString _salt = hashedPswd.split(":").at(1);

    QCryptographicHash hash(QCryptographicHash::Sha3_256);
    hash.addData(pswd.toUtf8() + _salt.toUtf8());

    if(hash.result().toHex() == _pswd)
        return true;

    else
        return false;
}

void QmlInterface::onWebRunnableFinished(const QString &str)
{
    qDebug() << "Reply String: " << str;

    QJsonDocument doc = QJsonDocument::fromJson(str.toUtf8());
    QJsonObject replyObj = doc.object();

    QString state = replyObj["state"].toString();
    qDebug() << "State: " << state;

    if(state=="AddUser")
    {
        qDebug() << "Add User Feedback";

        if( replyObj["Status"].toString() == "Success" )
        {
            emit accountCreatedSuccessfully(true);
            qDebug() << replyObj["Status Description"].toString();

        } else {
            emit accountCreationFailed(replyObj["Status Description"].toString());
            qDebug() << replyObj["Status Description"].toString();
        }
    }

    else if(state=="GetUser")
    {
        qDebug() << "Get User Feedback";

        if( replyObj["Status"].toString() == "Success" )
        {
            if( replyObj["user"].toString()=="null" )
                emit loginStatusChanged(false, "Unknown User Details", false);

            else
            {
                QJsonDocument doc = QJsonDocument::fromJson(replyObj["user"].toString().toUtf8());
                QJsonObject userJson = doc.object();

                qDebug() << "Is Doctor: " << userJson["role"].toString();

                QString _pswd = userJson["password"].toString();
                // qDebug() << _pswd;
                auto loginStatus = checkHashedPassword(m_loggedUserPass, _pswd);

                if( loginStatus )
                {
                    emit loginStatusChanged(true, "", userJson["role"]=="doctor");
                    // Capture loggged in user details here
                    emit loggedInUser(userJson);
                }
                else
                    emit loginStatusChanged(false, "Invalid Login Details", false);
            }
        }

        else
        {
            emit loginStatusChanged(false, "No internet connection", false);
        }
    }

    else if(state=="AddHealthRecord")
    {
        qDebug() << "Add Health Record Feedback";

        QStringList jsonList = replyObj["content"].toString().split("\n");

        emit doctorReplyReceived();

        m_previousSyncDateTime = QDateTime::currentDateTime();

        for(int i=0; i<jsonList.size(); i++)
        {
            // qDebug() << "JSON Str: " << jsonList.at(i);

            QJsonDocument doc = QJsonDocument::fromJson(jsonList.at(i).toUtf8());
            QJsonObject dataObj = doc.object();

            // QDateTime dt = QDateTime::fr

            emit newDoctorReplyEmitted(dataObj);
        }

        // qDebug() << "Content: " << replyObj["content"].toString();

    }

    else if(state=="GetHealthRecord")
    {
        qDebug() << "Get Health Record Feedback";

        if( replyObj["Status"].toString() == "Success" )
        {
            if( replyObj["content"].toString()=="null" )
                qDebug() << "Empty String Received";

            else
            {
                m_previousSyncDateTime = QDateTime::currentDateTime();

                QStringList jsonList = replyObj["content"].toString().split("\n");

                for(int i=jsonList.size()-1; i>=0; i--)
                {
                    QJsonDocument doc = QJsonDocument::fromJson(jsonList.at(i).toUtf8());
                    QJsonObject dataObj = doc.object();

                    lastSyncTime = ((int)dataObj["date"].toDouble())+1;

                    emit chartDataReceived(lastSyncTime, dataObj["vitalsString"].toString());

                    onHealthRecordReceived(dataObj["vitalsString"].toString());

                    // qDebug() << "1";
                }
            }
        }
    }

    else if(state=="AddDoctorsReply")
    {
        qDebug() << "Adding Doctor's Reply -> " << replyObj["Status"].toString();

        if( replyObj["Status"].toString() == "Success" )
            emit doctorsReplyStateChanged(true, "Added Successfully");

        else
            emit doctorsReplyStateChanged(false, "Empty Reply Received");
    }

    else
    {
        qDebug() << "Unknown Feedback";

        if(m_processingUserRegistration)
            emit accountCreationFailed("Operation Failed (403)!");
    }

    onDoctorSynctTimerTimeout();
    m_doctorSyncTimer->stop();
}

void QmlInterface::onSocketDisconnected()
{
    if(m_isOnline)
    {
        m_isOnline = false;
        emit isOnlineChanged(false);
    }
}

void QmlInterface::onHealthRecordReceived(const QString &str)
{
    // Guard from empy string splitting which crashes the app
    if( str != "" )
    {
        QStringList v = str.split(":");

        qDebug() << "Vitals: " << str;

        double temperature = v.at(0).toDouble();
        int resp = v.at(1).toUInt();
        int hr = v.at(2).toUInt();
        int spo2 = v.at(3).toInt();
        int syst = v.at(4).toInt();
        int diast = v.at(5).toInt();

        if(m_userTemperature != temperature)
        {
            m_userTemperature = temperature;
            emit userTemperatureChanged(temperature);
        }

        if(m_userRespiratoryRate != resp)
        {
            m_userRespiratoryRate = resp;
            emit userRespiratoryRateChanged(resp);
        }

        if(m_userHeartRate != hr)
        {
            m_userHeartRate = hr;
            emit userHeartRateChanged(hr);
        }

        if(m_userSPO2 != spo2)
        {
            m_userSPO2 = spo2;
            emit userSPO2Changed(spo2);
        }

        if(m_userSystolicPressure != syst)
        {
            m_userSystolicPressure = syst;
            emit userSystolicPressureChanged(syst);
        }

        if(m_userDiastolicPressure != diast)
        {
            m_userDiastolicPressure = diast;
            emit userDiastolicPressureChanged(diast);
        }

        if( m_userState == "user" )
        {
            auto dt = QDateTime::currentDateTime().toSecsSinceEpoch();

            QJsonObject content = m_addHealthRecordJson["content"].toObject();
            content["uuid"] = m_uniqueDeviceID;
            content["vitalsString"] = str;
            content["date"] = dt;
            m_addHealthRecordJson["state"] = "AddHealthRecord";
            m_addHealthRecordJson["content"] = content;

            emit sendToCloudChanged("AddHealthRecord", m_addHealthRecordJson);
        }
    }
}

void QmlInterface::onDoctorSynctTimerTimeout()
{
    QJsonObject getRecordObj, getContentObj;
    getContentObj.insert("start", lastSyncTime);
    getContentObj.insert("end", QDateTime::currentSecsSinceEpoch());
    getRecordObj.insert("state", "GetHealthRecord");
    getRecordObj.insert("content", getContentObj);
    m_GetHealthRecordJson = getRecordObj;

    emit sendToCloudChanged("GetHealthRecord", getRecordObj);
}

void QmlInterface::onVitalsTimerTimeout()
{
    float temperature = bodyTemperatureArray.at(10);
    int rr = respirationRateArray.at(10);
    int spo2 = spo2Array.at(5);
    int hb = heartBeatArray.at(10);
    int syst = systolicPressureArray.at(10);
    int diast = diastolicPressureArray.at(10);

    QString stringToSend = QString::number(temperature)+":"+QString::number(rr)+":"+QString::number(hb)+":"+QString::number(spo2)+":"+QString::number(syst)+":"+QString::number(diast);

    qDebug() << stringToSend;

    onHealthRecordReceived(stringToSend);

    std::random_shuffle(bodyTemperatureArray.begin(), bodyTemperatureArray.end());
    std::random_shuffle(respirationRateArray.begin(), respirationRateArray.end());
    std::random_shuffle(spo2Array.begin(), spo2Array.end());
    std::random_shuffle(heartBeatArray.begin(), heartBeatArray.end());
    std::random_shuffle(systolicPressureArray.begin(), systolicPressureArray.end());
    std::random_shuffle(diastolicPressureArray.begin(), diastolicPressureArray.end());
}


