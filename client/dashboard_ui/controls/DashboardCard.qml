import QtQuick
import Dashboard.Ui 1.0

Rectangle {
    id: root

    default property alias content: contentHost.data
    property string title: ""
    property string subtitle: ""
    property int padding: DashboardSpacing.lg

    radius: DashboardSpacing.radiusMd
    color: DashboardColors.surface
    border.width: 1
    border.color: DashboardColors.border
    clip: true

    Rectangle {
        anchors.fill: parent
        color: "transparent"
        border.width: 1
        border.color: "#08000000"
        radius: parent.radius
    }

    Text {
        id: titleLabel
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.leftMargin: root.padding
        anchors.rightMargin: root.padding
        anchors.topMargin: root.title.length > 0 ? root.padding : 0
        visible: root.title.length > 0
        text: root.title
        color: DashboardColors.textPrimary
        font.family: DashboardTypography.family
        font.pixelSize: DashboardTypography.bodyLarge
        font.bold: true
        elide: Text.ElideRight
    }

    Text {
        id: subtitleLabel
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: titleLabel.bottom
        anchors.leftMargin: root.padding
        anchors.rightMargin: root.padding
        anchors.topMargin: root.subtitle.length > 0 ? 2 : 0
        visible: root.subtitle.length > 0
        text: root.subtitle
        color: DashboardColors.textSecondary
        font.family: DashboardTypography.family
        font.pixelSize: DashboardTypography.caption
        elide: Text.ElideRight
    }

    Item {
        id: contentHost
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.top: root.title.length > 0
                     ? (root.subtitle.length > 0 ? subtitleLabel.bottom : titleLabel.bottom)
                     : parent.top
        anchors.margins: root.padding
        anchors.topMargin: root.title.length > 0 ? DashboardSpacing.md : root.padding
    }
}
