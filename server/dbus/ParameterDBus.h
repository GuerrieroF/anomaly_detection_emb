#pragma once
#include <QObject>
#include <QtDBus/QDBusConnection>
#include "../parameters/Parameter.h"
#include "../parameters/ParameterManager.h"
#include "parameters_adaptor.h"  // generato da qdbusxml2cpp

class ParameterDBus : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString Id READ Id CONSTANT)
    Q_PROPERTY(QString Unit READ Unit CONSTANT)
    Q_PROPERTY(QString Type READ Type CONSTANT)
    Q_PROPERTY(QVariant Value READ GetValue NOTIFY ValueChanged)
    Q_PROPERTY(QVariant DefaultValue READ DefaultValue CONSTANT)
    Q_PROPERTY(QVariant Min READ Min CONSTANT)
    Q_PROPERTY(QVariant Max READ Max CONSTANT)
public:
    ParameterDBus(Parameter* parameter,
                  ParameterManager* manager,
                  const QString& objectPath,
                  QDBusConnection connection,
                  QObject* parent = nullptr);

public slots:
    QString Id() const;
    QString Unit() const;
    QString Type() const;
    QVariant GetValue() const;
    QVariant DefaultValue() const;
    QVariant Min() const;
    QVariant Max() const;
    bool SetValue(const QVariant& value);
    bool Reset();

signals:
    void ValueChanged(const QVariant& value);

private:
    Parameter* m_parameter;
    ParameterManager* m_manager;
};
