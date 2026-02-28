#include "dbusclient.h"


DBusClient::DBusClient(QObject *parent)
    : QObject{parent}
{
    iface  = new QDBusInterface("com.dbus_example.DBusService","/DBUS/Service","com.dbus_example.DBusService",QDBusConnection::sessionBus());
    if (!iface->isValid()) {
        qFatal("Interfaccia D-Bus non valida!");
    }

}

QString DBusClient::fetchMessage()
{

    QDBusReply<QString> reply = iface->call("getMessage");
    return reply.isValid() ? reply.value() : QString("Errore %1").arg(reply.error().message());
}
