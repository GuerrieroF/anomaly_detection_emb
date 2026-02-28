import QtQuick 2.15
import QtQuick.Controls
import "../parts"
import "../spacing"
import "../colors"
import "../fonts"
import "../"

Item {
    id: root

    height: Math.min(root.maxHeigth, header.height + scrollBar.contentHeight + scrollBar.anchors.topMargin + scrollBar.anchors.bottomMargin + bottom.height)

    property int maxHeigth: ScalingUtility.getScaledValue(800)

    property alias titleShowIcon: title.showIcon
    property alias titleIcon: title.icon
    property alias titleMessage: title.message
    property alias titleHeader: title.header
    property alias titleShowMetadata: title.showMetadata
    property alias titleMetadata: title.metadata

    signal buttonClicked()

    ModalHeader{
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

            showIcon: true
            icon: "../images/warning_fill.png"
            showMetadata: true

            header: "Error code"
            message: "Error name"
            metadata: "Date and time"
        }
    }

    ModalBody{
        id:body
        anchors{
            top: header.bottom
            left: parent.left
            right: parent.right
            bottom: bottom.top
        }

        Flickable{
            id: scrollBar
            clip:true
            contentHeight: messageAlarm.height
            boundsBehavior: Flickable.StopAtBounds

            ScrollBar.vertical: Scrollbar{
                visible: (scrollBar.height < scrollBar.contentHeight)
            }

            anchors{
                fill: parent
                leftMargin: ScalingUtility.getScaledValue(Spacing.space12)
                rightMargin: ScalingUtility.getScaledValue(Spacing.space3)
                topMargin: ScalingUtility.getScaledValue(Spacing.space6)
                bottomMargin: ScalingUtility.getScaledValue(Spacing.space6)
            }

            Text{
                id: messageAlarm
                width: parent.width
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.rightMargin: ScalingUtility.getScaledValue(36)
                font: FontStyle.lRegular
                lineHeight: FontStyle.lLineHeight
                lineHeightMode: Text.FixedHeight
                color: ColorSemantic.contentDefault
                wrapMode: Text.Wrap
                text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
            }
        }
    }
    ModalBottomSingleButton{
        id: bottom
        anchors.bottom: parent.bottom
        onButtonClicked: root.buttonClicked()
    }

}
