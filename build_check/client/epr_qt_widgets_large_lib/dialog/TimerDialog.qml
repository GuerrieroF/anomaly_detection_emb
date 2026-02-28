import QtQuick
import "../parts"
import "../spacing"
import "../colors"
import "../fonts"
import "../segmentedControls"
import "../"

Item {
    id: container

    property alias flowTitle: title.header
    property alias showFlowTitle: title.showHeader

    property alias title: title.message
    property alias showTitleIcon: title.showIcon
    property alias titleIcon: title.icon

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

    property alias timeInSeconds: input.initialTime
    property alias maxTimeInSeconds: input.maxTimeInSeconds
    property alias minTimeInSeconds: input.minTimeInSeconds
    property alias adjustInterval: input.adjustInterval
    property alias autoAdjust: input.autoAdjust

    property string timeFormat: timeInSeconds < 60 ? "mm:ss" : "hh:mm"

    signal cancelClicked()
    signal saveClicked()

    width: parent.width
    height: header.height + body.height + bottom.height

    function getTimeInSecs() {
        return input.getTimeInSecs()
    }

    function normalize() {
        input.normalizeTime()
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

            header: "Heading"
            message: "Timer"

        }

        ModalTimeInputContent {
            id: input
            anchors.left: title.left
            anchors.right: title.right
            anchors.top: title.bottom
            anchors.topMargin: ScalingUtility.getScaledValue(Spacing.space4)
            timeFormat: container.timeFormat
        }

    }

    ModalBody {
        id: body
        readonly property int topPad: ScalingUtility.getScaledValue(Spacing.space6)
        readonly property int bottomPad: topPad
        anchors.top: header.bottom
        height: content.height

        Column{
            id: content
            spacing: ScalingUtility.getScaledValue(Spacing.space4)
            height: pad.height + spacing + timeFormatControl.height + body.topPad + body.bottomPad
            anchors {
                top: body.top
                left: body.left
                right: body.right
                topMargin: body.topPad
                leftMargin: ScalingUtility.getScaledValue(Spacing.space12)
                rightMargin: ScalingUtility.getScaledValue(Spacing.space12)
            }

            SegmentedControl{
                id: timeFormatControl

                height: ScalingUtility.getScaledValue(60)
                width: parent.width

                model: ListModel{
                    ListElement {
                        timeFormatLabel: "hh:mm"
                    }
                    ListElement {
                        timeFormatLabel: "mm:ss"
                    }
                }
                delegate: SegmentedControlItem{
                    width: timeFormatControl.delegateWidth
                    height: timeFormatControl.delegateHeight
                    selected: timeFormatLabel === container.timeFormat
                    showIcon: false
                    label: timeFormatLabel
                    onClicked: {
                        container.timeFormat = timeFormatLabel
                    }
                    onSelectedChanged: {
                        if(selected)
                        timeFormatControl.selectedIndex = index
                    }

                }

            }

            NumericKeyboard {
                id: pad
                anchors.horizontalCenter: parent.horizontalCenter
                size: NumericKeyboard.Size.Vertical
                showSigns: false

                onNumberClicked: (numberString) => input.addDigit(numberString)
            }
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
        button2Enabled: input.totalSecs !== 0 && !input.outOfRange

        showIcons: false

        onButton1Clicked: container.cancelClicked()

        onButton2Clicked: container.saveClicked()

    }
}
