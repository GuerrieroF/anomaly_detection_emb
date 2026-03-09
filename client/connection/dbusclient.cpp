#include "dbusclient.h"
#include <QtMath>

namespace {
double wrapDeg180(double angle)
{
    while (angle > 180.0) {
        angle -= 360.0;
    }
    while (angle < -180.0) {
        angle += 360.0;
    }
    return angle;
}
}

DBusClient::DBusClient(QObject *parent)
    : QObject{parent},
      iface(nullptr),
      m_imuPhysicalRegex("^IMU\\s+ax_g=(-?\\d+(?:\\.\\d+)?)\\s+ay_g=(-?\\d+(?:\\.\\d+)?)\\s+az_g=(-?\\d+(?:\\.\\d+)?)\\s+gx_dps=(-?\\d+(?:\\.\\d+)?)\\s+gy_dps=(-?\\d+(?:\\.\\d+)?)\\s+gz_dps=(-?\\d+(?:\\.\\d+)?)\\s+t=(\\d+).*"),
      m_imuRawRegex("^IMU\\s+ax=(-?\\d+)\\s+ay=(-?\\d+)\\s+az=(-?\\d+)\\s+gx=(-?\\d+)\\s+gy=(-?\\d+)\\s+gz=(-?\\d+)\\s+t=(\\d+)$"),
      m_serverAvailable(false),
      m_vehicleOffsetX(0.0),
      m_vehicleTiltDeg(0.0),
      m_accelXg(0.0),
      m_accelYg(0.0),
      m_accelZg(0.0),
      m_linearAccelXg(0.0),
      m_linearAccelYg(0.0),
      m_linearAccelZg(0.0),
      m_tiltXDeg(0.0),
      m_tiltYDeg(0.0),
      m_tiltZDeg(0.0),
      m_gravityXg(0.0),
      m_gravityYg(0.0),
      m_gravityZg(1.0),
      m_lastTimestampMs(-1)
{
    retryTimer.setInterval(1000);
    connect(&retryTimer, &QTimer::timeout, this, &DBusClient::tryConnect);

    pollTimer.setInterval(40);
    connect(&pollTimer, &QTimer::timeout, this, &DBusClient::pollServer);
    pollTimer.start();

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

double DBusClient::vehicleOffsetX() const
{
    return m_vehicleOffsetX;
}

double DBusClient::vehicleTiltDeg() const
{
    return m_vehicleTiltDeg;
}

double DBusClient::accelXg() const
{
    return m_accelXg;
}

double DBusClient::accelYg() const
{
    return m_accelYg;
}

double DBusClient::accelZg() const
{
    return m_accelZg;
}

double DBusClient::linearAccelXg() const
{
    return m_linearAccelXg;
}

double DBusClient::linearAccelYg() const
{
    return m_linearAccelYg;
}

double DBusClient::linearAccelZg() const
{
    return m_linearAccelZg;
}

double DBusClient::tiltXDeg() const
{
    return m_tiltXDeg;
}

double DBusClient::tiltYDeg() const
{
    return m_tiltYDeg;
}

double DBusClient::tiltZDeg() const
{
    return m_tiltZDeg;
}

QString DBusClient::latestMessage() const
{
    return m_latestMessage;
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

void DBusClient::pollServer()
{
    const QString message = fetchMessage();
    updateFromMessage(message);
}

void DBusClient::updateFromMessage(const QString& message)
{
    if (m_latestMessage != message) {
        m_latestMessage = message;
        emit latestMessageChanged();
    }

    double newOffsetX = m_vehicleOffsetX;
    double newTiltDeg = m_vehicleTiltDeg;
    double newAccelXg = m_accelXg;
    double newAccelYg = m_accelYg;
    double newAccelZg = m_accelZg;
    double gxDps = 0.0;
    double gyDps = 0.0;
    double gzDps = 0.0;
    const double maxAccelG = 4.0;
    const double rawAccelLsbPerG = 8192.0;
    qint64 timestampMs = m_lastTimestampMs;
    bool parsed = false;

    const QRegularExpressionMatch physicalMatch = m_imuPhysicalRegex.match(message);
    if (physicalMatch.hasMatch()) {
        bool okAx = false;
        bool okAy = false;
        bool okAz = false;
        bool okGx = false;
        bool okGy = false;
        bool okGz = false;
        bool okT = false;
        const double axG = physicalMatch.captured(1).toDouble(&okAx);
        const double ayG = physicalMatch.captured(2).toDouble(&okAy);
        const double azG = physicalMatch.captured(3).toDouble(&okAz);
        gxDps = physicalMatch.captured(4).toDouble(&okGx);
        gyDps = physicalMatch.captured(5).toDouble(&okGy);
        gzDps = physicalMatch.captured(6).toDouble(&okGz);
        timestampMs = physicalMatch.captured(7).toLongLong(&okT);
        if (okAx && okAy && okAz && okGx && okGy && okGz && okT) {
            newAccelXg = qBound(-maxAccelG, axG, maxAccelG);
            newAccelYg = qBound(-maxAccelG, ayG, maxAccelG);
            newAccelZg = qBound(-maxAccelG, azG, maxAccelG);
            parsed = true;
        }
    } else {
        const QRegularExpressionMatch rawMatch = m_imuRawRegex.match(message);
        if (!rawMatch.hasMatch()) {
            return;
        }
        bool okAx = false;
        bool okAy = false;
        bool okAz = false;
        bool okGx = false;
        bool okGy = false;
        bool okGz = false;
        bool okT = false;
        const double axRaw = rawMatch.captured(1).toDouble(&okAx);
        const double ayRaw = rawMatch.captured(2).toDouble(&okAy);
        const double azRaw = rawMatch.captured(3).toDouble(&okAz);
        const double gxRaw = rawMatch.captured(4).toDouble(&okGx);
        const double gyRaw = rawMatch.captured(5).toDouble(&okGy);
        const double gzRaw = rawMatch.captured(6).toDouble(&okGz);
        timestampMs = rawMatch.captured(7).toLongLong(&okT);
        if (!okAx || !okAy || !okAz || !okGx || !okGy || !okGz || !okT) {
            return;
        }

        newAccelXg = qBound(-maxAccelG, axRaw / rawAccelLsbPerG, maxAccelG);
        newAccelYg = qBound(-maxAccelG, ayRaw / rawAccelLsbPerG, maxAccelG);
        newAccelZg = qBound(-maxAccelG, azRaw / rawAccelLsbPerG, maxAccelG);
        gxDps = gxRaw / 131.0;
        gyDps = gyRaw / 131.0;
        gzDps = gzRaw / 131.0;
        parsed = true;
    }

    if (!parsed) {
        return;
    }

    double dtSec = 0.0;
    if (m_lastTimestampMs >= 0 && timestampMs > m_lastTimestampMs) {
        dtSec = (timestampMs - m_lastTimestampMs) / 1000.0;
    }
    m_lastTimestampMs = timestampMs;

    const double gravityAlpha = 0.92;
    const double invGravityAlpha = 1.0 - gravityAlpha;
    const double newGravityX = gravityAlpha * m_gravityXg + invGravityAlpha * newAccelXg;
    const double newGravityY = gravityAlpha * m_gravityYg + invGravityAlpha * newAccelYg;
    const double newGravityZ = gravityAlpha * m_gravityZg + invGravityAlpha * newAccelZg;

    const double newLinearX = qBound(-maxAccelG, newAccelXg - newGravityX, maxAccelG);
    const double newLinearY = qBound(-maxAccelG, newAccelYg - newGravityY, maxAccelG);
    const double newLinearZ = qBound(-maxAccelG, newAccelZg - newGravityZ, maxAccelG);

    const double rollAccDeg = qRadiansToDegrees(qAtan2(newGravityY, newGravityZ));
    const double pitchAccDeg = qRadiansToDegrees(qAtan2(-newGravityX, qSqrt(newGravityY * newGravityY + newGravityZ * newGravityZ)));

    double newTiltX = m_tiltXDeg;
    double newTiltY = m_tiltYDeg;
    double newTiltZ = m_tiltZDeg;

    if (dtSec > 0.0 && dtSec < 0.2) {
        const double compAlpha = 0.98;
        newTiltX = compAlpha * (m_tiltXDeg + gxDps * dtSec) + (1.0 - compAlpha) * rollAccDeg;
        newTiltY = compAlpha * (m_tiltYDeg + gyDps * dtSec) + (1.0 - compAlpha) * pitchAccDeg;
        newTiltZ = wrapDeg180(m_tiltZDeg + gzDps * dtSec);
    } else {
        newTiltX = rollAccDeg;
        newTiltY = pitchAccDeg;
    }
    newTiltX = qBound(-90.0, newTiltX, 90.0);
    newTiltY = qBound(-90.0, newTiltY, 90.0);

    newOffsetX = qBound(-180.0, newLinearY * 120.0, 180.0);
    newTiltDeg = qBound(-40.0, newTiltY, 40.0);

    if (!qFuzzyCompare(m_vehicleOffsetX, newOffsetX) || !qFuzzyCompare(m_vehicleTiltDeg, newTiltDeg)) {
        m_vehicleOffsetX = newOffsetX;
        m_vehicleTiltDeg = newTiltDeg;
        emit vehicleStateChanged();
    }

    m_gravityXg = newGravityX;
    m_gravityYg = newGravityY;
    m_gravityZg = newGravityZ;

    if (!qFuzzyCompare(m_accelXg, newAccelXg) ||
        !qFuzzyCompare(m_accelYg, newAccelYg) ||
        !qFuzzyCompare(m_accelZg, newAccelZg) ||
        !qFuzzyCompare(m_linearAccelXg, newLinearX) ||
        !qFuzzyCompare(m_linearAccelYg, newLinearY) ||
        !qFuzzyCompare(m_linearAccelZg, newLinearZ) ||
        !qFuzzyCompare(m_tiltXDeg, newTiltX) ||
        !qFuzzyCompare(m_tiltYDeg, newTiltY) ||
        !qFuzzyCompare(m_tiltZDeg, newTiltZ)) {
        m_accelXg = newAccelXg;
        m_accelYg = newAccelYg;
        m_accelZg = newAccelZg;
        m_linearAccelXg = newLinearX;
        m_linearAccelYg = newLinearY;
        m_linearAccelZg = newLinearZ;
        m_tiltXDeg = newTiltX;
        m_tiltYDeg = newTiltY;
        m_tiltZDeg = newTiltZ;
        emit imuDataChanged();
    }
}
