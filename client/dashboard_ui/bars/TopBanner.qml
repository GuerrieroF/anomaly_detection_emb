import QtQuick
import Dashboard.Ui 1.0

Rectangle {
    id: root

    property bool serverAvailable: false
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

    StatusPill {
        id: statusPill
        visible: root.showStatus
        anchors.right: parent.right
        anchors.rightMargin: root.padding
        anchors.verticalCenter: parent.verticalCenter
        online: root.serverAvailable
    }
}
