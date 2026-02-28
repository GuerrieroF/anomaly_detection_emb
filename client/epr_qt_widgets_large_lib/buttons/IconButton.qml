import QtQuick 2.15
import "../spacing"
import "../"

Rectangle{
    id: container

    enum Size {
        Small,
        Medium,
        Large
    }

    property bool statusActive: false

    property int size: IconButton.Size.Small

    property url defaultIcon: "../images/placeholder_" + iconSuffix + ".png"
    property url activeIcon: "../images/placeholder_active_" + iconSuffix +".png"
    property url disabledIcon: "../images/placeholder_disabled_" + iconSuffix + ".png"

    readonly property url iconToShow: enabled ? (statusActive ? activeIcon : defaultIcon) : disabledIcon
    readonly property int padding: {
        if (container.size === IconButton.Size.Small)
            return ScalingUtility.getScaledValue(Spacing.space3)
        else if (container.size === IconButton.Size.Medium)
            return ScalingUtility.getScaledValue(Spacing.space2)

        return ScalingUtility.getScaledValue(Spacing.space0)
    }

    readonly property string iconSuffix: {
        if (container.size === IconButton.Size.Large)
            return "large"
        else if (container.size === IconButton.Size.Medium)
            return "medium"
        return "small"
    }

    signal clicked()

    width: height
    height: ScalingUtility.getScaledValue(48)
    color: "transparent"

    Rectangle {
        id: content
        anchors.fill: parent
        anchors.margins: padding

        color: container.color

        Image {
            id: icon
            anchors.centerIn: parent
            source: container.iconToShow
        }
    }

    MouseArea{
        anchors.fill: parent
        onClicked: {
            container.clicked()
        }
    }

}
