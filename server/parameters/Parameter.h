#pragma once
#include <QObject>
#include <QString>
#include <QVariant>

class Parameter : public QObject {
    Q_OBJECT
public:
    Parameter(const QString& id,
              const QString& type,
              const QVariant& defaultValue,
              const QVariant& min = {},
              const QVariant& max = {},
              const QString& unit = "",
              QObject* parent = nullptr);

    QString id() const;
    QString type() const;
    QVariant value() const;
    QVariant defaultValue() const;
    QVariant min() const;
    QVariant max() const;
    QString unit() const;

    bool setValue(const QVariant& newValue);
    void reset();

signals:
    void valueChanged(const QVariant& newValue);

private:
    QString m_id;
    QString m_type;
    QVariant m_value;
    QVariant m_defaultValue;
    QVariant m_min;
    QVariant m_max;
    QString m_unit;
};
