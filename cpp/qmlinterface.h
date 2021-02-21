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
    Q_INVOKABLE int getTimerIntervalBetweenSync();
    Q_INVOKABLE void setDoctorMode(bool state);
    Q_INVOKABLE void sendReply(const QString &str);

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

    void loginStatusChanged(bool state, QString status, bool is_doctor = false);

    void loggedInUser(QJsonObject user);

    /// \brief Emits a signal to QML to inform it of new Doctor's Reply
    /// data received from the cloud
    void newDoctorReplyEmitted(QJsonObject data);

    /// \brief Emitted to clear the reply model before appending the new data
    void doctorReplyReceived();

    /// \brief Emits plottable points
    void chartDataReceived(int x, QString data);

    /// \brief Emitted to show success/failure to send a doctors reply to the cloud
    void doctorsReplyStateChanged(bool state, QString stateInfo);

    /// \brief Emitted When changing between doctor and user modes to open or close the
    /// socket server appropriately
    void socketStateChanged(QString state);

public slots:
    void onWebRunnableFinished(const QString &str_);

    void onSocketDisconnected();

    void onHealthRecordReceived(const QString &str);

    void onDoctorSynctTimerTimeout();

    void onVitalsTimerTimeout();

private:
    int m_healthStatusValue=70, m_userDiastolicPressure=80, m_userRespiratoryRate=17, m_userSystolicPressure=120, m_userSPO2=95, m_userHeartRate=75;
    double m_userTemperature=36.7;
    QString applicationDir, m_userState;
    DatabaseInterface * m_database;
    bool m_isUserLoggedIn, isRequestSent;
    QThreadPool m_ThreadPool;
    QSettings * settings;
    QTimer * m_doctorSyncTimer, *m_vitalsTimer;
    QString m_uniqueDeviceID, m_loggedUserPass;
    SocketClientInterface * m_SocketInterface;
    bool m_isOnline;
    QJsonObject m_addUserJson, m_addHealthRecordJson, m_GetHealthRecordJson;
    bool m_processingUserRegistration, m_processingUserLogin;
    QDateTime m_previousSyncDateTime;
    int lastSyncTime = 0;

    QList<float> bodyTemperatureArray = {35.5, 35.6, 35.7, 35.8, 35.9, 36.0, 36.1, 36.2,
                            36.3, 36.4, 36.5, 36.6, 36.7, 36.8, 37.0, 37.1, 37.2, 37.3, 37.4};
    QList<int> respirationRateArray = {12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30};
    QList<int> spo2Array = {92, 93, 94, 95, 96, 97, 98, 99, 100};
    QList<int> heartBeatArray = {60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99};
    QList<int> systolicPressureArray = {80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120};
    QList<int> diastolicPressureArray = {60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80};
};

#endif // QMLINTERFACE_H
