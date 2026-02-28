import QtQuick
import QtQuick.Effects
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
    property url defaultIcon: "../images/caret_right_small.png"
    property url activeIcon: "../images/caret_right_small_active.png"
    property url disabledIcon: "../images/caret_right_small_disabled.png"
    property alias showIcon: icon.visible
    property alias maximumLines: label.maximumLineCount

    signal toggled()


    Text {
        id: label

        anchors{
            left: parent.left
            right: icon.visible ? icon.left : parent.right
            verticalCenter: parent.verticalCenter
        }
        topPadding: ScalingUtility.getScaledValue(Spacing.space4)
        bottomPadding: topPadding
        leftPadding: ScalingUtility.getScaledValue(Spacing.space6)
        rightPadding: ScalingUtility.getScaledValue(icon.visible ? Spacing.space8 : Spacing.space6 )

        text: "Label"
        font: FontStyle.lRegular
        lineHeight: FontStyle.lLineHeight
        lineHeightMode: Text.FixedHeight
        color: root.disabled ? ColorSemantic.contentDisabled : (root.active ? ColorSemantic.contentSelected : ColorSemantic.contentDefault)
        maximumLineCount: 1
        wrapMode: Text.Wrap
        elide: Text.ElideRight
    }

    Image {
        id: icon
        anchors{
            right: parent.right
            rightMargin: ScalingUtility.getScaledValue(Spacing.space6)
            verticalCenter: label.verticalCenter
        }
        source: root.disabled ? root.disabledIcon : (root.active ? root.activeIcon : defaultIcon)
    }

    MouseArea{
        anchors.fill: parent
        enabled: !root.disabled
        onClicked: {
            root.toggled()
        }
    }
}

