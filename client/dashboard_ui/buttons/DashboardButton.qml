import QtQuick
import QtQuick.Controls
import Dashboard.Ui 1.0

AbstractButton {
    id: root

    property string iconName: ""
    property url iconSource: ""
    property string toolTip: ""
    property bool selected: checked
    property int iconSize: 22
    property int cornerRadius: DashboardSpacing.radiusMd
    property color backgroundColor: DashboardColors.surfaceMuted
    property color hoveredColor: DashboardColors.surfaceRaised
    property color pressedColor: DashboardColors.accentMuted
    property color selectedColor: DashboardColors.accent
    property color foregroundColor: DashboardColors.textSecondary
    property color selectedForegroundColor: DashboardColors.background
    property color borderColor: DashboardColors.border
    property color focusColor: DashboardColors.cyan
    property real disabledOpacity: 0.4

    implicitWidth: Math.max(DashboardSpacing.minTouch, implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(DashboardSpacing.minTouch, implicitContentHeight + topPadding + bottomPadding)
    padding: DashboardSpacing.sm
    spacing: DashboardSpacing.sm
    hoverEnabled: true
    focusPolicy: Qt.StrongFocus
    opacity: enabled ? 1 : disabledOpacity
    font.family: DashboardTypography.family
    font.pixelSize: DashboardTypography.body
    Accessible.name: text || toolTip

    background: Rectangle {
        radius: root.cornerRadius
        color: root.down ? root.pressedColor : (root.selected ? root.selectedColor : (root.hovered ? root.hoveredColor : root.backgroundColor))
        border.width: root.visualFocus ? 2 : 1
        border.color: root.visualFocus ? root.focusColor : (root.selected ? root.selectedColor : root.borderColor)
    }

    contentItem: Item {
        implicitWidth: contentRow.implicitWidth
        implicitHeight: contentRow.implicitHeight

        Row {
            id: contentRow
            anchors.centerIn: parent
            spacing: root.spacing

            Item {
                width: root.iconSize
                height: root.iconSize
                visible: root.iconName.length > 0 || root.iconSource.toString().length > 0
                anchors.verticalCenter: parent.verticalCenter

                IconGlyph {
                    anchors.fill: parent
                    visible: root.iconSource.toString().length === 0
                    name: root.iconName
                    strokeColor: root.selected ? root.selectedForegroundColor : root.foregroundColor
                }

                Image {
                    anchors.fill: parent
                    visible: root.iconSource.toString().length > 0
                    source: root.iconSource
                    fillMode: Image.PreserveAspectFit
                }
            }

            Text {
                visible: root.text.length > 0
                text: root.text
                font: root.font
                color: root.selected ? root.selectedForegroundColor : root.foregroundColor
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }

    ToolTip.visible: hovered && toolTip.length > 0
    ToolTip.text: toolTip
    ToolTip.delay: 500
}
