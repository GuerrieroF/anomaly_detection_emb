#include "Parameter.h"

Parameter::Parameter(const QString& id,
                     ParameterType type,
                     const QVariant& defaultValue,
                     const QVariant& min,
                     const QVariant& max,
                     const QString& unit,
                     QObject* parent)
    : QObject(parent),
    m_id(id),
    m_type(type),
    m_value(defaultValue),
    m_defaultValue(defaultValue),
    m_min(min),
    m_max(max),
    m_unit(unit)
{}

QString Parameter::id() const { return m_id; }
ParameterType Parameter::type() const { return m_type; }
QString Parameter::typeName() const { return parameterTypeToString(m_type); }
QVariant Parameter::value() const { return m_value; }
QVariant Parameter::defaultValue() const { return m_defaultValue; }
QVariant Parameter::min() const { return m_min; }
QVariant Parameter::max() const { return m_max; }
QString Parameter::unit() const { return m_unit; }

bool Parameter::setValue(const QVariant& newValue) {
    bool ok = false;
    const QVariant normalized = normalizedValue(newValue, &ok);
    if (!ok) {
        return false;
    }

    if (normalized == m_value) {
        return true;
    }

    m_value = normalized;
    emit valueChanged(normalized);
    return true;
}

void Parameter::reset() {
    setValue(m_defaultValue);
}

bool Parameter::isValid(const QVariant& value) const
{
    bool ok = false;
    normalizedValue(value, &ok);
    return ok;
}

QVariant Parameter::normalizedValue(const QVariant& value, bool* ok) const
{
    bool converted = false;
    QVariant normalized;

    switch (m_type) {
    case ParameterType::UInt8: {
        const uint numericValue = value.toUInt(&converted);
        converted = converted && numericValue <= 255U;
        normalized = QVariant::fromValue(static_cast<uint>(numericValue));
        break;
    }
    case ParameterType::Int:
        normalized = value.toInt(&converted);
        break;
    case ParameterType::Double:
        normalized = value.toDouble(&converted);
        break;
    case ParameterType::Bool:
        normalized = value.toBool();
        converted = value.canConvert<bool>();
        break;
    case ParameterType::String:
        normalized = value.toString();
        converted = value.canConvert<QString>();
        break;
    }

    if (!converted) {
        if (ok) {
            *ok = false;
        }
        return {};
    }

    if (m_min.isValid() && m_type != ParameterType::String) {
        if (normalized.toDouble() < m_min.toDouble()) {
            if (ok) {
                *ok = false;
            }
            return {};
        }
    }

    if (m_max.isValid() && m_type != ParameterType::String) {
        if (normalized.toDouble() > m_max.toDouble()) {
            if (ok) {
                *ok = false;
            }
            return {};
        }
    }

    if (ok) {
        *ok = true;
    }
    return normalized;
}
