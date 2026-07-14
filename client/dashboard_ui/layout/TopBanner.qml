import QtQuick
import Dashboard.Ui 1.0

Rectangle {
    id: root

    property bool serverAvailable: false
    property date now: new Date()

    height: DashboardSpacing.topBannerHeight
    color: DashboardColors.background

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: root.now = new Date()
    }

    Column {
        anchors.left: parent.left
        anchors.leftMargin: DashboardSpacing.xl
        anchors.verticalCenter: parent.verticalCenter
        spacing: 2

        Text {
            text: Qt.formatTime(root.now, "HH:mm")
            color: DashboardColors.textPrimary
            font.family: DashboardTypography.family
            font.pixelSize: DashboardTypography.title
            font.bold: true
        }

        Text {
            text: Qt.formatDate(root.now, "dddd, dd MMMM yyyy")
            color: DashboardColors.textSecondary
            font.family: DashboardTypography.family
            font.pixelSize: DashboardTypography.caption
        }
    }

    StatusPill {
        anchors.right: parent.right
        anchors.rightMargin: DashboardSpacing.xl
        anchors.verticalCenter: parent.verticalCenter
        online: root.serverAvailable
    }
}
