import QtQuick 2.15
import "../buttons"
import "../parts"
import "../"

Rectangle {
   id: container

   property alias showIconLeft: leftImage.visible
   property alias showIconRight: rightImage.visible

   property alias iconLeft: leftImage.defaultIcon
   property alias iconRight: rightImage.defaultIcon

   property alias iconLeftDisabledImage: leftImage.disabledIcon
   property alias iconRightDisabledImage: rightImage.disabledIcon

   property alias iconLeftEnabled: leftImage.enabled
   property alias iconRightEnabled: rightImage.enabled

   property alias label: navigationItem.label
   property alias labelIcon: navigationItem.icon
   property alias showLabelIcon: navigationItem.showIcon

   property int selectedIndex: -1

   signal rightIconClicked()
   signal leftIconClicked()

   width: ScalingUtility.getScaledValue(1024)
   height: ScalingUtility.getScaledValue(56)
   color: "transparent"

   IconButton {
       id: leftImage
       size: IconButton.Size.Large
       anchors.left: parent.left
       anchors.verticalCenter: parent.verticalCenter
       defaultIcon: "../images/caret_left.png"
       onClicked: leftIconClicked()
   }

   Rectangle {
       id: tabContainer
       anchors.verticalCenter: parent.verticalCenter
       color: parent.color
       height: parent.height
       anchors.left: leftImage.right
       anchors.right: rightImage.left

       TabbedNavigationItem {
           id: navigationItem
           size: TabbedNavigationItem.Size.Large
           anchors.centerIn: parent
           showIcon: false
           useSemibold: true
       }


   }

   IconButton {
       id: rightImage
       size: IconButton.Size.Large
       anchors.right: parent.right
       anchors.verticalCenter: parent.verticalCenter
       defaultIcon: "../images/save.png"
       onClicked: rightIconClicked()
   }



}
