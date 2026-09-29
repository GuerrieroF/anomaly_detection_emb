import QtQuick
import QtQuick.Window
import DBusExample.io

Window {
    id: root
    property var mapConfiguration: ({})
    width: 1024
    height: 600
    visible: true
    title: qsTr("Anomaly Dashboard")

    DashboardView {
        anchors.fill: parent
        telemetry: DBusClient
        mapConfiguration: root.mapConfiguration
    }
}
