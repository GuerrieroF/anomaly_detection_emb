#include "dbusserver.h"

#include <QDebug>
#include <QDateTime>
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
    m_uartPort = env.value("ANOMALY_UART_PORT", "/dev/ttyACM1");

    bool baudOk = false;
    const int baud = env.value("ANOMALY_UART_BAUD", "115200").toInt(&baudOk);
    if (baudOk) {
        m_uartBaud = baud;
    }

    m_telemetry = new telemetry::TelemetryService(this);
    connect(m_telemetry, &telemetry::TelemetryService::imuReadingUpdated, this, &DBusServer::onImuReading);
    connect(m_telemetry, &telemetry::TelemetryService::gpsReadingUpdated, this, &DBusServer::onGpsReading);

    m_receiver = new uart::UartReceiver(m_uartPort, m_uartBaud, this);
    connect(m_receiver, &uart::UartReceiver::imuSampleReceived, m_telemetry, &telemetry::TelemetryService::onRawImuSample);
    connect(m_receiver, &uart::UartReceiver::gpsSampleReceived, m_telemetry, &telemetry::TelemetryService::onRawGpsSample);
    connect(m_receiver, &uart::UartReceiver::frameReceived, this, &DBusServer::onFrameReceived);
    connect(m_receiver, &uart::UartReceiver::frameQueued, this, &DBusServer::onFrameQueued);
    connect(m_receiver, &uart::UartReceiver::receiverError, this, [](const QString& errorText) {
        qWarning() << "UART IMU receiver error:" << errorText;
    });

    if (!m_receiver->start()) {
        qWarning() << "Impossibile aprire la porta UART" << m_uartPort << "@" << m_uartBaud;
    } else {
        qInfo() << "UART IMU receiver attivo su" << m_uartPort << "@" << m_uartBaud;
        if (!m_receiver->sendGpsStart()) {
            qWarning() << "Impossibile accodare il comando di avvio GPS:" << m_receiver->lastError();
        }
    }
}

QString DBusServer::getMessage()
{
    if (!m_lastImuMessage.isEmpty()) {
        return m_lastImuMessage;
    }
    return QString("In attesa dati IMU su %1 @ %2").arg(m_uartPort).arg(m_uartBaud);
}

QString DBusServer::getImuDetails()
{
    return m_lastImuDetails;
}

QString DBusServer::getTraffic()
{
    return m_traffic.join('\n');
}

QString DBusServer::getGpsMessage()
{
    return m_lastGpsMessage;
}

void DBusServer::onFrameReceived(const uart::UartFrame& frame)
{
    const QString kind = frame.type == uart::MessageType::ImuSample ? QStringLiteral("IMU")
                         : frame.type == uart::MessageType::GpsSample ? QStringLiteral("GPS")
                                                                      : QStringLiteral("tipo sconosciuto");
    m_traffic.append(QStringLiteral("%1 RX %2 (0x%3): %4")
                         .arg(QDateTime::fromMSecsSinceEpoch(frame.receivedMs).toString("HH:mm:ss.zzz"))
                         .arg(kind)
                         .arg(frame.type, 2, 16, QLatin1Char('0'))
                         .arg(QString::fromLatin1(frame.payload.toHex(' '))));
    while (m_traffic.size() > 30) {
        m_traffic.removeFirst();
    }
}

void DBusServer::onFrameQueued(const QByteArray& frame)
{
    m_traffic.append(QStringLiteral("%1 TX in coda: %2")
                         .arg(QDateTime::currentDateTime().toString("HH:mm:ss.zzz"))
                         .arg(QString::fromLatin1(frame.toHex(' '))));
    while (m_traffic.size() > 30) {
        m_traffic.removeFirst();
    }
}

void DBusServer::onImuReading(const telemetry::ImuReading& reading)
{
    m_lastImuDetails = QStringLiteral("accelerazione_x_g: %1\naccelerazione_y_g: %2\naccelerazione_z_g: %3\n"
                                      "giroscopio_x_dps: %4\ngiroscopio_y_dps: %5\ngiroscopio_z_dps: %6\n"
                                      "accelerazione_x_raw: %7\naccelerazione_y_raw: %8\naccelerazione_z_raw: %9\n"
                                      "giroscopio_x_raw: %10\ngiroscopio_y_raw: %11\ngiroscopio_z_raw: %12\n"
                                      "timestamp_ricezione_ms: %13")
                           .arg(reading.accelXG, 0, 'f', 4)
                           .arg(reading.accelYG, 0, 'f', 4)
                           .arg(reading.accelZG, 0, 'f', 4)
                           .arg(reading.gyroXDps, 0, 'f', 2)
                           .arg(reading.gyroYDps, 0, 'f', 2)
                           .arg(reading.gyroZDps, 0, 'f', 2)
                           .arg(reading.rawAccelX)
                           .arg(reading.rawAccelY)
                           .arg(reading.rawAccelZ)
                           .arg(reading.rawGyroX)
                           .arg(reading.rawGyroY)
                           .arg(reading.rawGyroZ)
                           .arg(reading.receivedMs);

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

void DBusServer::onGpsReading(const telemetry::GpsReading& reading)
{
    m_lastGpsMessage = QStringLiteral("valido: %1\nlatitudine_gradi: %2\nlongitudine_gradi: %3\n"
                                      "quota_m: %4\nvelocita_kmh: %5\ndirezione_gradi: %6\n"
                                      "satelliti: %7\ntipo_fix: %8\ndata_utc_ddmmyy: %9\n"
                                      "ora_utc_ms: %10\ntimestamp_scheda_ms: %11")
                           .arg(reading.valid ? QStringLiteral("sì") : QStringLiteral("no"))
                           .arg(reading.latitudeDeg, 0, 'f', 7)
                           .arg(reading.longitudeDeg, 0, 'f', 7)
                           .arg(reading.altitudeM, 0, 'f', 2)
                           .arg(reading.speedKmh, 0, 'f', 2)
                           .arg(reading.headingDeg, 0, 'f', 2)
                           .arg(reading.satellites)
                           .arg(reading.fixType)
                           .arg(reading.utcDateDdmmyy)
                           .arg(reading.utcTimeMs)
                           .arg(reading.timestampMs);
}
