import QtQuick
import Dashboard.Ui 1.0

Rectangle {
    id: root

    property color onlineColor: DashboardColors.success
    property color offlineColor: DashboardColors.danger
    property color textColor: DashboardColors.textPrimary
    property int padding: DashboardSpacing.md
    property int indicatorSize: 8
    property int spacing: DashboardSpacing.sm
    property font textFont: Qt.font({ family: DashboardTypography.family, pixelSize: DashboardTypography.caption, bold: true })

    property bool online: false
    property string onlineText: "Server online"
    property string offlineText: "Server offline"

    implicitWidth: statusText.implicitWidth + indicatorSize + spacing + 2 * padding
    implicitHeight: Math.max(indicatorSize, statusText.implicitHeight) + DashboardSpacing.md
    radius: DashboardSpacing.radiusSm
    color: DashboardColors.surfaceRaised
    border.width: 1
    border.color: root.online ? root.onlineColor : root.offlineColor

    Rectangle {
        id: dot
        width: root.indicatorSize
        height: width
        radius: width / 2
        anchors.left: parent.left
        anchors.leftMargin: root.padding
        anchors.verticalCenter: parent.verticalCenter
        color: root.online ? root.onlineColor : root.offlineColor
    }

    Text {
        id: statusText
        anchors.left: dot.right
        anchors.leftMargin: root.spacing
        anchors.verticalCenter: parent.verticalCenter
        text: root.online ? root.onlineText : root.offlineText
        color: root.textColor
        font: root.textFont
    }
}
