import QtQuick 2.15
import "../spacing"
import "../fonts"
import "../colors"
import "../"

Rectangle {
    id: container

    enum Size {
        Small,
        Large
    }

    property int size: TabbedNavigationItem.Size.Small

    property bool selected: false
    property alias showIcon: image.visible
    property alias label: label.text
    property url icon: "../images/favorite_white.png"
    property url selectedIcon: "../images/favorite_selected.png"

    property bool useSemibold: false

    readonly property bool isSmall: container.size === TabbedNavigationItem.Size.Small

    signal clicked()

    width: content.width
    height: parent.height
    color: "transparent"

    Rectangle {
        id: borderBottom
        visible: selected

        anchors.bottom: parent.bottom

        height: ScalingUtility.getScaledValue(4)
        width: parent.width
        color: ColorSemantic.strokeActive
    }


    Row {
        id: content
        anchors.verticalCenter: parent.verticalCenter

        spacing: ScalingUtility.getScaledValue(Spacing.space2)

        Image {
            id: image
            asynchronous: true
            source: selected ? selectedIcon : icon
            anchors.verticalCenter: parent.verticalCenter

        }

        Text {
            id: label
            anchors.verticalCenter: parent.verticalCenter

            text: "Label"

            font: isSmall ? (selected || useSemibold ? FontStyle.sSemibold : FontStyle.sRegular) : (selected || useSemibold ? FontStyle.lSemibold : FontStyle.lRegular)
            lineHeight: isSmall ? FontStyle.sLineHeigth : FontStyle.lLineHeight
            lineHeightMode: Text.FixedHeight

            color: selected ? ColorSemantic.contentSelected : ColorSemantic.contentDefault
        }

    }

    MouseArea {
        anchors.fill: parent

        onClicked: container.clicked()
    }

}
