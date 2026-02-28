import QtQuick 2.15
import "../"
import "../colors"

Rectangle {
    id:root
    width: ScalingUtility.getScaledValue(32)
    height: root.width
    color:"transparent"


    property bool checked: false

    readonly property color colorCircles: (root.checked) ? ColorSemantic.contentSelected : ColorSemantic.contentDefault


    Rectangle{
        id:bigCircle
        anchors.centerIn: parent
        width: ScalingUtility.getScaledValue(22)
        height: bigCircle.width
        radius: bigCircle.width/2
        border.width: ScalingUtility.getScaledValue(2)
        border.color: colorCircles
        color:"transparent"


        Rectangle{
            id:smallCircle
            width: ScalingUtility.getScaledValue(14)
            height: smallCircle.width
            radius: smallCircle.width/2
            anchors.centerIn: parent
            border.width: smallCircle.width/2
            border.color: colorCircles
            color:"transparent"
            visible: root.checked


        }

    }

}
