#ifndef MARKERMODEL_H
#define MARKERMODEL_H

#include <QAbstractListModel>
#include <QGeoCoordinate>


class GeoUser: public QObject
{
    Q_OBJECT

public:
    explicit GeoUser(QObject *parent = nullptr)
    {
        Q_UNUSED(parent)
    }

    explicit GeoUser(const QVariant &id, const QGeoCoordinate &coord, const bool &local, QObject *parent = nullptr)
    {
        m_id = id;
        m_coordinate = coord;
        m_isLocal = local;

        Q_UNUSED(parent)
    }

    Q_PROPERTY(QVariant id READ id WRITE setId NOTIFY idChanged)
    Q_PROPERTY(QGeoCoordinate coordinate READ coordinate WRITE setCoordinate NOTIFY coordinateChanged)
    Q_PROPERTY(bool isLocal READ isLocal WRITE setIsLocal NOTIFY isLocalChanged)

    QVariant id() const
    {
        return m_id;
    }
    QGeoCoordinate coordinate() const
    {
        return m_coordinate;
    }

    bool isLocal() const
    {
        return m_isLocal;
    }

public slots:
    void setId(QVariant id)
    {
        if (m_id == id)
            return;

        m_id = id;
        emit idChanged(m_id);
    }
    void setCoordinate(QGeoCoordinate coordinate)
    {
        if (m_coordinate == coordinate)
            return;

        m_coordinate = coordinate;
        emit coordinateChanged(m_coordinate);
    }

    void setIsLocal(bool isLocal)
    {
        if (m_isLocal == isLocal)
            return;

        m_isLocal = isLocal;
        emit isLocalChanged(m_isLocal);
    }

signals:
    void idChanged(QVariant id);
    void coordinateChanged(QGeoCoordinate coordinate);
    void isLocalChanged(bool isLocal);

private:
    QVariant m_id;
    QGeoCoordinate m_coordinate;
    bool m_isLocal;
};

class MarkerModel : public QAbstractListModel
{
    Q_OBJECT

public:
    using QAbstractListModel::QAbstractListModel;

    enum MarkerRoles{
        idRole = Qt::UserRole + 1,
        positionRole,
        isLocalRole
    };

    // QAbstractListModel overrides
    int rowCount(const QModelIndex &parent = QModelIndex()) const override {
        Q_UNUSED(parent)
        return m_UserCoordinates.size();
    }

    QVariant data(const QModelIndex &index, int role) const override {
        if(index.row() < 0 || index.row() > m_UserCoordinates.count())
            return QVariant();

        GeoUser * user = m_UserCoordinates.at(index.row());

        if(role == idRole)
            return user->id();

        if(role == positionRole)
            return QVariant::fromValue(user->coordinate());

        if(role == isLocalRole)
            return QVariant::fromValue(user->isLocal());

        else return QVariant();
    }

    bool setData(const QModelIndex &index, const QVariant &value, int role) override
    {
        GeoUser * user = m_UserCoordinates.at(index.row());
        bool changed = false;

        switch (role)
        {
        case idRole:
        {
            if( user->id() != value.toString())
            {
                user->setId(value.toString());
                changed = true;
            }

            break;
        }

        case isLocalRole:
        {
            if( user->isLocal() != value.toBool())
            {
                user->setIsLocal(value.toBool());
                changed = true;
            }

            break;
        }

        case positionRole:
        {
            if( QVariant::fromValue(user->coordinate()) != value)
            {
                user->setCoordinate(value.value<QGeoCoordinate>());
                changed = true;
            }

            break;
        }
        }

        if(changed)
        {
            emit dataChanged(index, index, QVector<int>() << role);
            return true;
        }

        return false;
    }

    Qt::ItemFlags flags(const QModelIndex &index) const override
    {
        if(!index.isValid())
            return Qt::NoItemFlags;

        return Qt::ItemIsEditable;
    }

    QHash<int, QByteArray> roleNames() const override
    {
        QHash<int, QByteArray> roles;

        roles[idRole] = "tag";
        roles[positionRole] = "position";
        roles[isLocalRole] = "local";

        return roles;
    }

    Q_INVOKABLE void addMarker(const QVariant & id, const QGeoCoordinate &coordinate, bool local){
        int foundIndex = -1;

        for(int i=0; i<m_UserCoordinates.size(); i++)
        {
            QVariant _id = data(this->index(i), idRole);

            if(id == _id)
            {
                foundIndex = i;
                break;
            }
        }

        if(foundIndex==-1)
            addMarker(new GeoUser(id, coordinate, local));

        else
        {
            setData(this->index(foundIndex), id, idRole);
            setData(this->index(foundIndex), QVariant::fromValue(coordinate), positionRole);
            setData(this->index(foundIndex), local, isLocalRole);
        }
    }

    void addMarker(GeoUser * user){
        beginInsertRows(QModelIndex(), rowCount(), rowCount());
        m_UserCoordinates.append(user);
        endInsertRows();
    }


private:
    QList<GeoUser *> m_UserCoordinates;

};

#endif // MARKERMODEL_H
