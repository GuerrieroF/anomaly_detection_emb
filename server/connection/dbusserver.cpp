#include "dbusserver.h"
#include <QtDBus/QDBusConnection>

DBusServer::DBusServer(QObject *parent)
    : QObject{parent}
{
    QDBusConnection::sessionBus().registerService("com.dbus_example.DBusService");
    QDBusConnection::sessionBus().registerObject("/DBUS/Service", this, QDBusConnection::ExportAllSlots);
}
QString DBusServer::getMessage()
{
    return "Ciao sono il server comunico tramite DBus!";
}
