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

    Flickable {
        anchors.fill: parent
        contentWidth: width
        contentHeight: Math.max(height, dashboardContent.implicitHeight)
        clip: true
        boundsBehavior: Flickable.StopAtBounds

        ColumnLayout {
            id: dashboardContent
            width: parent.width
            height: Math.max(implicitHeight, root.height)
            spacing: DashboardSpacing.lg

            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.minimumHeight: 408
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

            DashboardCard {
                Layout.fillWidth: true
                Layout.preferredHeight: 420
                Layout.minimumHeight: 420
                title: "Comunicazione con la scheda"
                subtitle: DBusClient.serverAvailable ? "Connessione attiva" : "Scheda non disponibile"

                ColumnLayout {
                    anchors.fill: parent
                    spacing: DashboardSpacing.sm

                    RowLayout {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 230
                        spacing: DashboardSpacing.lg

                        ColumnLayout {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            spacing: DashboardSpacing.sm

                            Text {
                                text: "IMU"
                                color: DashboardColors.textPrimary
                                font.family: DashboardTypography.family
                                font.pixelSize: DashboardTypography.caption
                                font.bold: true
                            }

                            Flickable {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                clip: true
                                contentWidth: width
                                contentHeight: imuText.implicitHeight

                                Text {
                                    id: imuText
                                    width: parent.width
                                    text: DBusClient.imuDetails || "In attesa di dati IMU"
                                    color: DashboardColors.textSecondary
                                    font.family: DashboardTypography.family
                                    font.pixelSize: DashboardTypography.caption
                                    wrapMode: Text.WrapAnywhere
                                }
                            }
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            spacing: DashboardSpacing.sm

                            Text {
                                text: "GPS"
                                color: DashboardColors.textPrimary
                                font.family: DashboardTypography.family
                                font.pixelSize: DashboardTypography.caption
                                font.bold: true
                            }

                            Flickable {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                clip: true
                                contentWidth: width
                                contentHeight: gpsText.implicitHeight

                                Text {
                                    id: gpsText
                                    width: parent.width
                                    text: DBusClient.gpsMessage || "In attesa di dati GPS"
                                    color: DashboardColors.textSecondary
                                    font.family: DashboardTypography.family
                                    font.pixelSize: DashboardTypography.caption
                                    wrapMode: Text.WrapAnywhere
                                }
                            }
                        }
                    }

                    Text {
                        Layout.fillWidth: true
                        text: "Traffico UART ricevuto e inviato (esadecimale)"
                        color: DashboardColors.textPrimary
                        font.family: DashboardTypography.family
                        font.pixelSize: DashboardTypography.caption
                    }

                    Flickable {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        clip: true
                        contentWidth: width
                        contentHeight: trafficText.implicitHeight
                        boundsBehavior: Flickable.StopAtBounds
                        onContentHeightChanged: contentY = Math.max(0, contentHeight - height)

                        Text {
                            id: trafficText
                            width: parent.width
                            text: DBusClient.trafficLog || "In attesa di frame UART"
                            color: DashboardColors.textSecondary
                            font.family: DashboardTypography.family
                            font.pixelSize: DashboardTypography.caption
                            wrapMode: Text.WrapAnywhere
                        }
                    }
                }
            }
        }
    }
}
