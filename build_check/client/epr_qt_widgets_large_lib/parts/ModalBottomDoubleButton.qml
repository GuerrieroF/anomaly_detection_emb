import QtQuick 2.15
import "../"
import "../colors"
import "../fonts"
import "../spacing"


CustomRoundedRectangle {
    id: buttonContainer

    property alias label1: button1Label.text
    property alias label2: button2Label.text

    property alias label1Color: button1Label.color
    property alias label2Color: button2Label.color

    property alias label1Font: button1Label.font
    property alias label2Font: button2Label.font

    property bool showIcons: true
    property alias icon1: button1Icon.source
    property alias icon2: button2Icon.source

    property alias button1Enabled: button1.enabled
    property alias button2Enabled: button2.enabled

    property alias button1Color: button1.backgroundColor
    property alias button2Color: button2.backgroundColor
    property alias showButtonSeparator: separator.visible

    signal button1Clicked()
    signal button2Clicked()

    width: parent.width
    height: parent.height

    backgroundColor: ColorSemantic.buttonSecondaryBackgroundDefault
    borderColor: ColorSemantic.strokeBorder
    borderWidth: 1

    roundTopLeft: false
    roundTopRight: false
    radius: ScalingUtility.getScaledValue(Spacing.space2)

    Rectangle {
        id: separator
        anchors.horizontalCenter: parent.horizontalCenter
        visible: false

        height: buttonContainer.height
        width: buttonContainer.borderWidth
        color: buttonContainer.borderColor
    }

    CustomRoundedRectangle {
        id: button1
        height: parent.height - 2*buttonContainer.borderWidth
        width: Math.floor(parent.width/2) - buttonContainer.borderWidth
        anchors.left: parent.left
        anchors.leftMargin: buttonContainer.borderWidth
        anchors.verticalCenter: parent.verticalCenter
        backgroundColor: "transparent"
        radius: buttonContainer.radius

        roundTopLeft: false
        roundTopRight: false
        roundBottomRight: false

        Row {
            spacing: ScalingUtility.getScaledValue(Spacing.space4)
            anchors.centerIn: parent

            Image {
                id: button1Icon
                asynchronous: true
                anchors.verticalCenter: parent.verticalCenter
                visible: showIcons
                source: "../images/favorite_white.png"
            }
            Text {
                id: button1Label
                anchors.verticalCenter: parent.verticalCenter
                text: "Label1"
                font: FontStyle.lRegular
                lineHeight: FontStyle.lLineHeight
                lineHeightMode: Text.FixedHeight
                color: ColorSemantic.buttonSecondaryContentDefault
            }

        }

        MouseArea {
            anchors.fill: parent
            onClicked: button1Clicked()
            enabled: parent.enabled
        }
    }

    CustomRoundedRectangle {
        id: button2

        height: parent.height - 2*buttonContainer.borderWidth
        width: Math.floor(parent.width/2) - buttonContainer.borderWidth
        anchors.right: parent.right
        anchors.rightMargin: buttonContainer.borderWidth
        anchors.verticalCenter: parent.verticalCenter
        backgroundColor: "transparent"
        radius: buttonContainer.radius

        roundTopLeft: false
        roundTopRight: false
        roundBottomLeft: false

        Row {
            spacing: ScalingUtility.getScaledValue(Spacing.space4)
            anchors.centerIn: parent
            Image {
                id: button2Icon
                asynchronous: true
                anchors.verticalCenter: parent.verticalCenter
                visible: showIcons
                source: "../images/favorite_white.png"
            }
            Text {
                id: button2Label
                anchors.verticalCenter: parent.verticalCenter
                text: "Label2"
                font: FontStyle.lRegular
                lineHeight: FontStyle.lLineHeight
                lineHeightMode: Text.FixedHeight
                color: ColorSemantic.buttonSecondaryContentDefault
            }

        }

        MouseArea {
            anchors.fill: parent
            onClicked: button2Clicked()
            enabled: parent.enabled
        }
    }

}

