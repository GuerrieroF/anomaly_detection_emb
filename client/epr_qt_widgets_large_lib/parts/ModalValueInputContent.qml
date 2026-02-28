import QtQuick
import ".."
import "../buttons"
import "../fonts"
import "../colors"
import "../spacing"

Item {
    id: container

    property int value: 50
    property int minValue: 0
    property int maxValue: 100

    property alias unit: textUnit.text
    property alias showUnit: textUnit.visible
    property alias showCancelButton: keyboardDelete.visible

    property string message: minValue + (showUom ? uom : "") + " - " + maxValue + (showUom ? uom : "")
    property string errorMessage: message
    property color textColor: outOfRange ? ColorSemantic.contentDanger : ColorSemantic.contentDefault

    property bool autoAdjust: true
    property alias adjustInterval: normalizer.interval

    readonly property int maxDigits: Math.max(Math.abs(minValue).toString().length, Math.abs(maxValue).toString().length)
    property string displayValue: value.toString()

    property int consecutiveDigits: Math.abs(value).toString().length
    readonly property bool outOfRange: Number(displayValue) < minValue ||  Number(displayValue) > maxValue

    property bool firstTimeTyping: true

    height: ScalingUtility.getScaledValue(88)

    function addDigit(number) {
        if(firstTimeTyping){
            deleteAllDigit();
            firstTimeTyping = false
        }

        if (maxDigits > 1 && consecutiveDigits >= maxDigits)
            return

        if (displayValue === "0" || maxDigits === 1)
        {
            displayValue = number
            consecutiveDigits = 1
        }
        else
        {
            displayValue += number
            consecutiveDigits++
        }
        restartNormalizerTimer()
    }

    function removeLastDigit() {
        if (displayValue === "")
            return
        if (displayValue.length === 2 && displayValue.startsWith("-"))
        {
            displayValue = ""
            consecutiveDigits = 0
        }
        else
        {
            displayValue = displayValue.substring(0, displayValue.length-1);
            consecutiveDigits--
            restartNormalizerTimer()
        }
    }

    function normalize() {
        if (outOfRange) {
            displayValue = (Number(displayValue) < minValue) ? minValue.toString() : maxValue.toString()
            consecutiveDigits = Math.abs(displayValue).toString().length
         }
    }

    function startNormalizerTimer() {
        if(autoAdjust)
            normalizer.start()
    }

    function stopNormalizerTimer() {
        if(normalizer.running)
            normalizer.stop()
    }

    function restartNormalizerTimer() {
        if (autoAdjust && outOfRange && normalizer.running)
            normalizer.restart()
    }

    function addSign(sign) {
        if (displayValue.startsWith(sign) || displayValue.length === 0)
            return
        else if (sign === "+")
            displayValue = Math.abs(Number(displayValue)).toString()
        else
            displayValue = (-Math.abs(Number(displayValue))).toString()

        restartNormalizerTimer()
    }
    function deleteAllDigit(){
        if(displayValue.length > 0){
            displayValue = ""
            consecutiveDigits = 0
        }
    }

    onOutOfRangeChanged: {
        outOfRange ? startNormalizerTimer() : stopNormalizerTimer()
    }

    Timer {
        id: normalizer
        interval: 2000
        onTriggered: normalize()
    }

    IconButton {
        id: keyboardDelete

        anchors.top: parent.top
        anchors.right: parent.right
        size: IconButton.Size.Large
        defaultIcon: "../images/kbdDeleteLarge.png"
        visible: maxDigits > 1
        enabled: visible
        onClicked: removeLastDigit()
    }

    Item {
        id: inputValueItem
        width: ScalingUtility.getScaledValue(285)
        height: ScalingUtility.getScaledValue(88)
        anchors.bottom: parent.bottom
        anchors.bottomMargin:  ScalingUtility.getScaledValue(23)
        anchors.horizontalCenter: container.horizontalCenter

        Row {
            height: inputValueItem.height
            anchors.horizontalCenter: parent.horizontalCenter

            Text {
                id: textValue
                horizontalAlignment: Text.AlignRight

                anchors.verticalCenter: parent.verticalCenter
                text: container.displayValue + " "
                font: FontStyle.xxlRegular
                color: textColor
            }
            Text {
                id: textUnit
                text: "unit"
                font: FontStyle.xlRegular
                color: textColor
                anchors.baseline: textValue.baseline
                horizontalAlignment: Text.AlignRight
            }
        }
    }

    Text {
        id: messageText
        anchors.top: parent.top
        anchors.topMargin: ScalingUtility.getScaledValue(64)
        anchors.horizontalCenter: parent.horizontalCenter
        text: outOfRange ? errorMessage : message
        font: FontStyle.mRegular
        color: textColor

    }

}
