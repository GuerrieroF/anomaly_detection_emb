import QtQuick 2.15
import "../"
import "../colors"
import "../fonts"
import "../spacing"

CustomRoundedRectangle {
    id: buttonContainer

    property alias label: buttonLabel.text
    property alias labelColor: buttonLabel.color
    property alias labelFont: buttonLabel.font
    property alias icon: buttonIcon.source
    property bool showIcons: false

    signal buttonClicked()

    width: parent.width
    height: ScalingUtility.getScaledValue(72)
    radius: ScalingUtility.getScaledValue(Spacing.space2)

    backgroundColor: ColorSemantic.contentSelected
    borderColor: ColorSemantic.strokeBorder
    borderWidth: 1

    roundTopLeft: false
    roundTopRight: false

    Row {
        spacing: ScalingUtility.getScaledValue(Spacing.space4)
        anchors.centerIn: parent

        Image {
            id: buttonIcon
            asynchronous: true
            anchors.verticalCenter: parent.verticalCenter
            visible: showIcons
            source: "../images/favorite_white.png"
        }

        Text {
            id: buttonLabel
            anchors.verticalCenter: parent.verticalCenter
            text: "Got it"
            font: FontStyle.lSemibold
            lineHeight: FontStyle.lLineHeight
            lineHeightMode: Text.FixedHeight
            color: ColorSemantic.buttonPrimaryContentDefault
        }

    }

    MouseArea {
        anchors.fill: parent
        onClicked: buttonClicked()
        enabled: parent.enabled
    }

}
