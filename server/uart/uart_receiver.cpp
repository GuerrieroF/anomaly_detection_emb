#include "uart_receiver.h"

namespace uart {

UartReceiver::UartReceiver(const QString& portName, qint32 baudRate, QObject* parent)
    : QObject(parent)
{
    m_serial.setPortName(portName);
    m_serial.setBaudRate(baudRate);
    m_serial.setDataBits(QSerialPort::Data8);
    m_serial.setParity(QSerialPort::NoParity);
    m_serial.setStopBits(QSerialPort::OneStop);
    m_serial.setFlowControl(QSerialPort::NoFlowControl);

    connect(&m_serial, &QSerialPort::readyRead, this, &UartReceiver::onReadyRead);
}

bool UartReceiver::start()
{
    if (m_serial.isOpen()) {
        return true;
    }

    const bool opened = m_serial.open(QIODevice::ReadOnly);
    if (!opened) {
        emit receiverError(m_serial.errorString());
    }
    return opened;
}

bool UartReceiver::isOpen() const
{
    return m_serial.isOpen();
}

QString UartReceiver::portName() const
{
    return m_serial.portName();
}

QString UartReceiver::lastError() const
{
    return m_serial.errorString();
}

void UartReceiver::onReadyRead()
{
    const QByteArray chunk = m_serial.readAll();
    const QVector<UartFrame> frames = m_parser.parse(chunk);
    for (const UartFrame& frame : frames) {
        dispatchFrame(frame);
    }
}

void UartReceiver::dispatchFrame(const UartFrame& frame)
{
    emit frameReceived(frame);

    switch (frame.type) {
    case MessageType::ImuSample: {
        ImuSample sample;
        if (ImuPayloadCodec::decode(frame, &sample)) {
            emit imuSampleReceived(sample);
        }
        break;
    }
    default:
        break;
    }
}

} // namespace uart
