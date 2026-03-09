#ifndef DBUSCLIENT_H
#define DBUSCLIENT_H

#include <QObject>
#include <QTimer>
#include <QRegularExpression>
#include <QtDBus/QDBusInterface>
#include <QtDBus/QDBusReply>
#include <QtDBus/QDBusError>
#include <QtGlobal>

class DBusClient : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool serverAvailable READ serverAvailable NOTIFY serverAvailabilityChanged)
    Q_PROPERTY(double vehicleOffsetX READ vehicleOffsetX NOTIFY vehicleStateChanged)
    Q_PROPERTY(double vehicleTiltDeg READ vehicleTiltDeg NOTIFY vehicleStateChanged)
    Q_PROPERTY(double accelXg READ accelXg NOTIFY imuDataChanged)
    Q_PROPERTY(double accelYg READ accelYg NOTIFY imuDataChanged)
    Q_PROPERTY(double accelZg READ accelZg NOTIFY imuDataChanged)
    Q_PROPERTY(double linearAccelXg READ linearAccelXg NOTIFY imuDataChanged)
    Q_PROPERTY(double linearAccelYg READ linearAccelYg NOTIFY imuDataChanged)
    Q_PROPERTY(double linearAccelZg READ linearAccelZg NOTIFY imuDataChanged)
    Q_PROPERTY(double tiltXDeg READ tiltXDeg NOTIFY imuDataChanged)
    Q_PROPERTY(double tiltYDeg READ tiltYDeg NOTIFY imuDataChanged)
    Q_PROPERTY(double tiltZDeg READ tiltZDeg NOTIFY imuDataChanged)
    Q_PROPERTY(QString latestMessage READ latestMessage NOTIFY latestMessageChanged)
public:
    explicit DBusClient(QObject *parent = nullptr);
    ~DBusClient(){}

    Q_INVOKABLE QString fetchMessage();
    bool serverAvailable() const;
    double vehicleOffsetX() const;
    double vehicleTiltDeg() const;
    double accelXg() const;
    double accelYg() const;
    double accelZg() const;
    double linearAccelXg() const;
    double linearAccelYg() const;
    double linearAccelZg() const;
    double tiltXDeg() const;
    double tiltYDeg() const;
    double tiltZDeg() const;
    QString latestMessage() const;

signals:
    void serverAvailabilityChanged();
    void vehicleStateChanged();
    void imuDataChanged();
    void latestMessageChanged();

private:
    void tryConnect();
    void pollServer();
    bool isInterfaceReady() const;
    void updateFromMessage(const QString& message);

    QDBusInterface *iface;
    QTimer retryTimer;
    QTimer pollTimer;
    QRegularExpression m_imuPhysicalRegex;
    QRegularExpression m_imuRawRegex;
    bool m_serverAvailable;
    double m_vehicleOffsetX;
    double m_vehicleTiltDeg;
    double m_accelXg;
    double m_accelYg;
    double m_accelZg;
    double m_linearAccelXg;
    double m_linearAccelYg;
    double m_linearAccelZg;
    double m_tiltXDeg;
    double m_tiltYDeg;
    double m_tiltZDeg;
    double m_gravityXg;
    double m_gravityYg;
    double m_gravityZg;
    qint64 m_lastTimestampMs;
    QString m_latestMessage;
};

#endif // DBUSCLIENT_H
