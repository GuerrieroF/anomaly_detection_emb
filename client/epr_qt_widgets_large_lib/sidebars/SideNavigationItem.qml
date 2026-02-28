import QtQuick
import "../"
import "../spacing"
import "../fonts"
import "../colors"

Rectangle {
    id: root

    property bool active: false
    property alias label: label.text
    property bool isTwoRowText: false


    signal clicked()

    width: parent.width
    height: label.height

    color: active ? ColorSemantic.layerNeutralBackgroundDefault : ColorSemantic.layerVariant1BackgroundDefault

    Text {
        id: label
        text: "Label"
        leftPadding: ScalingUtility.getScaledValue(Spacing.space6)
        topPadding:  ScalingUtility.getScaledValue(Spacing.space3)
        bottomPadding: topPadding

        anchors{
            left: parent.left
            right: icon.left
            rightMargin: ScalingUtility.getScaledValue(Spacing.space6)
        }

        color: active ? ColorSemantic.contentSelected : ColorSemantic.contentDefault

        font: root.active ? FontStyle.lSemibold : FontStyle.lRegular
        lineHeight: FontStyle.lLineHeight
        lineHeightMode: Text.FixedHeight
        maximumLineCount: root.isTwoRowText ? 2 : 1
        wrapMode: Text.Wrap
        elide: Text.ElideRight
    }

    Image {
        id: icon
        source: active ? "../images/caret_right_small_active.png" : "../images/caret_right_small.png"
        anchors{
            right: parent.right
            rightMargin: ScalingUtility.getScaledValue(Spacing.space4)
            verticalCenter: parent.verticalCenter
        }
    }

    MouseArea{
        anchors.fill: parent
        onClicked: root.clicked()
    }

}
