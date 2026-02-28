#include "ParameterManager.h"
#include "ParameterLut.h"

ParameterManager::ParameterManager(QObject* parent)
    : QObject(parent)
{
    for (auto* param : ParameterLut::defaults(this)) {
        m_parameters[param->id()] = param;
    }
}

QStringList ParameterManager::listParameters() const {
    return m_parameters.keys();
}

Parameter* ParameterManager::getParameter(const QString& id) {
    return m_parameters.value(id, nullptr);
}
