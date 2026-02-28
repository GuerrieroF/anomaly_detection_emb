#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "connection/dbusclient.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    DBusClient dbusClient;

    qmlRegisterSingletonType<DBusClient>("DBusExample.io", 1 , 0, "DBusClient",[&app](QQmlEngine *engine,QJSEngine *scripEngine) ->QObject* {
        Q_UNUSED(engine)
        Q_UNUSED(scripEngine)
        return new DBusClient(&app);
    });

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("client", "Main");

    return app.exec();
}
