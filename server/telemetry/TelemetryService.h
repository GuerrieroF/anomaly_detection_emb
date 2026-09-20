#pragma once

#include <QObject>
#include <QtGlobal>

namespace uart {
struct ImuSample;
struct GpsSample;
}

namespace telemetry {

struct ImuReading
{
    double accelXG = 0.0;
    double accelYG = 0.0;
    double accelZG = 0.0;
    double gyroXDps = 0.0;
    double gyroYDps = 0.0;
    double gyroZDps = 0.0;
    qint16 rawAccelX = 0;
    qint16 rawAccelY = 0;
    qint16 rawAccelZ = 0;
    qint16 rawGyroX = 0;
    qint16 rawGyroY = 0;
    qint16 rawGyroZ = 0;
    qint64 receivedMs = 0;
};

struct GpsReading
{
    double latitudeDeg = 0.0;
    double longitudeDeg = 0.0;
    double altitudeM = 0.0;
    double speedKmh = 0.0;
    double headingDeg = 0.0;
    quint32 timestampMs = 0;
    quint32 utcTimeMs = 0;
    quint32 utcDateDdmmyy = 0;
    quint8 satellites = 0;
    quint8 fixType = 0;
    bool valid = false;
    qint64 receivedMs = 0;
};

class TelemetryService : public QObject
{
    Q_OBJECT
public:
    explicit TelemetryService(QObject* parent = nullptr);

    bool hasImuReading() const;
    ImuReading lastImuReading() const;
    bool hasGpsReading() const;
    GpsReading lastGpsReading() const;

public slots:
    void onRawImuSample(const uart::ImuSample& sample);
    void onRawGpsSample(const uart::GpsSample& sample);

signals:
    void imuReadingUpdated(const telemetry::ImuReading& reading);
    void gpsReadingUpdated(const telemetry::GpsReading& reading);

private:
    ImuReading m_lastImuReading;
    bool m_hasImuReading = false;
    GpsReading m_lastGpsReading;
    bool m_hasGpsReading = false;
};

} // namespace telemetry

Q_DECLARE_METATYPE(telemetry::ImuReading)
Q_DECLARE_METATYPE(telemetry::GpsReading)
