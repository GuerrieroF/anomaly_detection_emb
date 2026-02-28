import QtQuick 2.15
import "../spacing"
import "../colors"
import "../"

Rectangle {
    id: container

    property alias model: segmentedItemRepeater.model
    property alias delegate: segmentedItemRepeater.delegate
    property int count: segmentedItemRepeater.count

    // this value must always be set correctly to ensure correct animation of the selection mask
    property int selectedIndex: -1

    property bool animationEnabled: true
    property int animationDuration: 200
    property int animationType: Easing.OutQuad
    property alias selectedColor: selectionMask.color


    readonly property real delegateWidth: width / segmentedItemRepeater.count
    readonly property real delegateHeight: height


    width: parent.width
    height: parent.height
    color: ColorSemantic.pillBackgroundDefault
    radius: ScalingUtility.getScaledValue(Spacing.space2)

    Rectangle {
        id:selectionMask
        width: delegateWidth
        height: delegateHeight
        radius: 8
        color: ColorSemantic.pillBackgroundActive
        anchors.left: content.left
        anchors.leftMargin: delegateWidth * selectedIndex
        Behavior on anchors.leftMargin {
            enabled: container.animationEnabled
            NumberAnimation {
                duration: 200
                easing.type: animationType
            }
        }
    }

    Row {
        id: content
        width: parent.width

        spacing: 0

        Repeater {
            id: segmentedItemRepeater
        }
    }
}
