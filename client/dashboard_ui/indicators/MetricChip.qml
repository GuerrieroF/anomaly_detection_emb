import QtQuick
import Dashboard.Ui 1.0

Rectangle {
    id: root

    property int padding: DashboardSpacing.sm
    property color labelColor: DashboardColors.textSecondary
    property font labelFont: Qt.font({ family: DashboardTypography.family, pixelSize: DashboardTypography.tiny })
    property font valueFont: Qt.font({ family: DashboardTypography.family, pixelSize: DashboardTypography.body, bold: true })

    property string label: ""
    property string value: ""
    property color accentColor: DashboardColors.accent

    implicitWidth: 104
    implicitHeight: labels.implicitHeight + 2 * padding
    radius: DashboardSpacing.radiusSm
    color: DashboardColors.surfaceMuted
    border.width: 1
    border.color: DashboardColors.border

    Column {
        id: labels
        anchors.fill: parent
        anchors.margins: root.padding
        spacing: 1

        Text {
            width: parent.width
            text: root.label
            color: root.labelColor
            font: root.labelFont
            elide: Text.ElideRight
        }

        Text {
            width: parent.width
            text: root.value
            color: root.accentColor
            font: root.valueFont
            elide: Text.ElideRight
        }
    }
}
