#include "ParameterManagerDBus.h"

#include <QRegularExpression>

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

QDBusObjectPath ParameterManagerDBus::GetParameter(const QString& id) {
    auto* param = m_manager->getParameter(id);
    if (!param)
        return QDBusObjectPath("/");

    const QString path = objectPathForId(id);
    if (!m_parameterObjects.contains(id)) {
        m_parameterObjects[id] = new ParameterDBus(param, m_manager, path, m_connection, this);
    }
    return QDBusObjectPath(path);
}

QVariantMap ParameterManagerDBus::GetParameterInfo(const QString& id)
{
    QVariantMap info;
    auto* parameter = m_manager->getParameter(id);
    if (!parameter) {
        return info;
    }

    info.insert(QStringLiteral("id"), parameter->id());
    info.insert(QStringLiteral("type"), parameter->typeName());
    info.insert(QStringLiteral("value"), parameter->value());
    info.insert(QStringLiteral("defaultValue"), parameter->defaultValue());
    info.insert(QStringLiteral("min"), parameter->min());
    info.insert(QStringLiteral("max"), parameter->max());
    info.insert(QStringLiteral("unit"), parameter->unit());
    info.insert(QStringLiteral("path"), objectPathForId(id));
    return info;
}

QString ParameterManagerDBus::objectPathForId(const QString& id) const
{
    QString safeId = id;
    safeId.replace(QRegularExpression(QStringLiteral("[^A-Za-z0-9_]")), QStringLiteral("_"));
    if (safeId.isEmpty()) {
        safeId = QStringLiteral("unknown");
    }
    return QStringLiteral("/Parameter/%1").arg(safeId);
}
