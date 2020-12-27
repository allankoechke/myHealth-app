#ifndef QMLINTERFACE_H
#define QMLINTERFACE_H

#include <QObject>
#include <QDebug>
#include <QNetworkAccessManager>
#include <QCryptographicHash>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QThreadPool>
#include <QIcon>
#include <QSettings>
#include <QGuiApplication>
#include <QJsonObject>
#include <QJsonDocument>

#include "databaseinterface.h"
#include "WebInterfaceRunnable.h"
#include "socketclientinterface.h"

class QmlInterface : public QObject
{
    Q_OBJECT

public:
    explicit QmlInterface(QObject *parent = nullptr);

    Q_PROPERTY(int healthStatusValue MEMBER m_healthStatusValue NOTIFY healthStatusValueChanged)
    Q_PROPERTY(double userTemperature MEMBER m_userTemperature NOTIFY userTemperatureChanged)
    Q_PROPERTY(int userRespiratoryRate MEMBER m_userRespiratoryRate NOTIFY userRespiratoryRateChanged)
    Q_PROPERTY(int userHeartRate MEMBER m_userHeartRate NOTIFY userHeartRateChanged)
    Q_PROPERTY(int userSPO2 MEMBER m_userSPO2 NOTIFY userSPO2Changed)
    Q_PROPERTY(int userSystolicPressure MEMBER m_userSystolicPressure NOTIFY userSystolicPressureChanged)
    Q_PROPERTY(int userDiastolicPressure MEMBER m_userDiastolicPressure NOTIFY userDiastolicPressureChanged)
    Q_PROPERTY(bool isUserLoggedIn MEMBER m_isUserLoggedIn NOTIFY isUserLoggedInChanged)
    Q_PROPERTY(bool isOnline MEMBER m_isOnline NOTIFY isOnlineChanged)
    Q_PROPERTY(bool processingUserRegistration MEMBER m_processingUserRegistration NOTIFY processingUserRegistrationChanged)
    Q_PROPERTY(bool processingUserLogin MEMBER m_processingUserLogin NOTIFY processingUserLoginChanged)

    Q_INVOKABLE void connect2Web(const QString &state, const QJsonObject &data);
    Q_INVOKABLE void addUser(const QString &name, const int &age, const QString &email, const QString &phone, const QString &pswd);
    Q_INVOKABLE void loginUser(const QString &uname, const QString &pswd);

    QString hashPassword(const QString &pswd);
    bool checkHashedPassword(const QString &pswd, const QString &hashedPswd);

signals:
    void healthStatusValueChanged(int healthStatusValue);

    void userTemperatureChanged(double userTemperature);

    void userRespiratoryRateChanged(int userRespiratoryRate);

    void userHeartRateChanged(int userHeartRate);

    void userSPO2Changed(int userSPO2);

    void userSystolicPressureChanged(int userSystolicPressure);

    void userDiastolicPressureChanged(int userDiastolicPressure);

    void isUserLoggedInChanged(bool isUserLoggedIn);

    void isOnlineChanged(bool isOnline);

    void sendToCloudChanged(const QString &state, const QJsonObject &data);

    void processingUserRegistrationChanged(bool processingUserRegistration);

    void accountCreatedSuccessfully(bool status);

    void emailAlreadyExists();

    void accountCreationFailed(QString error);

    void processingUserLoginChanged(bool processingUserLogin);

    void loginStatusChanged(bool state, QString status);

    void loggedInUser(QJsonObject user);

public slots:
    void onWebRunnableFinished(const QString &str_);

    void onSocketDisconnected();

    void onHealthRecordReceived(const QString &str);

private:
    int m_healthStatusValue=70, m_userDiastolicPressure=80, m_userRespiratoryRate=17, m_userSystolicPressure=120, m_userSPO2=95, m_userHeartRate=75;
    double m_userTemperature=36.7;
    QString applicationDir;
    DatabaseInterface * m_database;
    bool m_isUserLoggedIn, isRequestSent, pendingWebJob=false;
    WebInterfaceRunnable * m_WebInterface;
    QThreadPool m_ThreadPool;
    QSettings * settings;
    QString m_uniqueDeviceID, m_loggedUserPass;
    SocketClientInterface * m_SocketInterface;
    bool m_isOnline;
    QJsonObject m_addUserJson, m_addHealthRecordJson;
    bool m_processingUserRegistration, m_processingUserLogin;
};

#endif // QMLINTERFACE_H
