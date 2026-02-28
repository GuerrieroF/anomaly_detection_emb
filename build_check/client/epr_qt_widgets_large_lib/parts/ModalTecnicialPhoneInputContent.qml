import QtQuick 2.15
import ".."
import "../buttons"
import "../fonts"
import "../colors"
import "../spacing"

Item {
    id:container
    property string phoneNumber: "";
    property string hintText: "Insert phone number"
    property int maxDigit: 9
    property bool firstTimeTyping: true

    height: ScalingUtility.getScaledValue(48)

    function addDigit(number) {
        if(firstTimeTyping){
            deleteAllDigit();
            firstTimeTyping = false
        }
        if(phoneNumber.length < maxDigit)
            phoneNumber += number
    }

    function removeLastDigit() {
        if (phoneNumber === "")
            return
        else if (phoneNumber.length === 1)
            phoneNumber =  ""
        else
           phoneNumber =  phoneNumber.substring(0,phoneNumber.length-1)
    }


    function deleteAllDigit(){
        if(phoneNumber.length > 0){
            phoneNumber = ""
        }
    }

    IconButton {
        id: keyboardDelete
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        size: IconButton.Size.Large
        defaultIcon: "../images/kbdDeleteLarge.png"
        visible: phoneNumber.length > 0
        enabled: visible
        onClicked: removeLastDigit()
    }

    Item {
        id: inputValueItem
        width: (keyboardDelete.visible) ? ScalingUtility.getScaledValue(571) : ScalingUtility.getScaledValue(512)
        height: ScalingUtility.getScaledValue(Spacing.space12)
        anchors.top: parent.top
        anchors.bottomMargin:  ScalingUtility.getScaledValue(23)
        anchors.horizontalCenter: container.horizontalCenter

        TextInput {
            id: textValue
            width: inputValueItem.width
            horizontalAlignment: Text.AlignHCenter
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            text: (phoneNumber.length > 0) ? phoneNumber : hintText
            font: (phoneNumber.length > 0) ? FontStyle.xlRegular : FontStyle.lSemibold
            color: ColorSemantic.contentDefault
            activeFocusOnPress: false
            clip: true
        }
    }
}
