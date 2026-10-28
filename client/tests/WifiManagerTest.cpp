#include <QtTest>
#include <QTemporaryDir>
#include <QFile>
#include "system/WifiManager.h"

class WifiManagerTest : public QObject
{
    Q_OBJECT
private slots:
    void missingNmcli()
    {
        QTemporaryDir directory;
        QVERIFY(directory.isValid());
        const auto previousPath = qgetenv("PATH");
        qputenv("PATH", directory.path().toUtf8());
        {
            WifiManager manager;
            QTRY_VERIFY(!manager.scanning());
            QVERIFY(manager.error().contains("nmcli"));
            QVERIFY(manager.error().contains("Impossibile avviare"));
            QVERIFY(manager.networks().isEmpty());
        }
        qputenv("PATH", previousPath);
    }

    void retriesAndScans()
    {
        QTemporaryDir directory;
        QVERIFY(directory.isValid());
        const auto previousPath = qgetenv("PATH");
        QFile fake(directory.filePath("nmcli"));
        QVERIFY(fake.open(QIODevice::WriteOnly));
        fake.write("#!/bin/sh\n"
                   "case \"$*\" in\n"
                   " *'device wifi list'*) printf '*:Road\\\\:Net:WPA2:85\\n:Other:--:42\\n';;\n"
                   " *'connection up'*) echo attempt >> \"$WIFI_TEST_LOG\"; exit \"$WIFI_TEST_RESULT\";;\n"
                   " *'connection add'*) if [ \"$WIFI_TEST_ADD_FAIL\" = 1 ]; then echo 'Not authorized to control networking' >&2; exit 4; fi;;\n"
                   " *) exit 0;;\n"
                   "esac\n");
        fake.close();
        QVERIFY(fake.setPermissions(QFileDevice::ReadOwner | QFileDevice::WriteOwner | QFileDevice::ExeOwner));
        qputenv("PATH", directory.path().toUtf8() + ":" + previousPath);
        qputenv("WIFI_TEST_LOG", directory.filePath("attempts").toUtf8());
        qputenv("WIFI_TEST_RESULT", "1");
        {
            WifiManager manager;
            QSignalSpy failed(&manager, &WifiManager::connectionFailed);
            QTRY_VERIFY(!manager.scanning());
            QCOMPARE(manager.networks().size(), 2);
            QCOMPARE(manager.networks()[0].toMap()["ssid"].toString(), QString("Road:Net"));
            QVERIFY(manager.networks()[0].toMap()["connected"].toBool());
            manager.connectNetwork("Road:Net", "wpa-psk", "short");
            QVERIFY(!manager.connecting());
            QVERIFY(!manager.error().isEmpty());
            manager.connectNetwork("Road:Net", "wpa-psk", "password123");
            QTRY_COMPARE_WITH_TIMEOUT(failed.count(), 1, 10000);
            QCOMPARE(manager.attempt(), 3);
            QFile log(directory.filePath("attempts"));
            QVERIFY(log.open(QIODevice::ReadOnly));
            QCOMPARE(log.readAll().count('\n'), 3);
            QTRY_VERIFY(!manager.scanning());
            qputenv("WIFI_TEST_RESULT", "0");
            manager.connectNetwork("Road:Net", "wpa-psk", "password123");
            QTRY_VERIFY(!manager.connecting());
            QCOMPARE(manager.attempt(), 1);
            QCOMPARE(failed.count(), 1);
            QTRY_VERIFY(!manager.scanning());
            qputenv("WIFI_TEST_ADD_FAIL", "1");
            manager.connectNetwork("Road:Net", "wpa-psk", "password123");
            QTRY_COMPARE(failed.count(), 2);
            QCOMPARE(manager.attempt(), 0);
            QVERIFY(failed.at(1).at(0).toString().contains("Not authorized to control networking"));
        }
        qputenv("PATH", previousPath);
        qunsetenv("WIFI_TEST_LOG");
        qunsetenv("WIFI_TEST_RESULT");
        qunsetenv("WIFI_TEST_ADD_FAIL");
    }
};
QTEST_GUILESS_MAIN(WifiManagerTest)
#include "WifiManagerTest.moc"
