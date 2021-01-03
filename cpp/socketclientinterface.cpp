#include "socketclientinterface.h"

SocketClientInterface::SocketClientInterface(QObject *parent) : QObject(parent)
{
    m_server = new QTcpServer(this);

    // whenever a user connects, it will emit signal
    connect(m_server, SIGNAL(newConnection()),
            this, SLOT(onNewConnection()));

    if(!m_server->listen(QHostAddress::LocalHost, 9999))
    {
        qDebug() << "Server could not start";
    }
    else
    {
        qDebug() << "Server started!";
    }
}

void SocketClientInterface::onNewConnection()
{
    QTcpSocket *clientSocket = m_server->nextPendingConnection();
    connect(clientSocket, SIGNAL(readyRead()), this, SLOT(onReadyRead()));
    connect(clientSocket, SIGNAL(stateChanged(QAbstractSocket::SocketState)), this, SLOT(onSocketStateChanged(QAbstractSocket::SocketState)));

    m_sockets.push_back(clientSocket);
    for (QTcpSocket* socket : m_sockets) {
        socket->write(QByteArray::fromStdString(clientSocket->peerAddress().toString().toStdString() + " connected to server !\n"));
    }
}

void SocketClientInterface::onSocketStateChanged(QAbstractSocket::SocketState socketState)
{
    if (socketState == QAbstractSocket::UnconnectedState)
    {
        QTcpSocket* sender = static_cast<QTcpSocket*>(QObject::sender());
        m_sockets.removeOne(sender);
        sender->deleteLater();
        emit socketDisconnected();
    }
}

void SocketClientInterface::onReadyRead()
{
    QTcpSocket* sender = static_cast<QTcpSocket*>(QObject::sender());
    QString datas = sender->readAll().data();
    qDebug() << "Received: " << datas;

    for (QTcpSocket* socket : m_sockets) {
        // socket->write(QByteArray::fromStdString(sender->peerAddress().toString().toStdString() + ": " + datas.toStdString()));
        emit vitalsStringReceived(datas);
        // qDebug() << "...";
    }
}
