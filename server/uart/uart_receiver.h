#ifndef UART_RECEIVER_H
#define UART_RECEIVER_H

#include <QObject>
#include <QSerialPort>

#include "uart_protocol.h"

namespace uart {

class UartReceiver : public QObject
{
    Q_OBJECT
public:
    explicit UartReceiver(const QString& portName, qint32 baudRate, QObject* parent = nullptr);

    bool start();
    bool isOpen() const;
    QString portName() const;
    QString lastError() const;

signals:
    void imuSampleReceived(const uart::ImuSample& sample);
    void frameReceived(const uart::UartFrame& frame);
    void receiverError(const QString& errorText);

private slots:
    void onReadyRead();

private:
    void dispatchFrame(const UartFrame& frame);

    QSerialPort m_serial;
    UartProtocolParser m_parser;
};

} // namespace uart

#endif // UART_RECEIVER_H
