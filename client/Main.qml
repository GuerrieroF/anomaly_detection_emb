import QtQuick
import QtQuick.Window
import QtQuick.Controls 2.15
import QtQuick.Controls.Material
import epr_qt_widgets_large_lib 1.0
import DBusExample.io
//import DBasExample.io

Window {
    width: Screen.width
    height: Screen.height
    visible: true
    title: qsTr("Hello World")



    Rectangle {
        id:root
        anchors.fill: parent
        color: "#172155"

        Row{
            anchors.top: parent.top
            anchors.topMargin: 50
            anchors.left: parent.left
            anchors.leftMargin: 50
            anchors.right: parent.left
            anchors.rightMargin: 50
            width: parent
            spacing: 20

            ButtonCentralLarge {
                showIcon: false

                onClicked: {
                    resultText.text = DBusClient.fetchMessage()
                }
            }

            Text {
                id: resultText
                text: "Premi il bottone"
            }
        }
    }
}
