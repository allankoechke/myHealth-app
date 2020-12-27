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

    void setValues(const QString &state, const QJsonObject &data)
    {
        m_url="https://webhooks.mongodb-realm.com/api/client/v2.0/app/application-myhealth-dnhnf/service/myHealth-webHook/incoming_webhook/myHealthHook";
        m_data = data;
        m_state = state;
    }

    void run()
    {
        QNetworkAccessManager networkManager;
        QNetworkRequest request(m_url);

        QJsonDocument subJson(m_data["content"].toObject());

        QUrlQuery query;
        query.addQueryItem("state", m_state);
        query.addQueryItem("content", subJson.toJson());

        QByteArray postData = query.toString().toUtf8(); // doc.toJson(); // query.toString().toUtf8();

        request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");

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

                // qDebug() << ".. Reply Code: " << statusCode;

                if(reply->error() == QNetworkReply::NoError)
                {
                    if(statusCode != 200)
                    {
                        // qDebug() << "Bad response";

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
    QString m_token,m_url, m_state;
    QJsonObject m_data;
};

#endif // WEBINTERFACERUNNABLE_H
