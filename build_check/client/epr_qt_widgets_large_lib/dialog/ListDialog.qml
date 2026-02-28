import QtQuick 2.15
import QtQuick.Controls
import "../parts"
import "../spacing"
import "../colors"
import "../fonts"
import "../"

Item {
    id: container


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

    property alias listModel: list.model
    property alias listDelegate: list.delegate
    readonly property alias listWidth: list.width
    property bool showScrollbar: true

    property bool headerVisible: false
    property string heaederLabel: ""

    property int maxHeigth: ScalingUtility.getScaledValue(800)

    signal cancelClicked()
    signal saveClicked()

    height: Math.min(maxHeigth, header.height + list.contentHeight + list.anchors.topMargin + list.anchors.bottomMargin + bottom.height)

    ModalHeader {
        id: header
        width: parent.width
        height: title.height + topPad + bottomPad

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
    }

    ModalBody {
        id: body
        anchors{
            top: header.bottom
            left: parent.left
            right: parent.right
            bottom: bottom.top
        }

        ListView{
            id:list

            property string heatherLabel: "Heather heather"

            header: (headerVisible) ? headerComponent : null

            anchors{
                fill: parent
                topMargin: ScalingUtility.getScaledValue(Spacing.space6)
                leftMargin: ScalingUtility.getScaledValue(Spacing.space12)
                rightMargin:ScalingUtility.getScaledValue(Spacing.space3)
                bottomMargin: anchors.topMargin
            }


            spacing: ScalingUtility.getScaledValue(Spacing.space2)
            clip: true
            boundsBehavior: ListView.StopAtBounds

            ScrollBar.vertical: Scrollbar {
                id: scrollbar
                visible: container.showScrollbar && (list.contentHeight > body.height)
            }
        }
    }


    ModalBottomDoubleButton {
        id: bottom
        anchors{
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        height: ScalingUtility.getScaledValue(70)

        label1: "Cancel"
        label1Color: button1Enabled ? ColorSemantic.buttonSecondaryContentDefault : ColorSemantic.buttonSecondaryContentDisabled

        label2: "Apply"
        label2Color: ColorSemantic.buttonPrimaryContentDefault
        label2Font: FontStyle.lSemibold
        button2Color: button2Enabled ? ColorSemantic.buttonPrimaryBackgroundDefault : ColorSemantic.buttonPrimaryBackgroundDisabled

        showIcons: false

        onButton1Clicked: container.cancelClicked()
        onButton2Clicked: container.saveClicked()

    }

    Component{
        id:headerComponent

        Rectangle{

            height: textLabel.height + ScalingUtility.getScaledValue(Spacing.space6)
            color: "transparent"
            anchors.left: parent.left
            anchors.rightMargin: ScalingUtility.getScaledValue(36)
            anchors.right: parent.right

            Text{
                id: textLabel
                text: container.heaederLabel
                width: parent.width
                color: ColorSemantic.contentDefault
                font: FontStyle.lRegular
                wrapMode: Text.Wrap
                lineHeight: FontStyle.lLineHeight
                lineHeightMode: Text.FixedHeight
            }
        }
    }
}
