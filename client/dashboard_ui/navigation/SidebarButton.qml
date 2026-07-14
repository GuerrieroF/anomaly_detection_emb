import QtQuick
import Dashboard.Ui 1.0

Item {
    id: root

    property string iconName: "home"
    property string label: ""
    property bool selected: false
    signal clicked()

    implicitWidth: DashboardSpacing.sidebarWidth
    implicitHeight: 54

    Rectangle {
        id: buttonSurface
        width: DashboardSpacing.minTouch
        height: DashboardSpacing.minTouch
        anchors.centerIn: parent
        radius: DashboardSpacing.radiusMd
        color: root.selected ? DashboardColors.accent : (mouseArea.containsMouse ? DashboardColors.surfaceRaised : DashboardColors.surfaceMuted)
        border.width: 1
        border.color: root.selected ? DashboardColors.accent : DashboardColors.border

        IconGlyph {
            width: 22
            height: 22
            anchors.centerIn: parent
            name: root.iconName
            strokeColor: root.selected ? DashboardColors.background : DashboardColors.textSecondary
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }

    Rectangle {
        visible: mouseArea.containsMouse && root.label.length > 0
        anchors.left: buttonSurface.right
        anchors.leftMargin: DashboardSpacing.sm
        anchors.verticalCenter: buttonSurface.verticalCenter
        width: tooltipText.implicitWidth + DashboardSpacing.lg
        height: 28
        radius: DashboardSpacing.radiusSm
        color: DashboardColors.surfaceRaised
        border.width: 1
        border.color: DashboardColors.borderStrong
        z: 10

        Text {
            id: tooltipText
            anchors.centerIn: parent
            text: root.label
            color: DashboardColors.textPrimary
            font.family: DashboardTypography.family
            font.pixelSize: DashboardTypography.caption
        }
    }
}
