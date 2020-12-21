#ifndef WEBINTERFACERUNNABLE_H
#define WEBINTERFACERUNNABLE_H

#include <QObject>
#include <QRunnable>
#include <QtNetwork>


class WebInterfaceRunnable :public QObject, public QRunnable
{
    Q_OBJECT
public:
    explicit WebInterfaceRunnable(QObject * parent = nullptr):QObject(parent)
    {
        setAutoDelete(false);
    }

    void setValues(const QString &uuid, const QString &vitals, const QString &dt)
    {
        m_url="https://webhooks.mongodb-realm.com/api/client/v2.0/app/application-myhealth-dnhnf/service/myHealth-webHook/incoming_webhook/myHealthHook";
        m_date = dt;
        m_vitalsStr = vitals;
        m_uuid = uuid;
    }

    void run()
    {
        QNetworkAccessManager networkManager;
        QNetworkRequest request(m_url);

        QUrlQuery query;
        query.addQueryItem("uuid", m_uuid);
        query.addQueryItem("vitalsString", m_vitalsStr);
        query.addQueryItem("date", m_date);

        QByteArray postData = query.toString().toUtf8();

        request.setRawHeader("Content-Type", "application/x-www-form-urlencoded");
        request.setRawHeader("Content-Length",QByteArray::number(postData.size()));

        QEventLoop loop;

        QTimer timer;

        timer.connect(&timer, &QTimer::timeout, &loop, &QEventLoop::quit);

        networkManager.connect(&networkManager, &QNetworkAccessManager::finished, &loop, &QEventLoop::quit);
        networkManager.connect(&networkManager, &QNetworkAccessManager::sslErrors, this, [=](){
            qDebug() << "SSL Errors!";
        });

        QNetworkReply * reply = networkManager.post(request, postData);

        timer.start(8000);

        loop.exec();

        if(timer.isActive())
        {
            timer.stop();

            if(reply)
            {
                int statusCode = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();

                qDebug() << ".. Reply Code: " << statusCode;

                if(reply->error() == QNetworkReply::NoError)
                {
                    if(statusCode != 200)
                    {
                        qDebug() << "Bad response";

                        emit finished("Error");
                    }
                    else
                    {
                        QString replyStr=reply->readAll();

                        // qDebug() << "Reply String: " << replyStr;

                        if(replyStr.isEmpty()||replyStr.isNull())
                        {
                            emit finished("Error");
                        }
                        else
                        {
                            emit finished(replyStr);
                        }
                    }
                }
                else
                {
                    emit finished("Error");
                }

                reply->deleteLater();
            }
            else
            {
                qDebug() << ">> No reply";

                emit finished("Error");
            }
        }

        else
        {
            emit finished("Error");

            qDebug() << "Timer not started";
        }
    }

signals:
    void finished(QString reply);

private:
    QString m_token,m_url, m_vitalsStr, m_uuid, m_date;
};

#endif // WEBINTERFACERUNNABLE_H
