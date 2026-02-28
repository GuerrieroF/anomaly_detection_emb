#include "dbusservice.h"

DBusService::DBusService(QObject *parent)
    : QObject{parent}
{}

QString DBusService::getMessage()
{
    return "Ciao sono il server comunico tramite DBus!";
}
