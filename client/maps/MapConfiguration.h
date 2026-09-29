#pragma once

#include <QTemporaryDir>
#include <QVariantMap>

// Owns the private provider descriptors for the lifetime of the QML engine.
class MapConfiguration
{
public:
    explicit MapConfiguration(const QString &fileName);
    QVariantMap qmlProperties() const;

private:
    QTemporaryDir m_providers;
    QVariantMap m_properties;
};
