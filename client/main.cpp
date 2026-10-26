#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QUrl>
#include "connection/dbusclient.h"
#include "maps/MapConfiguration.h"
#include "system/DevicePower.h"
#include "system/DeviceBattery.h"
#include "system/DeviceWifi.h"
#ifdef ANOMALY_GOOGLE_MAPS
#include <QtWebEngineQuick/qtwebenginequickglobal.h>
#endif

int main(int argc, char *argv[])
{
#ifdef ANOMALY_GOOGLE_MAPS
    QCoreApplication::setAttribute(Qt::AA_ShareOpenGLContexts);
    QtWebEngineQuick::initialize();
#endif
    QGuiApplication app(argc, argv);

    qmlRegisterSingletonType<DBusClient>("DBusExample.io", 1 , 0, "DBusClient",[&app](QQmlEngine *engine,QJSEngine *scripEngine) ->QObject* {
        Q_UNUSED(engine)
        Q_UNUSED(scripEngine)
        return new DBusClient(&app);
    });

    const QString mapConfigFile = qEnvironmentVariable("ANOMALY_MAP_CONFIG",
        QCoreApplication::applicationDirPath() + QStringLiteral("/map.local.ini"));
    MapConfiguration mapConfiguration(mapConfigFile);
    DeviceWifi deviceWifi;
    DeviceBattery deviceBattery;
    DevicePower devicePower;
    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty(QStringLiteral("deviceWifi"), &deviceWifi);
    engine.rootContext()->setContextProperty(QStringLiteral("deviceBattery"), &deviceBattery);
    engine.rootContext()->setContextProperty(QStringLiteral("devicePower"), &devicePower);
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
