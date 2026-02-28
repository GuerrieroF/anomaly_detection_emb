import QtQuick 2.15
import "../buttons"
import "../parts"
import "../spacing"
import "../"

Rectangle {
    id: container

    property alias label: navigationItem.label
    property alias labelIcon: navigationItem.icon
    property alias showLabelIcon: navigationItem.showIcon

    width: ScalingUtility.getScaledValue(1024)
    height: ScalingUtility.getScaledValue(56)
    color: "transparent"

    Row {
        anchors.left: parent.left
        rightPadding: ScalingUtility.getScaledValue(Spacing.space3)
        anchors.fill: parent
        clip: true
        TabbedNavigationItem {
            id: navigationItem
            size: TabbedNavigationItem.Size.Large
            showIcon: false
            useSemibold: true
        }

    }

}
