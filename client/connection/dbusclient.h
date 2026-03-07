#ifndef DBUSCLIENT_H
#define DBUSCLIENT_H

#include <QObject>
#include <QTimer>
#include <QtDBus/QDBusInterface>
#include <QtDBus/QDBusReply>
#include <QtDBus/QDBusError>

class DBusClient : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool serverAvailable READ serverAvailable NOTIFY serverAvailabilityChanged)
public:
    explicit DBusClient(QObject *parent = nullptr);
    ~DBusClient(){}

    Q_INVOKABLE QString fetchMessage();
    bool serverAvailable() const;

signals:
    void serverAvailabilityChanged();

private:
    void tryConnect();
    bool isInterfaceReady() const;

    QDBusInterface *iface;
    QTimer retryTimer;
    bool m_serverAvailable;
};

#endif // DBUSCLIENT_H
