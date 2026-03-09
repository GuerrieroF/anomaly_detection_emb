#ifndef UART_PROTOCOL_H
#define UART_PROTOCOL_H

#include <QByteArray>
#include <QVector>
#include <QtTypes>

namespace uart {

namespace MessageType {
constexpr quint8 ImuSample = 0x01;
}

struct UartFrame
{
    quint8 type = 0;
    QByteArray payload;
    qint64 receivedMs = 0;
};

struct ImuSample
{
    qint16 accelX = 0;
    qint16 accelY = 0;
    qint16 accelZ = 0;
    qint16 gyroX = 0;
    qint16 gyroY = 0;
    qint16 gyroZ = 0;
    qint64 receivedMs = 0;
};

class UartProtocol
{
public:
    static quint16 crc16Ccitt(const QByteArray& data);
    static QByteArray encodeFrame(quint8 type, const QByteArray& payload);
};

class UartProtocolParser
{
public:
    QVector<UartFrame> parse(const QByteArray& chunk);

private:
    static constexpr int kMaxPayloadSize = 64;

    QByteArray m_buffer;
};

class ImuPayloadCodec
{
public:
    static bool decode(const UartFrame& frame, ImuSample* outSample);
};

} // namespace uart

#endif // UART_PROTOCOL_H
