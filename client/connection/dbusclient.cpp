#include "dbusclient.h"


DBusClient::DBusClient(QObject *parent)
    : QObject{parent},
      iface(nullptr),
      m_serverAvailable(false)
{
    retryTimer.setInterval(1000);
    connect(&retryTimer, &QTimer::timeout, this, &DBusClient::tryConnect);
    tryConnect();
    if (!m_serverAvailable) {
        retryTimer.start();
    }
}

QString DBusClient::fetchMessage()
{
    if (!isInterfaceReady()) {
        tryConnect();
        return QStringLiteral("Server D-Bus non disponibile");
    }

    QDBusReply<QString> reply = iface->call("getMessage");
    if (reply.isValid()) {
        return reply.value();
    }

    tryConnect();
    return QString("Errore %1").arg(reply.error().message());
}

bool DBusClient::serverAvailable() const
{
    return m_serverAvailable;
}

void DBusClient::tryConnect()
{
    if (iface) {
        delete iface;
        iface = nullptr;
    }

    iface = new QDBusInterface("com.dbus_example.DBusService",
                               "/DBUS/Service",
                               "com.dbus_example.DBusService",
                               QDBusConnection::sessionBus(),
                               this);

    const bool nowAvailable = isInterfaceReady();
    if (m_serverAvailable != nowAvailable) {
        m_serverAvailable = nowAvailable;
        emit serverAvailabilityChanged();
    }

    if (m_serverAvailable && retryTimer.isActive()) {
        retryTimer.stop();
    } else if (!m_serverAvailable && !retryTimer.isActive()) {
        retryTimer.start();
    }
}

bool DBusClient::isInterfaceReady() const
{
    return iface && iface->isValid();
}
