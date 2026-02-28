import QtQuick 2.15
import "../parts"
import "../spacing"
import "../colors"
import "../fonts"
import "../"

Item {
    id: container

    property alias parameterID: title.header
    property alias showParameterID: title.showHeader
    property alias parameterName: title.message
    property alias parameterIcon: title.icon
    property alias showParameterIcon: title.showIcon

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
    property alias showSigns: pad.showSigns
    property alias isPowerLevel: pad.isPowerLevel

    property alias parameterValue: input.value
    property int minValue: 0
    property int maxValue: 100
    property alias autoAdjust: input.autoAdjust
    property alias adjustInterval: input.adjustInterval
    property alias outOfRange: input.outOfRange
    property alias displayValue: input.displayValue
    property alias uom: input.unit
    property alias showUom: input.showUnit
    property alias showCancelInput: input.showCancelButton
    property alias message: input.message
    property alias errorMessage: input.errorMessage

    signal cancelClicked()
    signal saveClicked()

    width: parent.width
    height: header.height + body.height + bottom.height

    ModalHeader {
        id: header
        width: parent.width
        height: title.height + input.height + input.anchors.topMargin + topPad + bottomPad

        ModalTopTitleContent {
            id: title
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.topMargin: header.topPad
            anchors.leftMargin: header.leftPad
            anchors.rightMargin: header.rightPad
            showIcon: false
            showMetadata: false

            header: "Parameter ID"
            message: "Parameter name"

        }

        ModalValueInputContent {
            id: input
            anchors.top: title.bottom
            anchors.topMargin: Spacing.space4
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: header.leftPad
            anchors.rightMargin: header.rightPad

            minValue: isPowerLevel ? (showSigns ? -9 : 1) : container.minValue
            maxValue: isPowerLevel ? 9 : container.maxValue
            value: isPowerLevel ? 5 : 50
        }

    }

    ModalBody {
        id: body
        readonly property int topPad: ScalingUtility.getScaledValue(Spacing.space6)
        readonly property int bottomPad: topPad
        anchors.top: header.bottom
        height: pad.height + topPad + bottomPad


        NumericKeyboard {
            id: pad
            anchors.top: body.top
            anchors.topMargin: body.topPad
            anchors.horizontalCenter: body.horizontalCenter
            size: NumericKeyboard.Size.Vertical
            onNumberClicked: (numberString) => input.addDigit(numberString)
            onMinusClicked: input.addSign("-")
            onPlusClicked:  input.addSign("+")
        }

    }

    ModalBottomDoubleButton {
        id: bottom
        anchors.top: body.bottom
        width: parent.width
        height: ScalingUtility.getScaledValue(70)

        label1: "Cancel"
        label1Color: button1Enabled ? ColorSemantic.buttonSecondaryContentDefault : ColorSemantic.buttonSecondaryContentDisabled

        label2: "Save"
        label2Color: ColorSemantic.buttonPrimaryContentDefault
        label2Font: FontStyle.lSemibold
        button2Color: button2Enabled ? ColorSemantic.buttonPrimaryBackgroundDefault : ColorSemantic.buttonPrimaryBackgroundDisabled
        button2Enabled: input.displayValue !== "" && !input.outOfRange

        showIcons: false

        onButton1Clicked: container.cancelClicked()
        onButton2Clicked: container.saveClicked()


    }

}
