#ifndef SERIALPORTINTERFACE_H
#define SERIALPORTINTERFACE_H

#include <QObject>

class SerialPortInterface : public QObject
{
    Q_OBJECT
public:
    explicit SerialPortInterface(QObject *parent = nullptr);

signals:

};

#endif // SERIALPORTINTERFACE_H
