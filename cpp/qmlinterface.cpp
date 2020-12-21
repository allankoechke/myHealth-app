#include "qmlinterface.h"

QmlInterface::QmlInterface(QObject *parent) : QObject(parent)
{
    m_WebInterface = new WebInterfaceRunnable(this);

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

    m_isOnline = false;
    emit isOnlineChanged(false);

    connect(m_WebInterface, &WebInterfaceRunnable::finished, this, &QmlInterface::onWebRunnableFinished);
    m_SocketInterface = new SocketClientInterface(this);
    connect(m_SocketInterface, &SocketClientInterface::vitalsStringReceived, this, &QmlInterface::connect2Web);
    connect(m_SocketInterface, &SocketClientInterface::socketDisconnected, this, &QmlInterface::onSocketDisconnected);

}

void QmlInterface::connect2Web(const QString &str)
{
    if(!m_isOnline)
    {
        m_isOnline = true;
        emit isOnlineChanged(true);
    }

    if(m_ThreadPool.activeThreadCount()==0 && !pendingWebJob)
    {
        pendingWebJob = true;

        QStringList v = str.split(":");

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

        QString dt = QDateTime::currentDateTime().toString("yyyy-MM-ddThh:mm:ss.zzz+03:00");

        m_WebInterface->setValues( m_uniqueDeviceID, str, dt);

        m_ThreadPool.start(m_WebInterface);
    }
}

void QmlInterface::onWebRunnableFinished(const QString &str)
{
    Q_UNUSED(str)

    pendingWebJob = false;

    // qDebug() << "Reply: " << str;
}

void QmlInterface::onSocketDisconnected()
{
    if(m_isOnline)
    {
        m_isOnline = false;
        emit isOnlineChanged(false);
    }
}


