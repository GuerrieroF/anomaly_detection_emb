#pragma once
#include <QObject>
#include <QMap>
#include "Parameter.h"

class ParameterManager : public QObject {
    Q_OBJECT
public:
    explicit ParameterManager(QObject* parent = nullptr);

    QStringList listParameters() const;
    Parameter* getParameter(const QString& id);

private:
    QMap<QString, Parameter*> m_parameters;
};
