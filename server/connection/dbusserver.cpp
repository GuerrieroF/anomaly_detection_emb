#include "dbusserver.h"

#include <QDebug>
#include <QProcessEnvironment>
#include <QtDBus/QDBusConnection>
#include "../uart/uart_receiver.h"

namespace {
constexpr double kAccelGPerLsbFs4g = 0.000122; // 0.122 mg/LSB
constexpr double kGyroDpsPerLsbFs1000dps = 0.035; // 35 mdps/LSB
}

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

    m_receiver = new uart::UartReceiver(m_uartPort, m_uartBaud, this);
    connect(m_receiver, &uart::UartReceiver::imuSampleReceived, this, &DBusServer::onImuSample);
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

void DBusServer::onImuSample(const uart::ImuSample& sample)
{
    const double axG = static_cast<double>(sample.accelX) * kAccelGPerLsbFs4g;
    const double ayG = static_cast<double>(sample.accelY) * kAccelGPerLsbFs4g;
    const double azG = static_cast<double>(sample.accelZ) * kAccelGPerLsbFs4g;
    const double gxDps = static_cast<double>(sample.gyroX) * kGyroDpsPerLsbFs1000dps;
    const double gyDps = static_cast<double>(sample.gyroY) * kGyroDpsPerLsbFs1000dps;
    const double gzDps = static_cast<double>(sample.gyroZ) * kGyroDpsPerLsbFs1000dps;

    m_lastImuMessage = QString("IMU ax_g=%1 ay_g=%2 az_g=%3 gx_dps=%4 gy_dps=%5 gz_dps=%6 t=%7 "
                               "raw_ax=%8 raw_ay=%9 raw_az=%10 raw_gx=%11 raw_gy=%12 raw_gz=%13")
                           .arg(axG, 0, 'f', 4)
                           .arg(ayG, 0, 'f', 4)
                           .arg(azG, 0, 'f', 4)
                           .arg(gxDps, 0, 'f', 2)
                           .arg(gyDps, 0, 'f', 2)
                           .arg(gzDps, 0, 'f', 2)
                           .arg(sample.receivedMs)
                           .arg(sample.accelX)
                           .arg(sample.accelY)
                           .arg(sample.accelZ)
                           .arg(sample.gyroX)
                           .arg(sample.gyroY)
                           .arg(sample.gyroZ);
}
