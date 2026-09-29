import QtQuick
import QtQuick.Layouts

Item {
    id: root

    required property var telemetry
    property int currentIndex: 0
    property int sampleLimit: 180
    property var accelZHistory: []
    property var accelVectorHistory: []
    property real speedKmh: 0
    property var mapConfiguration: ({})
    property var anomalies: []

    function appendSample() {
        var limit = Math.max(1, sampleLimit)
        var z = accelZHistory.slice()
        z.push(telemetry.linearAccelZg)
        accelZHistory = z.slice(-limit)

        var vector = accelVectorHistory.slice()
        vector.push({ x: telemetry.linearAccelYg, y: telemetry.linearAccelXg })
        accelVectorHistory = vector.slice(-limit)
    }

    Connections {
        target: root.telemetry
        function onImuDataChanged() {
            root.appendSample()
        }
    }

    // Keep the pages alive so navigation preserves chart history and map zoom.
    StackLayout {
        anchors.fill: parent
        currentIndex: root.currentIndex

        VehicleView {
            objectName: "vehiclePage"
            speedKmh: root.speedKmh
            rollDeg: root.telemetry.tiltXDeg
            pitchDeg: root.telemetry.tiltYDeg
            yawDeg: root.telemetry.tiltZDeg
        }

        AccelerationsView {
            objectName: "accelerationsPage"
            zHistory: root.accelZHistory
            vectorHistory: root.accelVectorHistory
            zValue: root.telemetry.linearAccelZg
            lateralValue: root.telemetry.linearAccelYg
            longitudinalValue: root.telemetry.linearAccelXg
        }

        MapView {
            mapConfiguration: root.mapConfiguration
            objectName: "mapPage"
            hasPosition: root.telemetry.gpsHasFix
            latitude: root.telemetry.gpsLatitude
            longitude: root.telemetry.gpsLongitude
            heading: root.telemetry.gpsHeading
            anomalies: root.anomalies
        }

        SettingsView {
            objectName: "settingsPage"
        }
    }
}
