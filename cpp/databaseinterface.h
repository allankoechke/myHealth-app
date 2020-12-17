#ifndef DATABASEINTERFACE_H
#define DATABASEINTERFACE_H

#include <QObject>
#include <QDebug>
#include <QSqlDatabase>

class DatabaseInterface : public QObject
{
    Q_OBJECT

public:
    DatabaseInterface(QObject *parent = nullptr)
    {
        Q_UNUSED(parent)
    }

    void init()
    {
        QSqlDatabase myDb = QSqlDatabase::addDatabase("QSQLITE");
        myDb.setHostName("localhost");
        myDb.setDatabaseName("malaika");
        myDb.setUserName("");
        myDb.setPassword("");

        if(myDb.open())
            emit databaseReady(true);

        else
            databaseReady(false);

        qDebug() << "Database is set up!";
    }

signals:
    void databaseReady(bool ready);

private:
    //
};

#endif // DATABASEINTERFACE_H
