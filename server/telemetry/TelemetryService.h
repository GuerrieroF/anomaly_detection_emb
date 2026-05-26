#pragma once

#include <QObject>
#include <QtGlobal>

namespace uart {
struct ImuSample;
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

class TelemetryService : public QObject
{
    Q_OBJECT
public:
    explicit TelemetryService(QObject* parent = nullptr);

    bool hasImuReading() const;
    ImuReading lastImuReading() const;

public slots:
    void onRawImuSample(const uart::ImuSample& sample);

signals:
    void imuReadingUpdated(const telemetry::ImuReading& reading);

private:
    ImuReading m_lastImuReading;
    bool m_hasImuReading = false;
};

} // namespace telemetry

Q_DECLARE_METATYPE(telemetry::ImuReading)
