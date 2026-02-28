import QtQuick
import "../"
import "../spacing"
import "../fonts"
import "../colors"

Rectangle {
   id: root

   property alias label: label.text

   width: parent.width
   height: ScalingUtility.getScaledValue(Spacing.space16)

   color: ColorSemantic.layerVariant1BackgroundDefault

   Text {
       id: label
       text: "Header"
       width: parent.width
       leftPadding: ScalingUtility.getScaledValue(Spacing.space6)
       rightPadding: leftPadding
       anchors.verticalCenter: parent.verticalCenter

       color: ColorSemantic.contentDefault

       font: FontStyle.sSemibold
       lineHeight: FontStyle.sLineHeigth
       lineHeightMode: Text.FixedHeight
       wrapMode: Text.Wrap
       elide: Text.ElideRight
       maximumLineCount: 1
   }
}
