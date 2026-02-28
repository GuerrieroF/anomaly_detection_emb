import QtQuick
import QtQuick.Controls
import "../colors"
import "../spacing"
import "../"
import "../fonts"

Rectangle {

    id: root
    height: ScalingUtility.getScaledValue(76)
    width: parent.width
    radius: ScalingUtility.getScaledValue(Spacing.space2)
    color:  ColorSemantic.layerVariant1BackgroundDefault


    property bool checked: false
    property string checkedIcon: "../images/checkbox_active.png"
    property string uncheckedIcon: "../images/checkbox.png"

    property alias labelText: label.text

    signal clicked()

    Row{
        id:rowItem

        height: parent.height
        spacing: ScalingUtility.getScaledValue(Spacing.space8)

        anchors{
            left: parent.left
            right: parent.right
        }

        leftPadding: ScalingUtility.getScaledValue(Spacing.space6)
        rightPadding: rowItem.leftPadding
        topPadding: ScalingUtility.getScaledValue(Spacing.space4)
        bottomPadding: rowItem.topPadding

        Text{
            id: label
            text: "Label"
            width: rowItem.width - rowItem.spacing - rowItem.leftPadding - rowItem.rightPadding - icon.width
            color: ColorSemantic.contentDefault
            font: FontStyle.lRegular
            anchors.verticalCenter: parent.verticalCenter
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.Wrap
            elide: Text.ElideRight
            maximumLineCount: 1
        }

        Image{
            id: icon
            height: ScalingUtility.getScaledValue(32)
            width: icon.heigth
            anchors.verticalCenter: parent.verticalCenter
            source: root.checked ? checkedIcon : uncheckedIcon
        }

    }

    MouseArea{
        anchors.fill: parent
        onClicked: {
            root.clicked()
        }
    }

}
