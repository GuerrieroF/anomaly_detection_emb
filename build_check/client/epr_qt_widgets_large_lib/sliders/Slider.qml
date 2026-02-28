import QtQuick 2.15
import QtQuick.Controls.Basic as Controls
import "../"
import "../spacing"
import "../buttons"
import "../fonts"
import "../colors"


Row {
    id:container

    property bool showButtons: true
    property bool showValue: true

    property alias value: slider.value
    property alias label: label.text
    property alias stepSize: slider.stepSize
    property alias minValue: slider.from
    property alias maxValue: slider.to
    property int valueWidth: ScalingUtility.getScaledValue(100)

    property alias color: fillRectangle.color

    property bool fixedLenghtValue: true


    height: ScalingUtility.getScaledValue(48)
    width: parent.width

    spacing: ScalingUtility.getScaledValue(Spacing.space4)

    IconButton {
        id: decrementButton
        visible: showButtons
        size: IconButton.Size.Medium
        defaultIcon: "../images/removeIconMedium.png"
        onClicked: slider.decrease()
    }

    Controls.Slider {
        id: slider
        height: parent.height
        width: parent.width - (showButtons * (decrementButton.width + incrementButton.width + (container.spacing*2))) - (showValue * (label.width + container.spacing))
        from: 0
        to: 100
        value: 25
        stepSize: 0.1
        snapMode: Controls.Slider.SnapAlways

        background: Rectangle {
                x: slider.left
                y: slider.topPadding + slider.availableHeight / 2 - height / 2
                width: slider.width
                height: ScalingUtility.getScaledValue(3)
                radius: ScalingUtility.getScaledValue(3)
                color: ColorSemantic.strokeBorder

                Rectangle {
                    id: fillRectangle
                    width: (slider.visualPosition * parent.width) + (height * (1-slider.visualPosition))
                    anchors.verticalCenter: parent.verticalCenter
                    height: ScalingUtility.getScaledValue(19)
                    color: ColorSemantic.contentSelected
                    radius: ScalingUtility.getScaledValue(10)
                }
            }

        handle: Rectangle {
               x: slider.visualPosition * (slider.availableWidth - width)
               y: slider.topPadding + slider.availableHeight / 2 - height / 2
               implicitHeight: ScalingUtility.getScaledValue(19)
               implicitWidth: implicitHeight
               radius: implicitHeight
               color: "transparent"
        }
    }

    Text {
        id: label
        text: "100 °C"
        visible: showValue
        width: container.fixedLenghtValue ? container.valueWidth : undefined

        anchors.verticalCenter: parent.verticalCenter

        color: ColorSemantic.contentDefault

        font: FontStyle.lRegular
        lineHeight: FontStyle.lLineHeight
        lineHeightMode: Text.FixedHeight
    }

    IconButton {
        id: incrementButton
        visible: showButtons
        size: IconButton.Size.Medium
        defaultIcon: "../images/addIconMedium.png"
        onClicked: slider.increase()
    }

}


