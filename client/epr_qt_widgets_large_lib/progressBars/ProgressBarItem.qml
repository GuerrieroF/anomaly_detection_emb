import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Effects
import "../"
import "../spacing"
import "../fonts"
import "../colors"

Item {
    id: container

    property alias progressBarValue: progressBar.value
    property alias progressBarFrom: progressBar.from
    property alias progressBarTo: progressBar.to
    property alias progressBarIndeterminate: progressBar.indeterminate
    property alias progressBarPosition: progressBar.position
    property alias progressBarVisualPosition: progressBar.visualPosition
    property alias progressBarContentColor: progressBarContentRectColor.color
    property color progressBarGradientMainColor
    property color progressBarGradientSecondaryColor
    property alias hasLabel: label.visible
    property alias labelText: label.text
    property alias animationDuration: progressBarGradientAnimation.duration
    property bool animate: false

    enum Size {
        Small,
        Medium,
        Large
    }

    property int size: ProgressBarItem.Size.Small

    width: ScalingUtility.getScaledValue(432)
    height: columnContainer.height

    Column {
        id: columnContainer

        spacing: Spacing.space2

        ProgressBar {
            id: progressBar
            width: container.width
            height: {
                if (container.size === ProgressBarItem.Size.Small) {
                    return ScalingUtility.getScaledValue(Spacing.space1)
                } else if (container.size === ProgressBarItem.Size.Medium) {
                    return ScalingUtility.getScaledValue(Spacing.space2)
                }
                return ScalingUtility.getScaledValue(Spacing.space4)
            }

            value: 0.5

            background: Rectangle {
                id: progressBarBackground
                width: progressBar.width
                height: progressBar.height
                radius: {
                    if (ProgressBarItem.Size.Large) {
                        return ScalingUtility.getScaledValue(Spacing.space2)
                    }
                    return ScalingUtility.getScaledValue(Spacing.space1)
                }
                color: ColorSemantic.strokeBorder
                opacity: 0.2
            }

            contentItem: Item {
                id: progressBarContentItem
                width: progressBar.width
                height: progressBar.height

                Rectangle {
                    id: progressBarContentRectGradient
                    visible: animate
                    width: progressBar.visualPosition * parent.width
                    height: parent.height
                    radius: progressBarBackground.radius
                    color: ColorSemantic.strokeDefault

                    property double offset: 0

                    gradient: Gradient {
                        orientation: Gradient.Horizontal
                        GradientStop { position: 0.0 + progressBarContentRectGradient.offset; color: progressBarGradientSecondaryColor }
                        GradientStop { position: 0.5 + progressBarContentRectGradient.offset; color: progressBarGradientMainColor }
                        GradientStop { position: 1.0 + progressBarContentRectGradient.offset; color: progressBarGradientSecondaryColor }
                    }

                    NumberAnimation {
                        id: progressBarGradientAnimation
                        target: progressBarContentRectGradient
                        property: "offset"
                        from: -1
                        to: 1
                        duration: 1000
                        running: animate
                        loops: Animation.Infinite
                    }
                }

                Rectangle {
                    id: progressBarContentRectColor
                    visible: !animate
                    width: progressBar.visualPosition * parent.width
                    height: parent.height
                    radius: progressBarBackground.radius
                    color: ColorSemantic.strokeDefault
                }
            }
        }

        Text {
            id: label
            text: "Duration"
            width: container.width
            font: FontStyle.mRegular
            lineHeight: FontStyle.mLineHeigth
            lineHeightMode: Text.FixedHeight
            wrapMode: Text.WordWrap
            color: ColorSemantic.contentDefault
        }
    }
}
