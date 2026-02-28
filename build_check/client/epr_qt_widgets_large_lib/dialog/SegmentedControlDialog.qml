import QtQuick
import "../parts"
import "../spacing"
import "../colors"
import "../fonts"
import "../segmentedControls"
import "../"

Item {
    id: container

    property alias title: title.header
    property alias showTitle: title.showHeader
    property alias message: title.message
    property alias messageIcon: title.icon
    property alias showMessageIcon: title.showIcon

    property alias model: segmentedControl.model
    property alias delegate: segmentedControl.delegate
    property int count: segmentedControl.count

    // this value must always be set correctly to ensure correct animation of the selection mask
    property alias selectedIndex: segmentedControl.selectedIndex

    property alias animationEnabled: segmentedControl.animationEnabled
    property alias animationDuration: segmentedControl.animationDuration
    property alias animationType: segmentedControl.animationType
    property alias selectedColor: segmentedControl.selectedColor


    readonly property real delegateWidth: segmentedControl.width / segmentedControl.count
    readonly property real delegateHeight: segmentedControl.height

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
        height: segmentedControl.height + (body.padding * 2)

        readonly property int padding: ScalingUtility.getScaledValue(Spacing.space12)

        SegmentedControl{
            id: segmentedControl
            height: ScalingUtility.getScaledValue(60)
            width: parent.width - (body.padding * 2)
            anchors.centerIn: parent
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
