#ifndef QMLINTERFACE_H
#define QMLINTERFACE_H

#include <QObject>
#include <QDebug>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QThreadPool>
#include <QIcon>
#include <QSettings>
#include <QGuiApplication>

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

    Q_INVOKABLE void connect2Web(const QString &str);

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

public slots:
    void onWebRunnableFinished(const QString &str_);

    void onSocketDisconnected();

private:
    int m_healthStatusValue=70, m_userDiastolicPressure=80, m_userRespiratoryRate=17, m_userSystolicPressure=120, m_userSPO2=95, m_userHeartRate=75;
    double m_userTemperature=36.7;
    QString applicationDir;
    DatabaseInterface * m_database;
    bool m_isUserLoggedIn, isRequestSent, pendingWebJob=false;
    WebInterfaceRunnable * m_WebInterface;
    QThreadPool m_ThreadPool;
    QSettings * settings;
    QString m_uniqueDeviceID;
    SocketClientInterface * m_SocketInterface;
    bool m_isOnline;
};

#endif // QMLINTERFACE_H
