import QtQuick
import Dashboard.Ui 1.0

DashboardShell {
    id: root

    required property var telemetry
    property real speedKmh: 0
    property var mapConfiguration: ({})
    property var anomalies: []

    serverAvailable: telemetry.serverAvailable
    gpsSatellites: telemetry.gpsSatellites !== undefined ? telemetry.gpsSatellites : 0
    gpsHasFix: telemetry.gpsHasFix
    overlaySidebar: currentIndex === 2
    edgeToEdgeContent: currentIndex === 2
    navigationItems: [
        { icon: "speed", label: qsTr("Veicolo") },
        { icon: "charts", label: qsTr("Accelerazioni") },
        { icon: "map", label: qsTr("Mappa") },
        { icon: "logs", label: qsTr("Log") }
    ]

    HomeView {
        objectName: "dashboardPages"
        anchors.fill: parent
        telemetry: root.telemetry
        speedKmh: root.speedKmh
        currentIndex: root.currentIndex
        mapConfiguration: root.mapConfiguration
        anomalies: root.anomalies
    }
}
