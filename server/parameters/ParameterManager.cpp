#include "ParameterManager.h"
#include "ParameterLut.h"

#include <QCoreApplication>
#include <QCborMap>
#include <QCborValue>
#include <QDebug>
#include <QDir>
#include <QFile>
#include <QFileInfo>
#include <QProcessEnvironment>
#include <QSaveFile>
#include <QStandardPaths>

namespace {
constexpr int kStorageVersion = 1;
constexpr auto kVersionKey = "version";
constexpr auto kValuesKey = "values";
constexpr auto kParameterFileEnv = "ANOMALY_PARAMETER_FILE";
constexpr auto kDefaultFileName = "parameters.cbor";
} // namespace

ParameterManager::ParameterManager(QObject* parent)
    : QObject(parent)
{
    m_storagePath = resolveStoragePath();
    loadDefaults();
    load();
}

QStringList ParameterManager::listParameters() const
{
    return m_parameters.keys();
}

Parameter* ParameterManager::getParameter(const QString& id)
{
    return m_parameters.value(id, nullptr);
}

QVariant ParameterManager::value(const QString& id) const
{
    const auto* parameter = m_parameters.value(id, nullptr);
    return parameter ? parameter->value() : QVariant();
}

bool ParameterManager::setParameterValue(const QString& id, const QVariant& value)
{
    auto* parameter = getParameter(id);
    if (!parameter || !parameter->isValid(value)) {
        return false;
    }

    const QVariant previous = parameter->value();
    if (!parameter->setValue(value)) {
        return false;
    }

    if (parameter->value() != previous && !save()) {
        qWarning() << "Impossibile salvare i parametri in" << m_storagePath;
    }
    return true;
}

bool ParameterManager::resetParameter(const QString& id)
{
    auto* parameter = getParameter(id);
    if (!parameter) {
        return false;
    }

    return setParameterValue(id, parameter->defaultValue());
}

bool ParameterManager::load()
{
    QFile file(m_storagePath);
    if (!file.exists()) {
        return true;
    }

    if (!file.open(QIODevice::ReadOnly)) {
        qWarning() << "Impossibile aprire il file parametri" << m_storagePath << file.errorString();
        return false;
    }

    const QCborValue rootValue = QCborValue::fromCbor(file.readAll());
    if (!rootValue.isMap()) {
        qWarning() << "File parametri non valido:" << m_storagePath;
        return false;
    }

    const QCborMap root = rootValue.toMap();
    const int version = root.value(QLatin1String(kVersionKey)).toInteger(-1);
    if (version != kStorageVersion) {
        qWarning() << "Versione file parametri non supportata:" << version;
        return false;
    }

    const QCborValue valuesValue = root.value(QLatin1String(kValuesKey));
    if (!valuesValue.isMap()) {
        return true;
    }

    const QCborMap values = valuesValue.toMap();
    for (auto it = values.constBegin(); it != values.constEnd(); ++it) {
        const QString id = it.key().toString();
        auto* parameter = getParameter(id);
        if (!parameter) {
            continue;
        }

        const QVariant persistedValue = it.value().toVariant();
        if (!parameter->setValue(persistedValue)) {
            qWarning() << "Parametro persistito ignorato perche' non valido:" << id;
        }
    }
    return true;
}

bool ParameterManager::save() const
{
    const QFileInfo fileInfo(m_storagePath);
    const QDir parentDir = fileInfo.dir();
    if (!parentDir.exists() && !QDir().mkpath(parentDir.absolutePath())) {
        return false;
    }

    QCborMap values;
    for (auto it = m_parameters.constBegin(); it != m_parameters.constEnd(); ++it) {
        values.insert(it.key(), QCborValue::fromVariant(it.value()->value()));
    }

    QCborMap root;
    root.insert(QLatin1String(kVersionKey), kStorageVersion);
    root.insert(QLatin1String(kValuesKey), values);

    QSaveFile file(m_storagePath);
    if (!file.open(QIODevice::WriteOnly)) {
        return false;
    }

    file.write(QCborValue(root).toCbor());
    return file.commit();
}

QString ParameterManager::storagePath() const
{
    return m_storagePath;
}

void ParameterManager::loadDefaults()
{
    for (auto* parameter : ParameterLut::defaults(this)) {
        m_parameters[parameter->id()] = parameter;
        connectParameter(parameter);
    }
}

void ParameterManager::connectParameter(Parameter* parameter)
{
    connect(parameter, &Parameter::valueChanged, this, [this, parameter](const QVariant& value) {
        emit parameterValueChanged(parameter->id(), value);
    });
}

QString ParameterManager::resolveStoragePath() const
{
    const QProcessEnvironment env = QProcessEnvironment::systemEnvironment();
    const QString overridePath = env.value(kParameterFileEnv);
    if (!overridePath.isEmpty()) {
        return overridePath;
    }

    QString configDir = QStandardPaths::writableLocation(QStandardPaths::AppConfigLocation);
    if (configDir.isEmpty()) {
        const QString appName = QCoreApplication::applicationName().isEmpty()
            ? QStringLiteral("anomaly_detection_emb")
            : QCoreApplication::applicationName();
        configDir = QDir::homePath() + QStringLiteral("/.config/") + appName;
    }

    return QDir(configDir).filePath(kDefaultFileName);
}
