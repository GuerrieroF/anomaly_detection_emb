import QtQuick
import "../parts"
import "../spacing"
import "../colors"
import "../fonts"
import "../segmentedControls"
import "../"
import "../sliders"

Item {
    id: container

    property alias title: title.header
    property alias showTitle: title.showHeader
    property alias message: title.message
    property alias messageIcon: title.icon
    property alias showMessageIcon: title.showIcon

    property alias showSliderButtons: slide.showButtons
    property alias showSliderValue: slide.showValue

    property alias sliderValue: slide.value
    property alias sliderLabel: slide.label
    property alias sliderStepSize: slide.stepSize
    property alias sliderMinValue: slide.minValue
    property alias sliderMaxValue: slide.maxValue

    property alias sliderColor: slide.color

    property alias button1Label: bottom.label1
    property alias labe1Font: bottom.label1Font
    property alias labe1Color: bottom.label1Color
    property alias button1Icon: bottom.icon1
    property alias button1Enabled: bottom.button1Enabled
    property alias button1Color: bottom.button1Color

    property alias button2Label: bottom.label2
    property alias labe2Font: bottom.label2Font
    property alias labe2Color: bottom.label2Color
    property alias button2Icon: bottom.icon2
    property alias button2Enabled: bottom.button2Enabled
    property alias button2Color: bottom.button2Color

    property alias showButtonIcons: bottom.showIcons

    signal cancelClicked()
    signal saveClicked()

    height: header.height + body.height + bottom.height

    ModalHeader {
        id: header
        anchors{
            top: parent.top
            left: parent.left
            right: parent.right
        }
        height: title.height + header.topPad + header.bottomPad

        ModalTopTitleContent {
            id: title
            anchors{
                left: parent.left
                right: parent.right
                top: parent.top
                topMargin: header.topPad
                leftMargin: header.leftPad
                rightMargin: header.rightPad
            }
            showIcon: false
            showMetadata: false

            header: "Flow title"
            message: "Title of the message"
        }
    }

    ModalBody {
        id: body
        anchors{
            top: header.bottom
            left: parent.left
            right: parent.right
        }
        height: slide.height + ScalingUtility.getScaledValue(Spacing.space12) + ScalingUtility.getScaledValue(Spacing.space12)

        Slider{
            id: slide
            anchors{
                left: parent.left
                right: parent.right
                rightMargin: ScalingUtility.getScaledValue(Spacing.space12)
                leftMargin: anchors.rightMargin
                verticalCenter: parent.verticalCenter
            }
            fixedLenghtValue: false
        }
    }

    ModalBottomDoubleButton {
        id: bottom
        anchors{
            left: parent.left
            right: parent.right
            top: body.bottom
        }
        height: ScalingUtility.getScaledValue(70)

        label1: "Cancel"
        label1Color: ColorSemantic.buttonSecondaryContentDefault

        label2: "Apply"
        label2Color: ColorSemantic.buttonPrimaryContentDefault
        label2Font: FontStyle.lSemibold
        button2Color: ColorSemantic.buttonPrimaryBackgroundDefault

        showIcons: false

        onButton1Clicked: container.cancelClicked()

        onButton2Clicked: container.saveClicked()

    }
}
