#include "socketclientinterface.h"

SocketClientInterface::SocketClientInterface(QObject *parent) : QObject(parent)
{
    m_server = new QTcpServer(this);

    // whenever a user connects, it will emit signal
    connect(m_server, SIGNAL(newConnection()),
            this, SLOT(onNewConnection()));

    onSocketStatusChanged("user");
}

void SocketClientInterface::onNewConnection()
{
    QTcpSocket *clientSocket = m_server->nextPendingConnection();
    connect(clientSocket, SIGNAL(readyRead()), this, SLOT(onReadyRead()));
    connect(clientSocket, SIGNAL(stateChanged(QAbstractSocket::SocketState)), this, SLOT(onSocketStateChanged(QAbstractSocket::SocketState)));

    m_sockets.push_back(clientSocket);
    for (int i=0; i<m_sockets.size(); i++) {
        QTcpSocket* socket = m_sockets.at(i);
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
    QByteArray _d = sender->readAll();
    QString datas = _d.data();
    qDebug() << "Received: " << datas;

    emit vitalsStringReceived(datas);
}

void SocketClientInterface::onSocketStatusChanged(QString state)
{
    qDebug() << "Switching to " << state << " mode";

    if(state == "user")
    {
        if(!m_server->listen(QHostAddress::LocalHost, 9999))
        {
            qDebug() << "Server could not start";
        }
        else
        {
            qDebug() << "Server started!";
        }

        qDebug() << "Switching to " << state << " mode";
    }
    else
    {
        // In doctor mode, close the server
        if(m_server->isListening())
        {
            m_server->close();
            qDebug() << "Socket server closed since its a doctor mode!";
        }
    }
}
