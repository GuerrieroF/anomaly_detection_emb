#pragma once
#include <QObject>
#include <QtDBus/QDBusConnection>
#include "../parameters/Parameter.h"
#include "parameters_adaptor.h"  // generato da qdbusxml2cpp

class ParameterDBus : public QObject {
    Q_OBJECT
public:
    ParameterDBus(Parameter* parameter,
                  const QString& objectPath,
                  QDBusConnection connection,
                  QObject* parent = nullptr);

private:
    Parameter* m_parameter;
};
