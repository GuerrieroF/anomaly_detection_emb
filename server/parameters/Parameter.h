#pragma once
#include <QObject>
#include <QString>
#include <QVariant>
#include "ParameterType.h"

class Parameter : public QObject {
    Q_OBJECT
public:
    Parameter(const QString& id,
              ParameterType type,
              const QVariant& defaultValue,
              const QVariant& min = {},
              const QVariant& max = {},
              const QString& unit = "",
              QObject* parent = nullptr);

    QString id() const;
    ParameterType type() const;
    QString typeName() const;
    QVariant value() const;
    QVariant defaultValue() const;
    QVariant min() const;
    QVariant max() const;
    QString unit() const;

    bool setValue(const QVariant& newValue);
    void reset();
    bool isValid(const QVariant& value) const;
    QVariant normalizedValue(const QVariant& value, bool* ok = nullptr) const;

signals:
    void valueChanged(const QVariant& newValue);

private:
    QString m_id;
    ParameterType m_type;
    QVariant m_value;
    QVariant m_defaultValue;
    QVariant m_min;
    QVariant m_max;
    QString m_unit;
};
