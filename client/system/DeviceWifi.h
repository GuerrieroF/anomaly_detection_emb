#pragma once

#include <QObject>
#include <QDir>
#include <QFile>
#include <QTimer>

class DeviceWifi : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool available READ available NOTIFY changed)
    Q_PROPERTY(bool connected READ connected NOTIFY changed)
    Q_PROPERTY(int signalBars READ signalBars NOTIFY changed)

public:
    explicit DeviceWifi(QObject *parent = nullptr) : QObject(parent)
    {
        connect(&m_timer, &QTimer::timeout, this, &DeviceWifi::refresh);
        m_timer.start(5000);
        refresh();
    }

    bool available() const { return m_available; }
    bool connected() const { return m_connected; }
    int signalBars() const { return m_signalBars; }

signals:
    void changed();

private:
    void refresh()
    {
        bool available = false;
        bool connected = false;
        int bars = 0;
        const QDir interfaces(QStringLiteral("/sys/class/net"));
        QFile wireless(QStringLiteral("/proc/net/wireless"));
        const QByteArray readings = wireless.open(QIODevice::ReadOnly) ? wireless.readAll() : QByteArray();
        for (const auto &name : interfaces.entryList(QDir::Dirs | QDir::NoDotAndDotDot)) {
            const QString path = interfaces.filePath(name);
            if (!QDir(path + QStringLiteral("/wireless")).exists())
                continue;
            available = true;
            QFile carrier(path + QStringLiteral("/carrier"));
            if (!carrier.open(QIODevice::ReadOnly) || carrier.readAll().trimmed() != "1")
                continue;
            connected = true;
            for (const auto &line : readings.split('\n')) {
                const int colon = line.indexOf(':');
                if (colon < 0 || line.left(colon).trimmed() != name.toLocal8Bit())
                    continue;
                const auto fields = line.mid(colon + 1).simplified().split(' ');
                if (fields.size() < 2)
                    continue;
                bool ok = false;
                const double quality = fields.at(1).toDouble(&ok);
                if (ok && quality > 0)
                    bars = qMax(bars, quality < 24 ? 1 : quality < 47 ? 2 : 3);
            }
        }
        if (m_available != available || m_connected != connected || m_signalBars != bars) {
            m_available = available;
            m_connected = connected;
            m_signalBars = bars;
            emit changed();
        }
    }

    QTimer m_timer;
    bool m_available = false;
    bool m_connected = false;
    int m_signalBars = 0;
};
