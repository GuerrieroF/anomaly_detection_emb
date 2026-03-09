#include "uart_protocol.h"

#include <QDateTime>
#include <QtEndian>

namespace {
constexpr char kSof0 = static_cast<char>(0xAA);
constexpr char kSof1 = static_cast<char>(0x55);
constexpr int kHeaderSize = 4; // SOF0, SOF1, TYPE, LEN
constexpr int kCrcSize = 2;
constexpr int kMinFrameSize = kHeaderSize + kCrcSize;
constexpr int kImuPayloadSize = 12;
} // namespace

namespace uart {

quint16 UartProtocol::crc16Ccitt(const QByteArray& data)
{
    quint16 crc = 0xFFFF;
    for (const char value : data) {
        crc ^= static_cast<quint8>(value) << 8;
        for (int i = 0; i < 8; ++i) {
            if (crc & 0x8000) {
                crc = static_cast<quint16>((crc << 1) ^ 0x1021);
            } else {
                crc <<= 1;
            }
        }
    }
    return crc;
}

QByteArray UartProtocol::encodeFrame(quint8 type, const QByteArray& payload)
{
    QByteArray frame;
    frame.reserve(kHeaderSize + payload.size() + kCrcSize);
    frame.append(kSof0);
    frame.append(kSof1);
    frame.append(static_cast<char>(type));
    frame.append(static_cast<char>(payload.size()));
    frame.append(payload);

    QByteArray crcData;
    crcData.reserve(2 + payload.size());
    crcData.append(static_cast<char>(type));
    crcData.append(static_cast<char>(payload.size()));
    crcData.append(payload);

    const quint16 crc = crc16Ccitt(crcData);
    const char lo = static_cast<char>(crc & 0xFF);
    const char hi = static_cast<char>((crc >> 8) & 0xFF);
    frame.append(lo);
    frame.append(hi);
    return frame;
}

QVector<UartFrame> UartProtocolParser::parse(const QByteArray& chunk)
{
    QVector<UartFrame> frames;
    if (!chunk.isEmpty()) {
        m_buffer.append(chunk);
    }

    while (m_buffer.size() >= kMinFrameSize) {
        const int sofIndex = m_buffer.indexOf(QByteArray() + kSof0 + kSof1);
        if (sofIndex < 0) {
            m_buffer.clear();
            break;
        }

        if (sofIndex > 0) {
            m_buffer.remove(0, sofIndex);
        }

        if (m_buffer.size() < kMinFrameSize) {
            break;
        }

        const quint8 frameType = static_cast<quint8>(m_buffer.at(2));
        const quint8 payloadSize = static_cast<quint8>(m_buffer.at(3));
        if (payloadSize > kMaxPayloadSize) {
            m_buffer.remove(0, 2);
            continue;
        }

        const int frameSize = kHeaderSize + payloadSize + kCrcSize;
        if (m_buffer.size() < frameSize) {
            break;
        }

        const QByteArray crcData = m_buffer.mid(2, 2 + payloadSize); // TYPE, LEN, PAYLOAD
        const quint16 expectedCrc = UartProtocol::crc16Ccitt(crcData);
        const quint16 receivedCrc = qFromLittleEndian<quint16>(
            reinterpret_cast<const uchar*>(m_buffer.constData() + 4 + payloadSize));

        if (expectedCrc != receivedCrc) {
            m_buffer.remove(0, 2);
            continue;
        }

        UartFrame frame;
        frame.type = frameType;
        frame.payload = m_buffer.mid(4, payloadSize);
        frame.receivedMs = QDateTime::currentMSecsSinceEpoch();
        frames.push_back(frame);

        m_buffer.remove(0, frameSize);
    }

    return frames;
}

bool ImuPayloadCodec::decode(const UartFrame& frame, ImuSample* outSample)
{
    if (!outSample || frame.type != MessageType::ImuSample || frame.payload.size() != kImuPayloadSize) {
        return false;
    }

    const auto* raw = reinterpret_cast<const uchar*>(frame.payload.constData());
    outSample->accelX = qFromLittleEndian<qint16>(raw + 0);
    outSample->accelY = qFromLittleEndian<qint16>(raw + 2);
    outSample->accelZ = qFromLittleEndian<qint16>(raw + 4);
    outSample->gyroX = qFromLittleEndian<qint16>(raw + 6);
    outSample->gyroY = qFromLittleEndian<qint16>(raw + 8);
    outSample->gyroZ = qFromLittleEndian<qint16>(raw + 10);
    outSample->receivedMs = frame.receivedMs;
    return true;
}

} // namespace uart
