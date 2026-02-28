import QtQuick 2.15
import "../spacing"
import "../fonts"
import "../colors"
import "../"

Rectangle {
    id: container

    property bool selected: false
    property alias showIcon: image.visible
    property url icon: "../images/favorite_white.png"
    property url selectedIcon: "../images/favorite_selected.png"

    property alias showLabel: label.visible
    property alias label: labelMetric.text

    readonly property int leftPad: ScalingUtility.getScaledValue(Spacing.space6)
    readonly property int rightPad: leftPad

    readonly property real maxTextWidth: container.width - leftPad - rightPad - (image.visible ? (content.spacing + image.width) : 0)

    signal clicked()

    width: parent.width
    height: parent.height
    radius: ScalingUtility.getScaledValue(Spacing.space2)
    color: "transparent"


    Row {
        id: content
        anchors.centerIn: parent

        spacing: ScalingUtility.getScaledValue(Spacing.space2)

        Image {
            id: image
            width: ScalingUtility.getScaledValue(32)
            height: width
            visible: container.showIcon
            anchors.verticalCenter: parent.verticalCenter
            asynchronous: true
            source: selected ? selectedIcon : icon
        }

        Text {
            id: label
            anchors.verticalCenter: parent.verticalCenter
            wrapMode: Text.Wrap
            text: labelMetric.elidedText
            font: selected ? FontStyle.lSemibold : FontStyle.lRegular
            lineHeight: FontStyle.lLineHeight
            lineHeightMode: Text.FixedHeight
            color: selected ? ColorSemantic.contentSelected : ColorSemantic.contentDefault

            TextMetrics {
                id: labelMetric
                font: selected ? FontStyle.lSemibold : FontStyle.lRegular
                elide: Text.ElideRight
                elideWidth: maxTextWidth
                text: "Label"
            }
        }

    }


    MouseArea {
        anchors.fill: parent

        onClicked: container.clicked()
    }

}
