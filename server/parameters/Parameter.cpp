#include "Parameter.h"

Parameter::Parameter(const QString& id,
                     const QString& type,
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
QString Parameter::type() const { return m_type; }
QVariant Parameter::value() const { return m_value; }
QVariant Parameter::defaultValue() const { return m_defaultValue; }
QVariant Parameter::min() const { return m_min; }
QVariant Parameter::max() const { return m_max; }
QString Parameter::unit() const { return m_unit; }

bool Parameter::setValue(const QVariant& newValue) {
    if (newValue != m_value) {
        m_value = newValue;
        emit valueChanged(newValue);
        return true;
    }
    return false;
}

void Parameter::reset() {
    m_value = m_defaultValue;
    emit valueChanged(m_value);
}
