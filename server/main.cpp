#include <QCoreApplication>
#include <QLocale>
#include <QTranslator>
#include <QtDBus/QDBusConnection>
#include "connection/dbusserver.h"
#include "parameters/ParameterManager.h"
#include "dbus/ParameterManagerDBus.h"

int main(int argc, char *argv[])
{

    QCoreApplication a(argc, argv);

    DBusServer dbusServer(&a);

    QDBusConnection connection = QDBusConnection::sessionBus();
    if (!connection.registerService("com.myapp.Parameters")) {
        qFatal("Impossibile registrare il servizio DBus!");
        return 1;
    }

    ParameterManager manager;
    ParameterManagerDBus managerDbus(&manager, connection);


    QTranslator translator;
    const QStringList uiLanguages = QLocale::system().uiLanguages();
    for (const QString &locale : uiLanguages) {
        const QString baseName = "server_" + QLocale(locale).name();
        if (translator.load(":/i18n/" + baseName)) {
            a.installTranslator(&translator);
            break;
        }
    }

    // Set up code that uses the Qt event loop here.
    // Call a.quit() or a.exit() to quit the application.
    // A not very useful example would be including
    // #include <QTimer>
    // near the top of the file and calling
    // QTimer::singleShot(5000, &a, &QCoreApplication::quit);
    // which quits the application after 5 seconds.

    // If you do not need a running Qt event loop, remove the call
    // to a.exec() or use the Non-Qt Plain C++ Application template.

    return a.exec();
}
