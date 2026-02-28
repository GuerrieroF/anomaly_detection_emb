#include "ParameterManagerDBus.h"

ParameterManagerDBus::ParameterManagerDBus(ParameterManager* manager,
                                           QDBusConnection connection,
                                           QObject* parent)
    : QObject(parent),
    m_manager(manager),
    m_connection(connection)
{
    new ParameterManagerAdaptor(this);
    m_connection.registerObject("/ParameterManager", this);
}

QStringList ParameterManagerDBus::ListParameters() {
    return m_manager->listParameters();
}

QString ParameterManagerDBus::GetParameter(const QString& id) {
    auto* param = m_manager->getParameter(id);
    if (!param)
        return QString();

    QString path = QString("/Parameter/%1").arg(id);
    new ParameterDBus(param, path, m_connection, this);
    return path;
}
