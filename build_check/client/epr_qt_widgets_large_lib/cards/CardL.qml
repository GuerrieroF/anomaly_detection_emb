import QtQuick 2.15
import "../colors"
import "../spacing"
import "../fonts"
import "../buttons"
import "../"

Rectangle {
    id: container

    property bool statusActive: false
    property bool showIcon: true

    property alias label: label.text

    property url defaultImage: "../images/eco.png"
    property url activeImage: "../images/eco_active.png"
    property url disabledImage: "../images/eco_disabled.png"

    property alias menuActive: menu.statusActive
    property alias menuEnabled: menu.enabled
    property alias showIconMenu: menu.visible

    readonly property color textColor: enabled ? (statusActive ? ColorSemantic.contentSelected : ColorSemantic.contentDefault) : ColorSemantic.contentDisabled
    readonly property url iconToShow: enabled ? (statusActive ? activeImage : defaultImage) : disabledImage

    signal clicked()
    signal menuClicked()

    width: height
    height: ScalingUtility.getScaledValue(220)
    radius: ScalingUtility.getScaledValue(Spacing.space2)
    color: ColorSemantic.layerVariant1BackgroundDefault

    onEnabledChanged: {
        if (!enabled)
            statusActive = false
    }

    IconButton {
        id: menu
        anchors.right: parent.right
        anchors.top: parent.top

        defaultIcon: "../images/more_vertical.png"
        activeIcon: defaultIcon
        disabledIcon: "../images/more_vertical_disabled.png"
        onClicked: {
            container.menuClicked()
        }
    }


    Rectangle {
        id: iconContainer

        anchors.top: parent.top
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.bottom: parent.bottom

        anchors.leftMargin: ScalingUtility.getScaledValue(62)
        anchors.rightMargin: ScalingUtility.getScaledValue(62)
        anchors.topMargin: ScalingUtility.getScaledValue(40)
        anchors.bottomMargin: ScalingUtility.getScaledValue(84)

        color: container.color

        Image {
            id: icon
            visible: showIcon
            anchors.centerIn: parent
            source: container.iconToShow
        }
    }

    Rectangle {
        id: frame
        height: ScalingUtility.getScaledValue(61)
        width: ScalingUtility.getScaledValue(204)
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        anchors.leftMargin: ScalingUtility.getScaledValue(Spacing.space2)
        anchors.rightMargin: ScalingUtility.getScaledValue(Spacing.space2)
        anchors.bottomMargin: ScalingUtility.getScaledValue(Spacing.space2)

        color: container.color

        Text {
            id: label
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width - frame.anchors.leftMargin * 2
            height: parent.height
            horizontalAlignment: Text.AlignHCenter

            text: "Label"
            color: container.textColor
            wrapMode: Text.Wrap
            elide: Text.ElideRight
            maximumLineCount: 2

            font: FontStyle.mRegular
            lineHeight: FontStyle.mLineHeigth
            lineHeightMode: Text.FixedHeight
        }

    }

    MouseArea {
        anchors.fill: parent
        enabled: container.enabled
        onClicked: container.clicked()
    }
}
