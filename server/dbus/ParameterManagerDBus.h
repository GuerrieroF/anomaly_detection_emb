#pragma once
#include <QObject>
#include <QtDBus/QDBusConnection>
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
    QString GetParameter(const QString& id);

private:
    ParameterManager* m_manager;
    QDBusConnection m_connection;
};
