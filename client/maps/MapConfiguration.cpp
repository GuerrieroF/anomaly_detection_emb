#include "MapConfiguration.h"

#include <QCryptographicHash>
#include <QDir>
#include <QFile>
#include <QJsonDocument>
#include <QJsonObject>
#include <QSettings>
#include <QStandardPaths>
#include <QUrl>
#include <QDebug>

MapConfiguration::MapConfiguration(const QString &fileName)
{
    m_properties.insert(QStringLiteral("usesThunderforest"), false);
    QSettings settings(fileName, QSettings::IniFormat);
    const QString provider = settings.value(QStringLiteral("map/provider"), QStringLiteral("osm")).toString();
    if (provider != QStringLiteral("thunderforest"))
        return;

    const QString apiKey = settings.value(QStringLiteral("map/apiKey")).toString().trimmed();
    const QString style = settings.value(QStringLiteral("map/style"), QStringLiteral("atlas")).toString();
    const QStringList styles = {QStringLiteral("atlas"), QStringLiteral("cycle"),
        QStringLiteral("transport"), QStringLiteral("transport-dark"), QStringLiteral("landscape"),
        QStringLiteral("outdoors"), QStringLiteral("mobile-atlas"), QStringLiteral("neighbourhood"),
        QStringLiteral("pioneer"), QStringLiteral("spinal-map"), QStringLiteral("atlas-canvas")};
    if (apiKey.isEmpty() || !styles.contains(style) || !m_providers.isValid()) {
        qWarning() << "Configurazione Thunderforest incompleta o non valida: uso OpenStreetMap.";
        return;
    }

    // Qt 6.5.3 appends /z/x/y to custom.host. Provider descriptors instead
    // accept a complete URL template, including the API key query parameter.
    const QString tileUrl = QStringLiteral("https://api.thunderforest.com/") + style
                            + QStringLiteral("/%z/%x/%y.png?apikey=")
                            + QString::fromLatin1(QUrl::toPercentEncoding(apiKey));
    const QJsonObject descriptor {
        {QStringLiteral("UrlTemplate"), tileUrl},
        {QStringLiteral("ImageFormat"), QStringLiteral("png")},
        {QStringLiteral("MapCopyRight"), QStringLiteral("<a href='https://www.thunderforest.com/'>Thunderforest</a>")},
        {QStringLiteral("DataCopyRight"), QStringLiteral("<a href='https://www.openstreetmap.org/copyright'>OpenStreetMap</a> contributors")},
        {QStringLiteral("MaximumZoomLevel"), 22}
    };
    const QByteArray json = QJsonDocument(descriptor).toJson(QJsonDocument::Compact);
    // The OSM plugin resolves every legacy slot, even when using only StreetMap.
    // All slots use the explicitly configured style; no remote fallback is needed.
    const QStringList providerNames = {QStringLiteral("street"), QStringLiteral("satellite"),
        QStringLiteral("cycle"), QStringLiteral("transit"), QStringLiteral("night-transit"),
        QStringLiteral("terrain"), QStringLiteral("hiking")};
    for (const QString &slot : providerNames) {
        QFile file(m_providers.filePath(slot));
        if (!file.open(QIODevice::WriteOnly)
            || !file.setPermissions(QFileDevice::ReadOwner | QFileDevice::WriteOwner)
            || file.write(json) != json.size()) {
            qWarning() << "Impossibile preparare il provider cartografico: uso OpenStreetMap.";
            return;
        }
    }

    // Separate caches by style and credential to avoid old OSM/watermarked tiles.
    const QByteArray identity = (style + QLatin1Char(':') + apiKey).toUtf8();
    const QString cacheId = QString::fromLatin1(QCryptographicHash::hash(identity, QCryptographicHash::Sha256).toHex().left(16));
    const QString cache = QStandardPaths::writableLocation(QStandardPaths::CacheLocation)
                          + QStringLiteral("/maps/thunderforest-") + cacheId;
    if (!QDir().mkpath(cache)
        || !QFile::setPermissions(cache, QFileDevice::ReadOwner | QFileDevice::WriteOwner | QFileDevice::ExeOwner)) {
        qWarning() << "Impossibile creare la cache cartografica: uso OpenStreetMap.";
        return;
    }
    m_properties.insert(QStringLiteral("usesThunderforest"), true);
    m_properties.insert(QStringLiteral("providersRepository"), QUrl::fromLocalFile(m_providers.path() + QLatin1Char('/')));
    m_properties.insert(QStringLiteral("cacheDirectory"), cache);
}

QVariantMap MapConfiguration::qmlProperties() const
{
    return m_properties;
}
