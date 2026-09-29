import QtQuick
import Dashboard.Ui 1.0

Rectangle {
    id: root

    default property alias content: contentHost.data
    readonly property alias contentItem: contentHost
    property string title: ""
    property string subtitle: ""
    property int padding: DashboardSpacing.lg
    property int headerSpacing: DashboardSpacing.md
    property bool showHeader: title.length > 0 || subtitle.length > 0
    property color titleColor: DashboardColors.textPrimary
    property color subtitleColor: DashboardColors.textSecondary
    property font titleFont: Qt.font({ family: DashboardTypography.family, pixelSize: DashboardTypography.bodyLarge, bold: true })
    property font subtitleFont: Qt.font({ family: DashboardTypography.family, pixelSize: DashboardTypography.caption })

    radius: DashboardSpacing.radiusMd
    color: DashboardColors.surface
    border.width: 1
    border.color: DashboardColors.border
    clip: true

    Column {
        id: header
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: root.padding
        spacing: 2
        visible: root.showHeader

        Text {
            width: parent.width
            visible: root.title.length > 0
            text: root.title
            color: root.titleColor
            font: root.titleFont
            elide: Text.ElideRight
        }

        Text {
            width: parent.width
            visible: root.subtitle.length > 0
            text: root.subtitle
            color: root.subtitleColor
            font: root.subtitleFont
            elide: Text.ElideRight
        }
    }

    Item {
        id: contentHost
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.top: root.showHeader ? header.bottom : parent.top
        anchors.margins: root.padding
        anchors.topMargin: root.showHeader ? root.headerSpacing : root.padding
    }
}
