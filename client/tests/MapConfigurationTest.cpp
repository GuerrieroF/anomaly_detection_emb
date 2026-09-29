#include "maps/MapConfiguration.h"

#include <QFile>
#include <QJsonDocument>
#include <QJsonObject>
#include <QSettings>
#include <QStandardPaths>
#include <QTemporaryDir>
#include <QTest>

class MapConfigurationTest : public QObject
{
    Q_OBJECT

private slots:
    void initTestCase()
    {
        QStandardPaths::setTestModeEnabled(true);
    }

    void missingConfigUsesOsm()
    {
        QTemporaryDir directory;
        MapConfiguration config(directory.filePath(QStringLiteral("missing.ini")));
        QVERIFY(!config.qmlProperties().value(QStringLiteral("usesThunderforest")).toBool());
    }

    void missingKeyUsesOsm()
    {
        QTemporaryDir directory;
        const QString path = directory.filePath(QStringLiteral("map.ini"));
        QSettings settings(path, QSettings::IniFormat);
        settings.setValue(QStringLiteral("map/provider"), QStringLiteral("thunderforest"));
        settings.sync();
        QTest::ignoreMessage(QtWarningMsg, "Configurazione Thunderforest incompleta o non valida: uso OpenStreetMap.");
        MapConfiguration config(path);
        QVERIFY(!config.qmlProperties().value(QStringLiteral("usesThunderforest")).toBool());
    }

    void googleConfigurationPassesKeyAndMapId()
    {
        QTemporaryDir directory;
        const QString path = directory.filePath(QStringLiteral("map.ini"));
        QSettings settings(path, QSettings::IniFormat);
        settings.setValue(QStringLiteral("map/provider"), QStringLiteral("google"));
        settings.setValue(QStringLiteral("map/apiKey"), QStringLiteral("test key"));
        settings.setValue(QStringLiteral("map/mapId"), QStringLiteral("map-123"));
        settings.sync();
        MapConfiguration config(path);
        const auto properties = config.qmlProperties();
        QCOMPARE(properties.value(QStringLiteral("googleApiKey")).toString(), QStringLiteral("test key"));
        QCOMPARE(properties.value(QStringLiteral("googleMapId")).toString(), QStringLiteral("map-123"));
        QVERIFY(!properties.value(QStringLiteral("usesThunderforest")).toBool());
    }

    void fullTemplateAndPrivateDescriptors()
    {
        QTemporaryDir directory;
        const QString path = directory.filePath(QStringLiteral("map.ini"));
        QSettings settings(path, QSettings::IniFormat);
        settings.setValue(QStringLiteral("map/provider"), QStringLiteral("thunderforest"));
        settings.setValue(QStringLiteral("map/apiKey"), QStringLiteral("test key&value"));
        settings.setValue(QStringLiteral("map/style"), QStringLiteral("atlas"));
        settings.sync();
        QString descriptorPath;
        {
            MapConfiguration config(path);
            const auto properties = config.qmlProperties();
            QVERIFY(properties.value(QStringLiteral("usesThunderforest")).toBool());
            const QString repository = properties.value(QStringLiteral("providersRepository")).toUrl().toLocalFile();
            descriptorPath = repository + QStringLiteral("street");
            const QStringList providerNames = {QStringLiteral("street"), QStringLiteral("satellite"),
                QStringLiteral("cycle"), QStringLiteral("transit"), QStringLiteral("night-transit"),
                QStringLiteral("terrain"), QStringLiteral("hiking")};
            for (const QString &slot : providerNames) {
                QFile file(repository + slot);
                QVERIFY(file.open(QIODevice::ReadOnly));
                const auto json = QJsonDocument::fromJson(file.readAll()).object();
                QCOMPARE(json.value(QStringLiteral("UrlTemplate")).toString(),
                    QStringLiteral("https://api.thunderforest.com/atlas/%z/%x/%y.png?apikey=test%20key%26value"));
                QVERIFY(!(file.permissions() & (QFileDevice::ReadGroup | QFileDevice::ReadOther)));
                QVERIFY(!json.value(QStringLiteral("MapCopyRight")).toString().isEmpty());
            }
            const QString firstCache = properties.value(QStringLiteral("cacheDirectory")).toString();
            settings.setValue(QStringLiteral("map/style"), QStringLiteral("transport-dark"));
            settings.sync();
            MapConfiguration otherStyle(path);
            QVERIFY(otherStyle.qmlProperties().value(QStringLiteral("cacheDirectory")).toString() != firstCache);
        }
        QVERIFY(!QFile::exists(descriptorPath));
    }
};

QTEST_GUILESS_MAIN(MapConfigurationTest)
#include "MapConfigurationTest.moc"
