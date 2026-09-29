#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QUrl>
#include "connection/dbusclient.h"
#include "maps/MapConfiguration.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    qmlRegisterSingletonType<DBusClient>("DBusExample.io", 1 , 0, "DBusClient",[&app](QQmlEngine *engine,QJSEngine *scripEngine) ->QObject* {
        Q_UNUSED(engine)
        Q_UNUSED(scripEngine)
        return new DBusClient(&app);
    });

    const QString mapConfigFile = qEnvironmentVariable("ANOMALY_MAP_CONFIG",
        QCoreApplication::applicationDirPath() + QStringLiteral("/map.local.ini"));
    MapConfiguration mapConfiguration(mapConfigFile);
    QQmlApplicationEngine engine;
    engine.setInitialProperties({{QStringLiteral("mapConfiguration"), mapConfiguration.qmlProperties()}});
    engine.load(QUrl(QStringLiteral("qrc:/qt/qml/client/Main.qml")));
    if (engine.rootObjects().isEmpty()) {
        engine.load(QUrl(QStringLiteral("qrc:/client/Main.qml")));
    }

    if (engine.rootObjects().isEmpty()) {
        return -1;
    }

    return app.exec();
}
