import QtQuick 2.15
import "../spacing"
import "../"

Rectangle {
    id: container

    enum Size {
        Small,
        Large
    }

    property int size: TabbedNavigation.Size.Small
    readonly property bool isSmall: container.size === TabbedNavigation.Size.Small

    property alias model: tabbedItemRepeater.model
    property alias delegate: tabbedItemRepeater.delegate

    property int selectedIndex: -1

    width: parent.width
    height: parent.height
    color: "transparent"

    Row {
        id: content
        anchors.horizontalCenter: parent.horizontalCenter

        height: parent.height

        spacing: ScalingUtility.getScaledValue(isSmall ? 56 : Spacing.space16)

        Repeater {
            id: tabbedItemRepeater
        }
    }
}
