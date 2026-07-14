import QtQuick
import QtQuick.Window
import Dashboard.Ui 1.0
import DBusExample.io

Window {
    width: 1024
    height: 600
    visible: true
    title: qsTr("Anomaly Dashboard")

    DashboardShell {
        anchors.fill: parent
        serverAvailable: DBusClient.serverAvailable

        HomeView {
            anchors.fill: parent
        }
    }
}
