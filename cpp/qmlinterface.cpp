#include "qmlinterface.h"

QmlInterface::QmlInterface(QObject *parent) : QObject(parent)
{
    m_geoSource = QGeoPositionInfoSource::createDefaultSource(this);

    if (m_geoSource)
    {
        connect(m_geoSource, SIGNAL(positionUpdated(QGeoPositionInfo)),
                this, SLOT(positionUpdated(QGeoPositionInfo)));
        m_geoSource->startUpdates();
    }

    m_database = new DatabaseInterface(this);
    m_database->init();

    connect(m_database, &DatabaseInterface::databaseReady, this, [=](const bool &status){
        qDebug() << "Database interface conected? " << status;
    });

}

void QmlInterface::positionUpdated(const QGeoPositionInfo &info)
{
    QGeoCoordinate cord = info.coordinate();
    qDebug() << "Position updated:" << cord;
    m_myGeoPosition = cord;
    emit myGeoPositionChanged(m_myGeoPosition);
}
