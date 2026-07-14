import QtQuick
import Dashboard.Ui 1.0

Rectangle {
    id: root

    property bool online: false
    property string onlineText: "Server online"
    property string offlineText: "Server offline"

    implicitWidth: statusText.implicitWidth + 34
    implicitHeight: 30
    radius: DashboardSpacing.radiusSm
    color: DashboardColors.surfaceRaised
    border.width: 1
    border.color: root.online ? DashboardColors.success : DashboardColors.danger

    Rectangle {
        id: dot
        width: 8
        height: 8
        radius: 4
        anchors.left: parent.left
        anchors.leftMargin: DashboardSpacing.md
        anchors.verticalCenter: parent.verticalCenter
        color: root.online ? DashboardColors.success : DashboardColors.danger
    }

    Text {
        id: statusText
        anchors.left: dot.right
        anchors.leftMargin: DashboardSpacing.sm
        anchors.verticalCenter: parent.verticalCenter
        text: root.online ? root.onlineText : root.offlineText
        color: DashboardColors.textPrimary
        font.family: DashboardTypography.family
        font.pixelSize: DashboardTypography.caption
        font.bold: true
    }
}
