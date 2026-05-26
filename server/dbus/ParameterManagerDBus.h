#pragma once
#include <QObject>
#include <QMap>
#include <QVariantMap>
#include <QtDBus/QDBusConnection>
#include <QtDBus/QDBusObjectPath>
#include "../parameters/ParameterManager.h"
#include "parameters_adaptor.h" // generato da qdbusxml2cpp
#include "ParameterDBus.h"

class ParameterManagerDBus : public QObject {
    Q_OBJECT
public:
    explicit ParameterManagerDBus(ParameterManager* manager,
                                  QDBusConnection connection,
                                  QObject* parent = nullptr);

public slots:
    QStringList ListParameters();
    QDBusObjectPath GetParameter(const QString& id);
    QVariantMap GetParameterInfo(const QString& id);

private:
    QString objectPathForId(const QString& id) const;

    ParameterManager* m_manager;
    QDBusConnection m_connection;
    QMap<QString, ParameterDBus*> m_parameterObjects;
};
