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
    color: selected ? ColorSemantic.layerVariant1BackgroundDefault : "transparent"

    property bool selected: false

    property alias icon: icon.source
    property alias label: label.text

    signal clicked()

    Row{

        id:rowItem
        height: parent.height
        spacing: ScalingUtility.getScaledValue(Spacing.space4)

        anchors{
            left: parent.left
            right: parent.right
        }
        leftPadding: ScalingUtility.getScaledValue(Spacing.space6)
        rightPadding: leftPadding
        topPadding: ScalingUtility.getScaledValue(Spacing.space4)
        bottomPadding: topPadding

        Image{
            id: icon
            source: "../images/lang_EnglishUK.png"
            height: ScalingUtility.getScaledValue(Spacing.space12)
            width: icon.heigth
            anchors.verticalCenter: parent.verticalCenter
        }

        Text{
            id: label
            text: "Language"
            width: rowItem.width - icon.width - rowItem.spacing - rowItem.leftPadding - rowItem.rightPadding
            color: ColorSemantic.contentDefault
            font: FontStyle.lRegular
            anchors.verticalCenter: parent.verticalCenter
            wrapMode: Text.Wrap
            elide: Text.ElideRight
            maximumLineCount: 1
        }

    }

    MouseArea{
        anchors.fill: parent
        onClicked: {
            root.clicked()
        }
    }

}
