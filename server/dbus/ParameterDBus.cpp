#include "ParameterDBus.h"

ParameterDBus::ParameterDBus(Parameter* parameter,
                             ParameterManager* manager,
                             const QString& objectPath,
                             QDBusConnection connection,
                             QObject* parent)
    : QObject(parent),
    m_parameter(parameter),
    m_manager(manager)
{
    new ParameterAdaptor(this);
    connect(m_parameter, &Parameter::valueChanged, this, &ParameterDBus::ValueChanged);
    connection.registerObject(objectPath, this);
}

QString ParameterDBus::Id() const
{
    return m_parameter->id();
}

QString ParameterDBus::Unit() const
{
    return m_parameter->unit();
}

QString ParameterDBus::Type() const
{
    return m_parameter->typeName();
}

QVariant ParameterDBus::GetValue() const
{
    return m_parameter->value();
}

QVariant ParameterDBus::DefaultValue() const
{
    return m_parameter->defaultValue();
}

QVariant ParameterDBus::Min() const
{
    return m_parameter->min();
}

QVariant ParameterDBus::Max() const
{
    return m_parameter->max();
}

bool ParameterDBus::SetValue(const QVariant& value)
{
    return m_manager->setParameterValue(m_parameter->id(), value);
}

bool ParameterDBus::Reset()
{
    return m_manager->resetParameter(m_parameter->id());
}
