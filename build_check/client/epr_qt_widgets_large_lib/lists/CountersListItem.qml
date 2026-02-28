import QtQuick
import epr_qt_widgets_large_lib 1.0
Rectangle {
    id:root
    implicitWidth: ScalingUtility.getScaledValue(700)
    height: textContainer.height + textContainer.anchors.topMargin + textContainer.anchors.bottomMargin
    color: ColorSemantic.layerVariant1BackgroundDefault
    radius: ScalingUtility.getScaledValue(Spacing.space2)

    property alias label: label.text

    property alias value1: value1.text
    property alias dateValue1: dateValue1.text
    property alias showDateValue1: dateValue1.visible

    property alias value2: value2.text
    property alias showValue2: value2.visible
    property alias dateValue2: dateValue2.text
    property alias showDateValue2: dateValue2.visible

    property alias showIcon: resetIcon.visible

    signal clicked()

    Row{
        id:textContainer
        spacing: ScalingUtility.getScaledValue(Spacing.space8)
        width: root.width - (resetIcon.width + resetIcon.anchors.leftMargin)
        height: Math.max(label.height,valueDateContainer.height)
        anchors{
            left: parent.left
            leftMargin: ScalingUtility.getScaledValue(Spacing.space6)
            top: parent.top
            topMargin: ScalingUtility.getScaledValue(Spacing.space4)
            bottom: parent.bottom
            bottomMargin: ScalingUtility.getScaledValue(Spacing.space4)
            right: (showIcon) ? resetIcon.left : parent.right
            rightMargin: (showIcon) ? ScalingUtility.getScaledValue(Spacing.space8) :ScalingUtility.getScaledValue(Spacing.space6)
        }
        Text{
            id:label
            text: "Counter name"
            width: textContainer.width - (valueDateContainer.width + textContainer.spacing)
            color: ColorSemantic.contentDefault
            font: FontStyle.lRegular
            lineHeight: FontStyle.lLineHeight
            lineHeightMode: Text.FixedHeight
            maximumLineCount: 2
            wrapMode: Text.Wrap
            elide: Text.ElideRight

        }
        Row{
            id: valueDateContainer
            spacing: ScalingUtility.getScaledValue(Spacing.space6)
            anchors.verticalCenter: parent.verticalCenter
            Column{
                id:columnValue1
                spacing: ScalingUtility.getScaledValue(Spacing.space1)
                Text{
                    id: value1
                    text: "Value 1"
                    color: ColorSemantic.contentDefault
                    font: FontStyle.lRegular
                    lineHeight: FontStyle.lLineHeight
                    lineHeightMode: Text.FixedHeight
                    maximumLineCount: 1
                    wrapMode: Text.Wrap
                    elide: Text.ElideRight
                    anchors.horizontalCenter: parent.horizontalCenter

                }
                Text{
                    id: dateValue1
                    text: "dd/mm/yy"
                    color: ColorSemantic.contentDefault
                    font: FontStyle.xsRegular
                    lineHeight: FontStyle.xsLineHeigth
                    lineHeightMode: Text.FixedHeight
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
            Column{
                id:columnValue2
                spacing: ScalingUtility.getScaledValue(Spacing.space1)
                Text{
                    id: value2
                    text: "Value 2"
                    color: ColorSemantic.contentDefault
                    font: FontStyle.lRegular
                    lineHeight: FontStyle.lLineHeight
                    lineHeightMode: Text.FixedHeight
                    maximumLineCount: 1
                    wrapMode: Text.Wrap
                    elide: Text.ElideRight
                    anchors.horizontalCenter: parent.horizontalCenter

                }
                Text{
                    id: dateValue2
                    text: "dd/mm/yy"
                    color: ColorSemantic.contentDefault
                    font: FontStyle.xsRegular
                    lineHeight: FontStyle.xsLineHeigth
                    lineHeightMode: Text.FixedHeight
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }
    }
    IconButton{
        id:resetIcon
        size: IconButton.Size.Medium
        defaultIcon: "../images/refresh.png"
        anchors{
            right: parent.right
            rightMargin: ScalingUtility.getScaledValue(Spacing.space6)
            verticalCenter: parent.verticalCenter
        }
        onClicked: root.clicked()
    }
}
