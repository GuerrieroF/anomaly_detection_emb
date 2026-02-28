import QtQuick 2.15
import ".."
import "../buttons"
import "../fonts"
import "../colors"
import "../spacing"

Item {

    id:container

    readonly property color textColor: isWrongPassword ? ColorSemantic.contentDanger : ColorSemantic.contentDefault
    property string passwordString: ""
    property bool isWrongPassword: false
    property string hintText: "Insert PIN code"
    height: ScalingUtility.getScaledValue(48)

    function addDigit(number) {
            passwordString += number
    }

    function removeLastDigit() {
        if (passwordString === "")
            return
        if (passwordString.length === 1)
        {
            isWrongPassword = false
            passwordString =  ""
        }
        else
        {
           passwordString =  passwordString.substring(0,passwordString.length-1)

        }
    }


    IconButton {
        id: keyboardDelete
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter

        size: IconButton.Size.Large
        defaultIcon: "../images/kbdDeleteLarge.png"
        visible: passwordString.length > 0
        enabled: visible
        onClicked: removeLastDigit()
    }

    Item {
        id: inputValueItem
        width: (keyboardDelete.visible) ? ScalingUtility.getScaledValue(368) : ScalingUtility.getScaledValue(512)
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
            text: (passwordString.length > 0) ? passwordString : hintText
            font: FontStyle.lSemibold
            color: textColor
            activeFocusOnPress:false
            passwordCharacter: "•"
            echoMode: (passwordString.length > 0) ? TextInput.Password : TextInput.Normal
            clip: true
        }
    }
}
