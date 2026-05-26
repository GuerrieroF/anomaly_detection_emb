#pragma once
#include <QObject>
#include <QMap>
#include <QVariant>
#include "Parameter.h"

class ParameterManager : public QObject {
    Q_OBJECT
public:
    explicit ParameterManager(QObject* parent = nullptr);

    QStringList listParameters() const;
    Parameter* getParameter(const QString& id);
    QVariant value(const QString& id) const;
    bool setParameterValue(const QString& id, const QVariant& value);
    bool resetParameter(const QString& id);
    bool load();
    bool save() const;
    QString storagePath() const;

signals:
    void parameterValueChanged(const QString& id, const QVariant& value);

private:
    void loadDefaults();
    void connectParameter(Parameter* parameter);
    QString resolveStoragePath() const;

    QMap<QString, Parameter*> m_parameters;
    QString m_storagePath;
};
