import QtQuick 2.15
import "../parts"
import "../spacing"
import "../colors"
import "../fonts"
import "../"

Item {
    id: container

    width: parent.width
    height: header.height + body.height + bottom.height

    property alias flowTitle: title.header
    property alias showFlowTitle: title.showHeader
    property alias title: title.message
    property alias titleIcon: title.icon
    property alias showTitleIcon: title.showIcon

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
    property alias phoneNumber: input.phoneNumber
    property alias maxDigit: input.maxDigit
    property int minDigit: 3

    signal cancelClicked()
    signal saveClicked()

    function resetInput(){
        input.phoneNumber = ""
    }

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
            showHeader: false
            message: "Technician phone number"

        }

        ModalTecnicialPhoneInputContent {
            id: input
            anchors.top: title.bottom
            anchors.topMargin: Spacing.space4
            anchors.left: header.left
            anchors.right: header.right
            anchors.leftMargin: header.leftPad
            anchors.rightMargin: header.rightPad
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
            showIcons: false

            button2Enabled: (phoneNumber.length >= minDigit)
            onButton1Clicked: container.cancelClicked()
            onButton2Clicked: container.saveClicked()

        }

    }

}

