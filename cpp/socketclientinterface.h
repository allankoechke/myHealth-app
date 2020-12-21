#ifndef SOCKETCLIENTINTERFACE_H
#define SOCKETCLIENTINTERFACE_H

#include <QObject>
#include <QTcpServer>
#include <QTcpSocket>
#include <QAbstractSocket>

class SocketClientInterface : public QObject
{
    Q_OBJECT
public:
    explicit SocketClientInterface(QObject *parent = nullptr);

signals:
    void vitalsStringReceived(const QString &vitalString);
    void socketDisconnected();

private slots:
    void onNewConnection();
    void onSocketStateChanged(QAbstractSocket::SocketState socketState);
    void onReadyRead();

private:
    QTcpServer * m_server;
    QList<QTcpSocket*>  m_sockets;
};

#endif // SOCKETCLIENTINTERFACE_H
