import QtQuick 2.15

Item {
    id: root
    width: parent.width
    height: parent.height

    property color backgroundColor: "white"
    property color borderColor: "transparent"

    property int borderWidth: 0

    property int radius: 0

    property bool roundTopLeft: true
    property bool roundTopRight: true
    property bool roundBottomLeft: true
    property bool roundBottomRight: true

    // Main rectangle
    Rectangle {
        width: parent.width
        height: parent.height
        color: backgroundColor
        border.color: borderColor
        border.width: borderWidth
        radius: root.radius

        //TopLeftCorner rectangle
        Rectangle {
            width: root.radius
            height: width

            visible: !roundTopLeft

            anchors.top: parent.top
            anchors.left: parent.left

            color: root.backgroundColor

            Rectangle {
                height: parent.height
                width: 1
                color: borderColor
                anchors.left: parent.left

            }
            Rectangle {
                height: 1
                width: parent.width
                color: borderColor
                anchors.top: parent.top
            }
        }

        //TopRightCorner rectangle
        Rectangle {
            width: root.radius
            height: width

            visible: !roundTopRight

            anchors.top: parent.top
            anchors.right: parent.right

            color: root.backgroundColor

            Rectangle {
                height: parent.height
                width: 1
                color: borderColor
                anchors.right: parent.right

            }
            Rectangle {
                height: 1
                width: parent.width
                color: borderColor
                anchors.top: parent.top
            }
        }

        //BottomRightCorner rectangle
        Rectangle {
            width: root.radius
            height: width

            visible: !roundBottomRight

            anchors.bottom: parent.bottom
            anchors.right: parent.right

            color: root.backgroundColor

            Rectangle {
                height: parent.height
                width: 1
                color: borderColor
                anchors.right: parent.right

            }
            Rectangle {
                height: 1
                width: parent.width
                color: borderColor
                anchors.bottom: parent.bottom
            }
        }

        //BottomLeftCorner rectangle
        Rectangle {
            width: root.radius
            height: width

            visible: !roundBottomLeft

            anchors.bottom: parent.bottom
            anchors.left: parent.left

            color: root.backgroundColor

            Rectangle {
                height: parent.height
                width: 1
                color: borderColor
                anchors.left: parent.left

            }
            Rectangle {
                height: 1
                width: parent.width
                color: borderColor
                anchors.bottom: parent.bottom
            }
        }
    }
}
