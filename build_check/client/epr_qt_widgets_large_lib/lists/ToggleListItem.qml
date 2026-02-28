import QtQuick
import "../"
import "../spacing"
import "../colors"
import "../fonts"
import "../parts"

Rectangle{
    id: root
    implicitWidth: ScalingUtility.getScaledValue(700)
    height: label.height

    color: ColorSemantic.layerVariant1BackgroundDefault
    radius: ScalingUtility.getScaledValue(Spacing.space2)

    property bool disabled: false
    property bool active: false
    property alias label: label.text
    property alias animationEnabled: switchButton.animationEnabled
    property alias animationDuration: switchButton.animationDuration
    property alias animationEasingType: switchButton.animationEasingType

    signal toggled()

    Text {
        id: label

        anchors{
            left: parent.left
            right: switchButton.left
        }
        topPadding: ScalingUtility.getScaledValue(Spacing.space4)
        bottomPadding: topPadding
        leftPadding: ScalingUtility.getScaledValue(Spacing.space6)
        rightPadding: ScalingUtility.getScaledValue(Spacing.space8)


        text: "Label"
        font: FontStyle.lRegular
        lineHeight: FontStyle.lLineHeight
        lineHeightMode: Text.FixedHeight
        color: root.disabled ? ColorSemantic.contentDisabled : ColorSemantic.contentDefault
        maximumLineCount: 2
        wrapMode: Text.Wrap
        elide: Text.ElideRight
        anchors.verticalCenter: parent.verticalCenter
    }

    SwitchButton {
        id: switchButton
        anchors{
            right: parent.right
            rightMargin: ScalingUtility.getScaledValue(Spacing.space6)
            verticalCenter: label.verticalCenter
        }
        active: root.active
        disabled: root.disabled
    }

    MouseArea{
        anchors.fill: parent
        enabled: !root.disabled
        onClicked: {
            root.toggled()
        }
    }
}

