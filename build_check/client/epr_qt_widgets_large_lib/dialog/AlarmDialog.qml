import QtQuick 2.15
import QtQuick.Controls
import "../parts"
import "../spacing"
import "../colors"
import "../fonts"
import "../"

Item {
    id:root

    height: Math.min(maxHeigth, header.height + scrollBar.contentHeight + scrollBar.anchors.topMargin + scrollBar.anchors.bottomMargin)

    property int maxHeigth: ScalingUtility.getScaledValue(800)

    property alias titleShowIcon: title.showIcon
    property alias titleIcon: title.icon
    property alias titleMessage: title.message
    property alias titleHeader: title.header
    property alias titleShowMetadata: title.showMetadata
    property alias titleMetadata: title.metadata

    property alias contactAlarmText: textContact.text
    property alias phoneAlarmText: textPhone.text
    property alias messageAlarmText: messageAlarm.text
    property alias showImageContact: imageContact.visible
    property alias imageContact: imageContact.source

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
            icon: "../images/alarm_fill.png"
            showMetadata: true

            header: "Error code"
            message: "Error name"
            metadata: "Date and time"
        }
    }

    CustomRoundedRectangle{
        id: body

        anchors.top: header.bottom
        anchors.topMargin: -1
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        roundTopLeft: false
        roundTopRight: false
        radius: Spacing.space2
        backgroundColor: ColorSemantic.modalPopupBodyBackground
        borderColor: ColorSemantic.strokeBorder
        borderWidth: 1

        Flickable{
            id: scrollBar
            clip:true
            contentHeight: textColumn.height
            boundsBehavior: Flickable.StopAtBounds
            ScrollBar.vertical: Scrollbar{
                visible: scrollBar.contentHeight > scrollBar.height
            }

            anchors{
                left: parent.left
                leftMargin: ScalingUtility.getScaledValue(Spacing.space12)
                right: parent.right
                rightMargin: ScalingUtility.getScaledValue(Spacing.space3)
                top: parent.top
                topMargin: ScalingUtility.getScaledValue(Spacing.space6)
                bottom: parent.bottom
                bottomMargin: ScalingUtility.getScaledValue(Spacing.space6)
            }

            Column{
                id: textColumn
                spacing: ScalingUtility.getScaledValue(Spacing.space6)
                anchors{
                    left: parent.left
                    right: parent.right
                    rightMargin: ScalingUtility.getScaledValue(36)
                }

                Text{
                    id: messageAlarm
                    width: parent.width
                    font: FontStyle.lRegular
                    lineHeight: FontStyle.lLineHeight
                    lineHeightMode: Text.FixedHeight
                    color: ColorSemantic.contentDefault
                    wrapMode: Text.Wrap
                    text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
                }

                Row{
                    id: rowContact
                    spacing: ScalingUtility.getScaledValue(Spacing.space3)
                    anchors{
                        left: parent.left
                        right: parent.right
                    }
                    Image{
                        id: imageContact
                        source: "../images/phone.png"
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Column{
                        width: parent.width - imageContact.width
                        Text{
                            id:textContact
                            width: parent.width
                            font: FontStyle.mRegular
                            lineHeight: FontStyle.mLineHeigth
                            lineHeightMode: Text.FixedHeight
                            color: ColorSemantic.contentDefault
                            text: "Call the tecnical service"
                            wrapMode: Text.Wrap
                            maximumLineCount: 1
                            elide: Text.ElideRight

                        }
                        Text{
                            id:textPhone
                            width: parent.width
                            font: FontStyle.mRegular
                            lineHeight: FontStyle.mLineHeigth
                            lineHeightMode: Text.FixedHeight
                            color: ColorSemantic.contentDefault
                            text: "0039 4256 666858"
                            wrapMode: Text.Wrap
                            maximumLineCount: 1
                            elide: Text.ElideRight

                        }
                    }
                }
            }
        }
    }
}
