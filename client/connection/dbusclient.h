#ifndef DBUSCLIENT_H
#define DBUSCLIENT_H

#include <QObject>
#include <QtDBus/QDBusInterface>
#include <QtDBus/QDBusReply>
#include <QtDBus/QDBusError>

class DBusClient : public QObject
{
    Q_OBJECT
public:
    explicit DBusClient(QObject *parent = nullptr);
    ~DBusClient(){}

    Q_INVOKABLE QString fetchMessage();

signals:

private:
    QDBusInterface *iface;
};

#endif // DBUSCLIENT_H
