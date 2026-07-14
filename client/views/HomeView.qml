import QtQuick
import QtQuick.Layouts
import Dashboard.Ui 1.0
import DBusExample.io

Item {
    id: root

    property int sampleLimit: 180
    property var accelZHistory: []
    property var accelVectorHistory: []
    property real speedKmh: 0

    function appendSample() {
        var z = accelZHistory.slice()
        z.push(DBusClient.linearAccelZg)
        while (z.length > sampleLimit) {
            z.shift()
        }
        accelZHistory = z

        var vector = accelVectorHistory.slice()
        vector.push({
            x: DBusClient.linearAccelYg,
            y: DBusClient.linearAccelXg
        })
        while (vector.length > sampleLimit) {
            vector.shift()
        }
        accelVectorHistory = vector
    }

    Connections {
        target: DBusClient
        function onImuDataChanged() {
            root.appendSample()
        }
    }

    RowLayout {
        anchors.fill: parent
        spacing: DashboardSpacing.lg

        ColumnLayout {
            Layout.fillHeight: true
            Layout.preferredWidth: 280
            Layout.minimumWidth: 230
            Layout.maximumWidth: 340
            spacing: DashboardSpacing.lg

            MapPanel {
                Layout.fillWidth: true
                Layout.fillHeight: true
                routeInstruction: "400 m"
                routeDetail: "Turn left onto Correlia St."
            }
        }

        ColumnLayout {
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.minimumWidth: 360
            spacing: DashboardSpacing.lg

            SeriesLineChart {
                Layout.fillWidth: true
                Layout.preferredHeight: 132
                title: "Accelerazione Z"
                subtitle: "lineare"
                history: root.accelZHistory
                currentValue: DBusClient.linearAccelZg
                minValue: -2
                maxValue: 2
                lineColor: DashboardColors.cyan
            }

            CarAttitudeView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.minimumHeight: 260
                rollDeg: DBusClient.tiltXDeg
                pitchDeg: DBusClient.tiltYDeg
                yawDeg: DBusClient.tiltZDeg
            }
        }

        ColumnLayout {
            Layout.fillHeight: true
            Layout.preferredWidth: 260
            Layout.minimumWidth: 220
            Layout.maximumWidth: 320
            spacing: DashboardSpacing.lg

            Speedometer {
                Layout.fillWidth: true
                Layout.preferredHeight: 280
                speed: root.speedKmh
                maxSpeed: 180
            }

            AccelerationVectorChart {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.minimumHeight: 170
                history: root.accelVectorHistory
                xValue: DBusClient.linearAccelYg
                yValue: DBusClient.linearAccelXg
                range: 2
            }
        }
    }
}
