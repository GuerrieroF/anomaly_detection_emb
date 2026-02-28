import QtQuick
import "../colors"

Rectangle {
    id: container

    width: parent.width
    height: parent.height


    color: ColorSemantic.modalPopupBodyBackground

    Rectangle {
        id: leftLineMargin

        width: 1
        height: container.height
        anchors.left: parent.left

        color: ColorSemantic.strokeBorder
    }

    Rectangle {
        id: rightLineMargin

        width: 1
        height: container.height
        anchors.right: parent.right

        color: ColorSemantic.strokeBorder
    }
}
