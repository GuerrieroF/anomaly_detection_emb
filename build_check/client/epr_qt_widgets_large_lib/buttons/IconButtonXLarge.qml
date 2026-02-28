import QtQuick 2.15 
import QtQuick.Controls
import "../colors"
import "../spacing"
import "../"

Rectangle {
    id: container

    property bool statusActive: false
    property url icon: "../images/placeholder_large.png"
    property url selectedIcon: "../images/placeholder_active_large.png"
    property url disabledIcon: "../images/placeholder_disabled_large"

    signal clicked()

    width: height
    height: ScalingUtility.getScaledValue(96)
    radius: ScalingUtility.getScaledValue(Spacing.space2)
    color: statusActive ? ColorSemantic.pillBackgroundActive : ColorSemantic.layerVariant1BackgroundDefault

    Image {
        id: iconButton
        anchors.centerIn: parent
        source: enabled ? (statusActive ? selectedIcon : icon) : disabledIcon
    }

    MouseArea {
        anchors.fill: parent
        onClicked: container.clicked()
        enabled: container.enabled
    }
}
