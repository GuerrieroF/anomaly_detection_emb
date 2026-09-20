#ifndef DBUSSERVER_H
#define DBUSSERVER_H

#include <QObject>
#include <QByteArray>
#include <QStringList>
#include "dbusserver_interface.h"

namespace uart {
class UartReceiver;
}

namespace telemetry {
class TelemetryService;
struct ImuReading;
struct GpsReading;
}

namespace uart {
struct UartFrame;
}

class DBusServer : public QObject
{
    Q_OBJECT
    Q_CLASSINFO("D-Bus Interface", "com.dbus_example.DBusService")
public:
    explicit DBusServer(QObject *parent = nullptr);

public slots:
    QString getMessage(void);
    QString getImuDetails();
    QString getTraffic();
    QString getGpsMessage();

signals:

private slots:
    void onImuReading(const telemetry::ImuReading& reading);
    void onGpsReading(const telemetry::GpsReading& reading);
    void onFrameReceived(const uart::UartFrame& frame);
    void onFrameQueued(const QByteArray& frame);

private:
    uart::UartReceiver* m_receiver = nullptr;
    telemetry::TelemetryService* m_telemetry = nullptr;
    QString m_lastImuMessage;
    QString m_lastImuDetails;
    QString m_lastGpsMessage;
    QStringList m_traffic;
    QString m_uartPort;
    qint32 m_uartBaud = 115200;
};

#endif // DBUSSERVER_H
