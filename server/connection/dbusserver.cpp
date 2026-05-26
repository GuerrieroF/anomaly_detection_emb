#include "dbusserver.h"

#include <QDebug>
#include <QProcessEnvironment>
#include <QtDBus/QDBusConnection>
#include "../uart/uart_receiver.h"
#include "../telemetry/TelemetryService.h"

DBusServer::DBusServer(QObject *parent)
    : QObject{parent}
{
    QDBusConnection::sessionBus().registerService("com.dbus_example.DBusService");
    QDBusConnection::sessionBus().registerObject("/DBUS/Service", this, QDBusConnection::ExportAllSlots);

    const QProcessEnvironment env = QProcessEnvironment::systemEnvironment();
    m_uartPort = env.value("ANOMALY_UART_PORT", "/dev/ttyACM0");

    bool baudOk = false;
    const int baud = env.value("ANOMALY_UART_BAUD", "115200").toInt(&baudOk);
    if (baudOk) {
        m_uartBaud = baud;
    }

    m_telemetry = new telemetry::TelemetryService(this);
    connect(m_telemetry, &telemetry::TelemetryService::imuReadingUpdated, this, &DBusServer::onImuReading);

    m_receiver = new uart::UartReceiver(m_uartPort, m_uartBaud, this);
    connect(m_receiver, &uart::UartReceiver::imuSampleReceived, m_telemetry, &telemetry::TelemetryService::onRawImuSample);
    connect(m_receiver, &uart::UartReceiver::receiverError, this, [](const QString& errorText) {
        qWarning() << "UART IMU receiver error:" << errorText;
    });

    if (!m_receiver->start()) {
        qWarning() << "Impossibile aprire la porta UART" << m_uartPort << "@" << m_uartBaud;
    } else {
        qInfo() << "UART IMU receiver attivo su" << m_uartPort << "@" << m_uartBaud;
    }
}

QString DBusServer::getMessage()
{
    if (!m_lastImuMessage.isEmpty()) {
        return m_lastImuMessage;
    }
    return QString("In attesa dati IMU su %1 @ %2").arg(m_uartPort).arg(m_uartBaud);
}

void DBusServer::onImuReading(const telemetry::ImuReading& reading)
{
    m_lastImuMessage = QString("IMU ax_g=%1 ay_g=%2 az_g=%3 gx_dps=%4 gy_dps=%5 gz_dps=%6 t=%7 "
                               "raw_ax=%8 raw_ay=%9 raw_az=%10 raw_gx=%11 raw_gy=%12 raw_gz=%13")
                           .arg(reading.accelXG, 0, 'f', 4)
                           .arg(reading.accelYG, 0, 'f', 4)
                           .arg(reading.accelZG, 0, 'f', 4)
                           .arg(reading.gyroXDps, 0, 'f', 2)
                           .arg(reading.gyroYDps, 0, 'f', 2)
                           .arg(reading.gyroZDps, 0, 'f', 2)
                           .arg(reading.receivedMs)
                           .arg(reading.rawAccelX)
                           .arg(reading.rawAccelY)
                           .arg(reading.rawAccelZ)
                           .arg(reading.rawGyroX)
                           .arg(reading.rawGyroY)
                           .arg(reading.rawGyroZ);
}
