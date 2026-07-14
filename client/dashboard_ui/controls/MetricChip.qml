import QtQuick
import Dashboard.Ui 1.0

Rectangle {
    id: root

    property string label: ""
    property string value: ""
    property color accentColor: DashboardColors.accent

    implicitWidth: 104
    implicitHeight: 42
    radius: DashboardSpacing.radiusSm
    color: DashboardColors.surfaceMuted
    border.width: 1
    border.color: DashboardColors.border

    Column {
        anchors.fill: parent
        anchors.margins: DashboardSpacing.sm
        spacing: 1

        Text {
            width: parent.width
            text: root.label
            color: DashboardColors.textSecondary
            font.family: DashboardTypography.family
            font.pixelSize: DashboardTypography.tiny
            elide: Text.ElideRight
        }

        Text {
            width: parent.width
            text: root.value
            color: root.accentColor
            font.family: DashboardTypography.family
            font.pixelSize: DashboardTypography.body
            font.bold: true
            elide: Text.ElideRight
        }
    }
}
