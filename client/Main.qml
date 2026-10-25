import QtQuick
import QtQuick.Window
import DBusExample.io

Window {
    id: root
    property var mapConfiguration: ({})
    property var anomalies: []
    width: 1024
    height: 600
    visibility: Window.FullScreen
    flags: Qt.Window | Qt.FramelessWindowHint
    title: qsTr("Anomaly Dashboard")

    DashboardView {
        anchors.fill: parent
        telemetry: DBusClient
        mapConfiguration: root.mapConfiguration
        anomalies: root.anomalies
    }
}
