import QtQuick
import Dashboard.Ui 1.0

DashboardShell {
    id: root

    required property var telemetry
    property real speedKmh: 0
    property var mapConfiguration: ({})

    serverAvailable: telemetry.serverAvailable
    navigationItems: [
        { icon: "speed", label: qsTr("Veicolo") },
        { icon: "charts", label: qsTr("Accelerazioni") },
        { icon: "map", label: qsTr("Mappa") }
    ]

    HomeView {
        objectName: "dashboardPages"
        anchors.fill: parent
        telemetry: root.telemetry
        speedKmh: root.speedKmh
        currentIndex: root.currentIndex
        mapConfiguration: root.mapConfiguration
    }
}
