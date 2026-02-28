import QtQuick
import epr_qt_widgets_large_lib 1.0

Rectangle {
    id: root
    implicitWidth: ScalingUtility.getScaledValue(700)
    height: toogleContainer.height + toogleContainer.anchors.topMargin + container.height + container.anchors.topMargin + ScalingUtility.getScaledValue(Spacing.space6)
    radius: ScalingUtility.getScaledValue(Spacing.space2)
    color: ColorSemantic.layerVariant1BackgroundDefault


    property bool disabled: false
    property bool active: false
    property alias toggleLabel: toogleLabel.text
    property alias animationEnabled: switchButton.animationEnabled
    property alias animationDuration: switchButton.animationDuration
    property alias animationEasingType: switchButton.animationEasingType

    signal toggled()

    property alias parameterLabel: label.text
    property alias parameterValue: value.text

    property string minMaxValue: "min XXX - max XXX"

    Item{
        id:toogleContainer
        height: toogleLabel.height
        width: parent.width
        anchors{
            top: parent.top
            topMargin: ScalingUtility.getScaledValue(Spacing.space6)
            left:parent.left
            leftMargin: anchors.topMargin
            right: parent.right
            rightMargin: anchors.topMargin
        }

        Text {
            id: toogleLabel

            anchors{
                left: parent.left
                right: switchButton.left
                rightMargin: ScalingUtility.getScaledValue(Spacing.space8)
            }

            text: "Activate parameter name"
            font: FontStyle.lRegular
            lineHeight: FontStyle.lLineHeight
            lineHeightMode: Text.FixedHeight
            color: ColorSemantic.contentDefault
            maximumLineCount: 1
            wrapMode: Text.Wrap
            elide: Text.ElideRight
        }

        SwitchButton {
            id: switchButton
            anchors{
                right: parent.right
            }
            active: root.active
            disabled: root.disabled
        }
    }

    Item{
        id:container
        width: root.width
        height: containerValue.height + minMax.height
        anchors{
            top: toogleContainer.bottom
            topMargin: ScalingUtility.getScaledValue(Spacing.space4)
            left: parent.left
            leftMargin: ScalingUtility.getScaledValue(Spacing.space6)
            right: parent.right
            rightMargin: ScalingUtility.getScaledValue(Spacing.space6)
        }


        Item{
            id: containerValue
            height: label.height
            width: root.width - ScalingUtility.getScaledValue(Spacing.space12)
            anchors{
                top: parent.top
                left: parent.left
                leftMargin: ScalingUtility.getScaledValue(Spacing.space12)
                right: parent.right
            }

            Text {
                id: label
                width: parent.width - value.width - ScalingUtility.getScaledValue(Spacing.space8)
                anchors{
                    right: value.left
                    rightMargin: ScalingUtility.getScaledValue(Spacing.space8)
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
                anchors.right: parent.right
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
            anchors.top: containerValue.bottom
            anchors.topMargin: ScalingUtility.getScaledValue(Spacing.space1)
            anchors.right: parent.right
        }
    }

    MouseArea{
        anchors.fill: parent
        onClicked: {
            root.toggled()
        }
    }
}
