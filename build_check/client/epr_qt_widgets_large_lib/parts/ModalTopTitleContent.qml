import QtQuick 2.15
import "../spacing"
import "../fonts"
import "../colors"
import "../"

Item {
    id: container

    property alias message: messageText.text

    property alias showIcon: icon.visible
    property alias icon: icon.source

    property alias header: header.text
    property alias showHeader: header.visible

    property alias metadata: metadata.text
    property alias showMetadata: metadata.visible

    height: messageColumn.height

    Column {
        id: messageColumn

        width: parent.width

        spacing: ScalingUtility.getScaledValue(Spacing.space2)

        // Row {
        //     id: headerRow
        //     anchors.left: parent.left
        //     anchors.right: parent.right
        //     //visible: container.showHeader || container.showMetadata

            Item {
                width: parent.width
                height: container.showHeader ? header.height : 0
                Text {
                    id: header
                    text: "Heading"
                    anchors.left: parent.left
                    anchors.right: metadata.visible ? metadata.left : parent.right
                    anchors.verticalCenter: parent.verticalCenter

                    font: FontStyle.mRegular
                    lineHeight: FontStyle.mLineHeigth
                    lineHeightMode: Text.FixedHeight
                    color: ColorSemantic.contentDefault
                    wrapMode: Text.Wrap
                    elide: Text.ElideRight
                    maximumLineCount: 1

                }

                Text {
                    id: metadata
                    text: "Metadata"
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter

                    font: FontStyle.mRegular
                    lineHeight: FontStyle.mLineHeigth
                    lineHeightMode: Text.FixedHeight
                    color: ColorSemantic.contentDefault
                    wrapMode: Text.Wrap
                    elide: Text.ElideRight
                    maximumLineCount: 1
                }
            }
        // }

        Row {
            id: titleRow
            spacing: ScalingUtility.getScaledValue(Spacing.space3)

            Image {
                id: icon
                width: ScalingUtility.getScaledValue(32)
                height: width
                asynchronous: true
                source: "../images/favorite_white.png"
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                id: messageText
                anchors.verticalCenter: parent.verticalCenter

                width: messageColumn.width - icon.visible *(icon.width + parent.spacing) - parent.spacing - messageColumn.leftPadding - messageColumn.rightPadding
                text: "Title of the message"

                font: FontStyle.lSemibold
                lineHeight: FontStyle.lLineHeight
                lineHeightMode: Text.FixedHeight

                color: ColorSemantic.contentDefault

                wrapMode: Text.Wrap
                elide: Text.ElideRight
                maximumLineCount: 1
            }
        }
    }
}
