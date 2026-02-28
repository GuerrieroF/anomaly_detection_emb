import QtQuick 2.15
import "../spacing"
import "../fonts"
import "../colors"
import "../"

Rectangle {
    id: container

    property alias time: timeText.text
    property alias date: dateText.text

    height: ScalingUtility.getScaledValue(44)
    width: ScalingUtility.getScaledValue(95)

    color: "transparent"

    Text {
        id: timeText
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        height: ScalingUtility.getScaledValue(21)
        text: "10:40"
        font: FontStyle.xsSemibold
        lineHeight: FontStyle.xsLineHeigth
        lineHeightMode: Text.FixedHeight
        color: ColorSemantic.contentDefault
    }

    Text {
        id: dateText
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        text: "Mon, 22 November 2023"
        font: FontStyle.xsRegular
        lineHeight: FontStyle.xsLineHeigth
        lineHeightMode: Text.FixedHeight
        color: ColorSemantic.contentDefault
    }
}
