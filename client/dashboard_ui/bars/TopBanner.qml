import QtQuick
import QtQuick.Controls
import Dashboard.Ui 1.0

Rectangle {
    id: root

    property bool serverAvailable: false
    property bool wifiAvailable: false
    property bool wifiConnected: false
    property int wifiSignalBars: 0
    property int batteryPercentage: -1
    property bool batteryCharging: false
    property int gpsSatellites: 0
    property bool gpsHasFix: false
    readonly property int gpsSignalBars: !serverAvailable || gpsSatellites <= 0 ? 0
                                              : gpsSatellites < 4 ? 1
                                              : gpsSatellites < 7 ? 2
                                              : gpsSatellites < 10 ? 3 : 4
    property date now: new Date()
    property bool clockRunning: true
    property bool showClock: true
    property bool showStatus: true
    property string timeFormat: "HH:mm"
    property string dateFormat: "dddd, dd MMMM yyyy"
    property int padding: DashboardSpacing.xl
    property color timeColor: DashboardColors.textPrimary
    property color dateColor: DashboardColors.textSecondary
    property alias statusIndicator: statusPill

    implicitHeight: DashboardSpacing.topBannerHeight
    color: DashboardColors.background

    Timer {
        interval: 1000
        running: root.clockRunning
        repeat: true
        onTriggered: root.now = new Date()
    }

    ApplicationLogo {
        id: applicationLogo
        objectName: "applicationLogo"
        anchors.centerIn: parent
        width: 180
        height: Math.min(root.height - DashboardSpacing.sm * 2, 52)
    }

    Column {
        visible: root.showClock
        anchors.left: parent.left
        anchors.leftMargin: root.padding
        anchors.verticalCenter: parent.verticalCenter
        spacing: 2

        Text {
            text: Qt.formatTime(root.now, root.timeFormat)
            color: root.timeColor
            font.family: DashboardTypography.family
            font.pixelSize: DashboardTypography.title
            font.bold: true
        }

        Text {
            text: Qt.formatDate(root.now, root.dateFormat)
            color: root.dateColor
            font.family: DashboardTypography.family
            font.pixelSize: DashboardTypography.caption
        }
    }

    Row {
        anchors.right: parent.right
        anchors.rightMargin: root.padding
        anchors.verticalCenter: parent.verticalCenter
        spacing: DashboardSpacing.lg

        IconGlyph {
            objectName: "wifiIndicator"
            width: 28
            height: 28
            anchors.verticalCenter: parent.verticalCenter
            name: root.wifiConnected ? "wifi" : "wifi-off"
            signalBars: root.wifiSignalBars
            strokeColor: root.wifiConnected ? DashboardColors.accent : DashboardColors.textMuted
            Accessible.name: !root.wifiAvailable ? qsTr("Wi-Fi non disponibile")
                : !root.wifiConnected ? qsTr("Wi-Fi disconnesso")
                : root.wifiSignalBars > 0 ? qsTr("Wi-Fi connesso: %1 barre su 3").arg(root.wifiSignalBars)
                : qsTr("Wi-Fi connesso · Intensità non disponibile")
            HoverHandler { id: wifiHover }
            ToolTip.visible: wifiHover.hovered
            ToolTip.text: Accessible.name
        }

        Item {
            width: 36
            height: 32
            Accessible.name: qsTr("Segnale GPS: %1 satelliti, %2 barre su 4")
                .arg(root.serverAvailable ? root.gpsSatellites : 0).arg(root.gpsSignalBars)

            Row {
                anchors.centerIn: parent
                spacing: 3
                height: 25
                Repeater {
                    model: 4
                    Rectangle {
                        required property int index
                        width: 5
                        height: 7 + index * 6
                        anchors.bottom: parent.bottom
                        radius: 1
                        color: index < root.gpsSignalBars ? DashboardColors.accent : DashboardColors.borderStrong
                    }
                }
            }
            HoverHandler { id: signalHover }
            ToolTip.visible: signalHover.hovered
            ToolTip.text: qsTr("GPS: %1 satelliti (livello stimato)").arg(root.serverAvailable ? root.gpsSatellites : 0)
        }

        IconGlyph {
            width: 28
            height: 28
            anchors.verticalCenter: parent.verticalCenter
            name: "gps-fix"
            strokeColor: root.serverAvailable && root.gpsHasFix ? DashboardColors.success : DashboardColors.textMuted
            Accessible.name: root.serverAvailable && root.gpsHasFix ? qsTr("Fix GPS disponibile") : qsTr("Fix GPS assente")
            HoverHandler { id: fixHover }
            ToolTip.visible: fixHover.hovered
            ToolTip.text: Accessible.name
        }

        StatusPill {
            id: statusPill
            visible: root.showStatus
            anchors.verticalCenter: parent.verticalCenter
            online: root.serverAvailable
        }

        Row {
            id: batteryIndicator
            objectName: "batteryIndicator"
            anchors.verticalCenter: parent.verticalCenter
            spacing: DashboardSpacing.sm
            readonly property bool available: root.batteryPercentage >= 0
            readonly property color batteryColor: !available ? DashboardColors.textMuted
                : root.batteryCharging ? DashboardColors.success
                : root.batteryPercentage <= 20 ? DashboardColors.warning : DashboardColors.textPrimary
            Accessible.name: !available ? qsTr("Batteria non disponibile")
                : qsTr("Batteria: %1%%2").arg(root.batteryPercentage)
                  .arg(root.batteryCharging ? qsTr(" · In carica") : "")

            Item {
                width: 32
                height: 24
                anchors.verticalCenter: parent.verticalCenter

                Rectangle {
                    x: 1; y: 4
                    width: 26; height: 16
                    radius: 3
                    color: "transparent"
                    border.width: 2
                    border.color: batteryIndicator.batteryColor
                    Rectangle {
                        x: 4; y: 4
                        height: 8
                        width: 18 * Math.max(0, Math.min(100, root.batteryPercentage)) / 100
                        radius: 1
                        color: batteryIndicator.batteryColor
                    }
                }
                Rectangle {
                    x: 28; y: 9
                    width: 3; height: 6
                    radius: 1
                    color: batteryIndicator.batteryColor
                }
            }

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: batteryIndicator.available ? root.batteryPercentage + "%" : "—"
                color: batteryIndicator.batteryColor
                font.family: DashboardTypography.family
                font.pixelSize: DashboardTypography.caption
                font.bold: true
            }

            Text {
                visible: root.batteryCharging
                anchors.verticalCenter: parent.verticalCenter
                text: "⚡"
                color: DashboardColors.success
                font.pixelSize: DashboardTypography.body
            }

            HoverHandler { id: batteryHover }
            ToolTip.visible: batteryHover.hovered
            ToolTip.text: batteryIndicator.Accessible.name
        }
    }
}
