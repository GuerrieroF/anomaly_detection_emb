#include "TelemetryService.h"

#include "../uart/uart_protocol.h"

namespace {
constexpr double kAccelGPerLsbFs4g = 0.000122; // 0.122 mg/LSB
constexpr double kGyroDpsPerLsbFs1000dps = 0.035; // 35 mdps/LSB
} // namespace

namespace telemetry {

TelemetryService::TelemetryService(QObject* parent)
    : QObject(parent)
{
    qRegisterMetaType<telemetry::ImuReading>("telemetry::ImuReading");
    qRegisterMetaType<telemetry::GpsReading>("telemetry::GpsReading");
}

bool TelemetryService::hasImuReading() const
{
    return m_hasImuReading;
}

ImuReading TelemetryService::lastImuReading() const
{
    return m_lastImuReading;
}

bool TelemetryService::hasGpsReading() const
{
    return m_hasGpsReading;
}

GpsReading TelemetryService::lastGpsReading() const
{
    return m_lastGpsReading;
}

void TelemetryService::onRawImuSample(const uart::ImuSample& sample)
{
    ImuReading reading;
    reading.accelXG = static_cast<double>(sample.accelX) * kAccelGPerLsbFs4g;
    reading.accelYG = static_cast<double>(sample.accelY) * kAccelGPerLsbFs4g;
    reading.accelZG = static_cast<double>(sample.accelZ) * kAccelGPerLsbFs4g;
    reading.gyroXDps = static_cast<double>(sample.gyroX) * kGyroDpsPerLsbFs1000dps;
    reading.gyroYDps = static_cast<double>(sample.gyroY) * kGyroDpsPerLsbFs1000dps;
    reading.gyroZDps = static_cast<double>(sample.gyroZ) * kGyroDpsPerLsbFs1000dps;
    reading.rawAccelX = sample.accelX;
    reading.rawAccelY = sample.accelY;
    reading.rawAccelZ = sample.accelZ;
    reading.rawGyroX = sample.gyroX;
    reading.rawGyroY = sample.gyroY;
    reading.rawGyroZ = sample.gyroZ;
    reading.receivedMs = sample.receivedMs;

    m_lastImuReading = reading;
    m_hasImuReading = true;
    emit imuReadingUpdated(reading);
}

void TelemetryService::onRawGpsSample(const uart::GpsSample& sample)
{
    GpsReading reading;
    reading.latitudeDeg = sample.latitudeDegE7 / 10000000.0;
    reading.longitudeDeg = sample.longitudeDegE7 / 10000000.0;
    reading.altitudeM = sample.altitudeMm / 1000.0;
    reading.speedKmh = sample.speedCms * 0.036;
    reading.headingDeg = sample.headingCdeg / 100.0;
    reading.timestampMs = sample.timestampMs;
    reading.utcTimeMs = sample.utcTimeMs;
    reading.utcDateDdmmyy = sample.utcDateDdmmyy;
    reading.satellites = sample.satellites;
    reading.fixType = sample.fixType;
    reading.valid = sample.valid;
    reading.receivedMs = sample.receivedMs;

    m_lastGpsReading = reading;
    m_hasGpsReading = true;
    emit gpsReadingUpdated(reading);
}

} // namespace telemetry
