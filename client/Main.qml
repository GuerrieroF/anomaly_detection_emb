import QtQuick
import QtQuick.Window
import QtQuick.Controls
import "dialogs"
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
        wifiAvailable: deviceWifi.available
        wifiConnected: deviceWifi.connected
        wifiSignalBars: deviceWifi.signalBars
        batteryPercentage: deviceBattery.percentage
        batteryCharging: deviceBattery.charging
        mapConfiguration: root.mapConfiguration
        anomalies: root.anomalies
        onShutdownRequested: shutdownDialog.open()
    }

    PowerDialog {
        id: shutdownDialog
        title: qsTr("Spegnere il dispositivo?")
        message: qsTr("Il dispositivo verrà spento. Conferma per procedere oppure annulla per tornare alla dashboard.")
        confirmation: true
        busy: devicePower.pending
        onAccepted: devicePower.powerOff()
    }

    PowerDialog {
        id: shutdownError
        title: qsTr("Spegnimento non riuscito")
    }

    Connections {
        target: devicePower
        function onFailed(message) {
            shutdownError.message = message
            shutdownError.open()
        }
    }
}
