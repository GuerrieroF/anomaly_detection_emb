#pragma once

#include <QObject>
#include <QDir>
#include <QFile>
#include <QTimer>

class DeviceBattery : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int percentage READ percentage NOTIFY changed)
    Q_PROPERTY(bool charging READ charging NOTIFY changed)

public:
    explicit DeviceBattery(QObject *parent = nullptr) : QObject(parent)
    {
        connect(&m_timer, &QTimer::timeout, this, &DeviceBattery::refresh);
        m_timer.start(10000);
        refresh();
    }

    int percentage() const { return m_percentage; }
    bool charging() const { return m_charging; }

signals:
    void changed();

private:
    static QByteArray readAttribute(const QString &path)
    {
        QFile file(path);
        return file.open(QIODevice::ReadOnly) ? file.readAll().trimmed() : QByteArray();
    }

    void refresh()
    {
        int percentage = -1;
        bool charging = false;
        const QDir supplies(QStringLiteral("/sys/class/power_supply"));
        for (const auto &name : supplies.entryList(QDir::Dirs | QDir::NoDotAndDotDot)) {
            const QString path = supplies.filePath(name) + QLatin1Char('/');
            if (readAttribute(path + QStringLiteral("type")) != "Battery"
                || readAttribute(path + QStringLiteral("present")) == "0")
                continue;
            bool ok = false;
            const int capacity = readAttribute(path + QStringLiteral("capacity")).toInt(&ok);
            if (!ok || capacity < 0 || capacity > 100)
                continue;
            percentage = capacity;
            charging = readAttribute(path + QStringLiteral("status")) == "Charging";
            break;
        }
        if (m_percentage != percentage || m_charging != charging) {
            m_percentage = percentage;
            m_charging = charging;
            emit changed();
        }
    }

    QTimer m_timer;
    int m_percentage = -1;
    bool m_charging = false;
};
