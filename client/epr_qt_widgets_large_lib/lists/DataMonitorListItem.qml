import QtQuick
import epr_qt_widgets_large_lib 1.0


Rectangle {
    id:root
    implicitWidth: ScalingUtility.getScaledValue(700)
    height: button.height + button.anchors.topMargin + button.anchors.bottomMargin
    color: ColorSemantic.layerVariant1BackgroundDefault
    radius: ScalingUtility.getScaledValue(Spacing.space2)

    property alias label: label.text
    property alias value: value.text
    property string minMaxValue: "min XXX - max XXX"
    property bool active: false

    signal clicked()



    Rectangle{
        id: button
        width: ScalingUtility.getScaledValue(4)
        height: ScalingUtility.getScaledValue(68)
        radius: ScalingUtility.getScaledValue(4)
        color: (active) ? ColorSemantic.contentSelected : ColorSemantic.contentDisabled
        anchors{
            left: parent.left
            leftMargin: ScalingUtility.getScaledValue(Spacing.space2)
            top: parent.top
            topMargin: ScalingUtility.getScaledValue(Spacing.space4)
            bottom: parent.bottom
            bottomMargin: ScalingUtility.getScaledValue(Spacing.space4)
        }
    }

    Item{
        id: containerValue
        height: label.height + ScalingUtility.getScaledValue(3) + ScalingUtility.getScaledValue(3)
        width: root.width - (button.width + button.anchors.leftMargin - anchors.leftMargin - anchors.rightMargin)
        anchors{
            top: parent.top
            topMargin: ScalingUtility.getScaledValue(Spacing.space4)
            left: button.right
            leftMargin: ScalingUtility.getScaledValue(Spacing.space3)
            right: parent.right
            rightMargin: ScalingUtility.getScaledValue(Spacing.space6)

        }

        Text {
            id: label
            width: parent.width - value.width - ScalingUtility.getScaledValue(Spacing.space8)
            anchors{
                left: parent.left
                right: value.left
                rightMargin: ScalingUtility.getScaledValue(Spacing.space8)
                verticalCenter: parent.verticalCenter
            }

            height: lineHeight
            text: "Parameter name"
            font: FontStyle.lRegular
            lineHeight: FontStyle.lLineHeight
            lineHeightMode: Text.FixedHeight
            color: ColorSemantic.contentDefault
            maximumLineCount: 1
            wrapMode: Text.Wrap
            elide: Text.ElideRight
        }

        Text {
            id: value
            text: "Value"
            width:{
                if(ScalingUtility.getScaledValue(textMetric.width) > ScalingUtility.getScaledValue(120))
                    return textMetric.elideWidth
                else
                    return ScalingUtility.getScaledValue(textMetric.advanceWidth)
            }
            horizontalAlignment: Text.AlignRight
            anchors{
                right: parent.right
                verticalCenter: parent.verticalCenter
            }
            font: FontStyle.lItalic
            lineHeight: FontStyle.lLineHeight
            lineHeightMode: Text.FixedHeight
            color: ColorSemantic.contentDefault
            maximumLineCount: 1
            wrapMode: Text.Wrap
            elide: Text.ElideRight
        }

        TextMetrics {
            id: textMetric
            elideWidth: ScalingUtility.getScaledValue(120)
            text: value.text
            font: value.font
        }
    }

    Text {
        id: minMax
        width: containerValue.width
        height: lineHeight
        text: root.minMaxValue
        font: FontStyle.xsItalic
        lineHeight: FontStyle.xsLineHeigth
        lineHeightMode: Text.FixedHeight
        color: ColorSemantic.contentDefault
        wrapMode: Text.Wrap
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignRight
        anchors{
            top: containerValue.bottom
            topMargin: ScalingUtility.getScaledValue(Spacing.space1)
            right: parent.right
            rightMargin: ScalingUtility.getScaledValue(Spacing.space6)
            left: button.right
            leftMargin: ScalingUtility.getScaledValue(Spacing.space3)
        }
    }

    MouseArea{
        anchors.fill: parent
        onClicked: {
            root.clicked()
        }
    }

}
