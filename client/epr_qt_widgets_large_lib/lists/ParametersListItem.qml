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
    property bool readOnly: false
    property alias label: label.text
    property alias value: value.text

    signal toggled()


    Text {
        id: label

        anchors{
            left: parent.left
            right: value.left
            verticalCenter: parent.verticalCenter
        }
        topPadding: ScalingUtility.getScaledValue(Spacing.space4)
        bottomPadding: topPadding
        leftPadding: ScalingUtility.getScaledValue(Spacing.space6)
        rightPadding: ScalingUtility.getScaledValue(Spacing.space8)

        text: "Parameter name"
        font: FontStyle.lRegular
        lineHeight: FontStyle.lLineHeight
        lineHeightMode: Text.FixedHeight
        color: root.disabled ? ColorSemantic.contentDisabled : (root.active ? ColorSemantic.contentSelected : ColorSemantic.contentDefault)
        maximumLineCount: 2
        wrapMode: Text.Wrap
        elide: Text.ElideRight
    }

    Text {
        id: value
        anchors{
            right: parent.right
            rightMargin: ScalingUtility.getScaledValue(Spacing.space6)
            verticalCenter: label.verticalCenter
        }
        text: "Value"
        font: root.readOnly ? FontStyle.lItalic : (root.disabled ? FontStyle.lRegular : FontStyle.lUnderline)
        lineHeight: FontStyle.lLineHeight
        lineHeightMode: Text.FixedHeight
        color: root.disabled ? ColorSemantic.contentDisabled : (root.active ? ColorSemantic.contentSelected : ColorSemantic.contentDefault)
        maximumLineCount: 1
        wrapMode: Text.Wrap
        elide: Text.ElideRight
    }

    MouseArea{
        anchors.fill: parent
        enabled: !root.disabled && !root.readOnly
        onClicked: {
            root.toggled()
        }
    }
}

