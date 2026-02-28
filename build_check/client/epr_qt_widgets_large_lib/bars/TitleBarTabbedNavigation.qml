import QtQuick 2.15
import "../buttons"
import "../tabs"
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

   property alias tabModel: navigationTab.model
   property alias tabModelDelegate: navigationTab.delegate

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

       TabbedNavigation {
           id: navigationTab
           width: parent.width
           size: TabbedNavigation.Size.Large
           anchors.centerIn: parent
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
