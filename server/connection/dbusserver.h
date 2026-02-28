#ifndef DBUSSERVER_H
#define DBUSSERVER_H

#include <QObject>
#include "dbusserver_interface.h"

class DBusServer : public QObject
{
    Q_OBJECT
    Q_CLASSINFO("D-Bus Interface", "com.dbus_example.DBusService")
public:
    explicit DBusServer(QObject *parent = nullptr);

public slots:
    QString getMessage(void);

signals:
};

#endif // DBUSSERVER_H
