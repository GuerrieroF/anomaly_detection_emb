#ifndef DBUSSERVER_H
#define DBUSSERVER_H

#include <QObject>
#include "dbusserver_interface.h"

namespace uart {
struct ImuSample;
class UartReceiver;
}

class DBusServer : public QObject
{
    Q_OBJECT
    Q_CLASSINFO("D-Bus Interface", "com.dbus_example.DBusService")
public:
    explicit DBusServer(QObject *parent = nullptr);

public slots:
    QString getMessage(void);

signals:

private slots:
    void onImuSample(const uart::ImuSample& sample);

private:
    uart::UartReceiver* m_receiver = nullptr;
    QString m_lastImuMessage;
    QString m_uartPort;
    qint32 m_uartBaud = 115200;
};

#endif // DBUSSERVER_H
