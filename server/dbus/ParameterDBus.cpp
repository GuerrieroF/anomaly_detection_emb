#include "ParameterDBus.h"

ParameterDBus::ParameterDBus(Parameter* parameter,
                             const QString& objectPath,
                             QDBusConnection connection,
                             QObject* parent)
    : QObject(parent),
    m_parameter(parameter)
{
    new ParameterAdaptor(this);
    connection.registerObject(objectPath, this);
}
