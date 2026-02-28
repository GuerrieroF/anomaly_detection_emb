import QtQuick 2.15
import "../spacing"
import "../fonts"
import "../colors"
import "../"

Rectangle {
    id: container

    enum Size {
        Small,
        Medium
    }

    property alias message: message.text
    property alias buttonLabel: button.text
    property alias icon: icon.source
    property alias showIcon: icon.visible

    property alias showButton: button.visible

    property int size: Snackbar.Size.Small

    readonly property bool isSmall: container.size === Snackbar.Size.Small
    readonly property int containerPadTop: ScalingUtility.getScaledValue(Spacing.space3)
    readonly property int containerPadBottom: containerPadTop
    readonly property int containerPadLeft: ScalingUtility.getScaledValue(Spacing.space4)
    readonly property int containerPadRight: containerPadLeft

    signal buttonClicked()

    width: ScalingUtility.getScaledValue(600)
    height: Math.max(message.contentHeight, (iconContainer.height * icon.visible)) + containerPadTop + containerPadBottom
    color: ColorPalettes.black
    radius: ScalingUtility.getScaledValue(Spacing.space2)


    Rectangle {
        id: iconContainer
        width: ScalingUtility.getScaledValue(48)
        height: width
        anchors.left: parent.left
        anchors.leftMargin: containerPadLeft
        anchors.verticalCenter: parent.verticalCenter
        color: "transparent"
        Image {
            id: icon
            anchors.centerIn: parent
            asynchronous: true
            source: "../images/placeholder_large.png"
        }
    }

    Text {
        id: message

        anchors.left: icon.visible ? iconContainer.right : parent.left
        anchors.leftMargin:  ScalingUtility.getScaledValue(icon.visible ? Spacing.space3 : containerPadLeft)

        anchors.right: button.visible ? button.left : parent.right
        anchors.rightMargin: ScalingUtility.getScaledValue(button.visible ? Spacing.space6 : containerPadRight)

        anchors.verticalCenter: parent.verticalCenter

        text: "Snackbar message"
        wrapMode: Text.Wrap
        color: ColorSemantic.contentDefault

        font: isSmall ? FontStyle.mRegular : FontStyle.lSemibold
        lineHeight: isSmall ? FontStyle.mLineHeigth : FontStyle.lLineHeight
        lineHeightMode: Text.FixedHeight
    }

    Text {
        id: button
        text: "Button"
        anchors.right: parent.right
        anchors.rightMargin: containerPadRight
        anchors.top: parent.top
        anchors.topMargin: containerPadTop
        anchors.bottom: parent.bottom
        anchors.bottomMargin: containerPadBottom
        verticalAlignment: Text.AlignVCenter

        color: ColorSemantic.contentSelected

        font: isSmall ? FontStyle.mSemiboldCapital : FontStyle.lSemiboldCapital
        lineHeight: isSmall ? FontStyle.mLineHeigth : FontStyle.lLineHeight
        lineHeightMode: Text.FixedHeight

        MouseArea {
            anchors.fill: parent
            onClicked: container.buttonClicked()
        }
    }
}
