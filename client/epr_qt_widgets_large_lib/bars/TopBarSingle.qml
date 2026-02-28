import QtQuick 2.15
import "../buttons"
import "../parts"
import "../"

Rectangle {
    id: container

    property alias showIconLeft: leftImage.visible
    property alias iconLeft: leftImage.defaultIcon
    property alias iconLeftEnabled: leftImage.enabled
    property alias iconLeftDisabledImage: leftImage.disabledIcon

    property alias showIconRight1: rightImage1.visible
    property alias iconRight1: rightImage1.defaultIcon
    property alias iconRight1Enabled: rightImage1.enabled
    property alias iconRight1DisabledImage: rightImage1.disabledIcon

    property alias showIconRight2: rightImage2.visible
    property alias iconRight2: rightImage2.defaultIcon
    property alias iconRight2Enabled: rightImage2.enabled
    property alias iconRight2DisabledImage: rightImage2.disabledIcon

    property alias showIconRight3: rightImage3.visible
    property alias iconRight3: rightImage3.defaultIcon
    property alias iconRight3Enabled: rightImage3.enabled
    property alias iconRight3DisabledImage: rightImage3.disabledIcon

    property alias showIconRight4: rightImage4.visible
    property alias iconRight4: rightImage4.defaultIcon
    property alias iconRight4Enabled: rightImage4.enabled
    property alias iconRight4DisabledImage: rightImage4.disabledIcon

    property alias showIconRight5: rightImage5.visible
    property alias iconRight5: rightImage5.defaultIcon
    property alias iconRight5Enabled: rightImage5.enabled
    property alias iconRight5DisabledImage: rightImage5.disabledIcon

    property alias label: navigationItem.label
    property alias labelIcon: navigationItem.icon
    property alias showLabelIcon: navigationItem.showIcon

    property int selectedIndex: -1

    signal rightIcon1Clicked()
    signal rightIcon2Clicked()
    signal rightIcon3Clicked()
    signal rightIcon4Clicked()
    signal rightIcon5Clicked()
    signal leftIconClicked()

    width: ScalingUtility.getScaledValue(1024)
    height: ScalingUtility.getScaledValue(56)
    color: ColorSemantic.layerVariant1BackgroundDefault

    IconButton {
        id: leftImage
        size: IconButton.Size.Large
        anchors.left: parent.left
        anchors.leftMargin: ScalingUtility.getScaledValue(16)
        anchors.verticalCenter: parent.verticalCenter
        defaultIcon: "../images/hamburgerIconMedium.png"
        onClicked: leftIconClicked()
    }

    Rectangle {
        id: tabContainer
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        color: parent.color
        height: parent.height

        TabbedNavigationItem {
            id: navigationItem
            size: TabbedNavigationItem.Size.Small
            anchors.centerIn: parent
            showIcon: false
            useSemibold: true
        }
    }

    Row {
        id: buttonsRow
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: ScalingUtility.getScaledValue(16)
        spacing: Spacing.space2

        IconButton {
            id: rightImage1
            size: IconButton.Size.Medium
            onClicked: rightIcon1Clicked()
        }

        IconButton {
            id: rightImage2
            size: IconButton.Size.Medium
            onClicked: rightIcon2Clicked()
        }

        IconButton {
            id: rightImage3
            size: IconButton.Size.Medium
            onClicked: rightIcon3Clicked()
        }

        IconButton {
            id: rightImage4
            size: IconButton.Size.Medium
            onClicked: rightIcon4Clicked()
        }

        IconButton {
            id: rightImage5
            size: IconButton.Size.Medium
            onClicked: rightIcon5Clicked()
        }
    }

    Rectangle {
        id: bottomBorder
        height: ScalingUtility.getScaledValue(1)
        width: parent.width
        anchors.bottom: parent.bottom
        color: ColorSemantic.strokeBorder
    }
}
