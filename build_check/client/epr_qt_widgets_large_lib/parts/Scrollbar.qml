import QtQuick
import QtQuick.Controls.Basic
import "../"

ScrollBar {
    id: control
    orientation: Qt.Vertical

    contentItem: Rectangle {
        implicitWidth: ScalingUtility.getScaledValue(4)
        implicitHeight: ScalingUtility.getScaledValue(50)
        radius: width / 2
        color: "#bababa"

        opacity: 0.5
    }



}
