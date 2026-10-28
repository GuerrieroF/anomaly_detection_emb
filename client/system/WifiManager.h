#pragma once

#include <QObject>
#include <QProcess>
#include <QTemporaryFile>
#include <QTimer>
#include <QVariantList>
#include <functional>
#include <memory>

// NetworkManager owns profiles and credentials; the UI only requests operations.
class WifiManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QVariantList networks READ networks NOTIFY changed)
    Q_PROPERTY(bool scanning READ scanning NOTIFY changed)
    Q_PROPERTY(bool connecting READ connecting NOTIFY changed)
    Q_PROPERTY(int attempt READ attempt NOTIFY changed)
    Q_PROPERTY(QString error READ error NOTIFY changed)
public:
    explicit WifiManager(QObject *parent = nullptr);
    QVariantList networks() const { return m_networks; }
    bool scanning() const { return m_scanning; }
    bool connecting() const { return m_connecting; }
    int attempt() const { return m_attempt; }
    QString error() const { return m_error; }
    Q_INVOKABLE void scan(bool rescan = true);
    Q_INVOKABLE void connectNetwork(const QString &ssid, const QString &security, const QString &password);
signals:
    void changed();
    void connectionFailed(const QString &message);
private:
    void run(const QStringList &args, std::function<void(bool, QByteArray)> done);
    void activate();
    void finish(bool success);
    QVariantList m_networks;
    QTimer m_poll;
    std::unique_ptr<QTemporaryFile> m_secret;
    QString m_profile;
    QString m_error;
    bool m_scanning = false;
    bool m_connecting = false;
    int m_attempt = 0;
};
