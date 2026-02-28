import QtQuick
import "../"
import "../spacing"
import "../buttons"
import "../fonts"
import "../colors"

Item {
    id: container

    property int initialTime: 0
    property int maxTimeInSeconds: 24 * 3600
    property int minTimeInSeconds: 0

    property string timeString: "0000"
    property string maxTimeString: formatTime(maxTimeInSeconds, timeFormat).replace(":","")
    property string minTimeString: formatTime(minTimeInSeconds, timeFormat).replace(":","")
    property alias adjustInterval: adjustTimer.interval
    property bool autoAdjust: true
    property string timeFormat: "hh:mm"
    property bool userChanged: false

    readonly property bool isHoursFormat: timeFormat === "hh:mm"

    readonly property string hoursMinutes: timeString.substring(0,2)
    readonly property string minutesSeconds: timeString.substring(2,4)

    readonly property string space: " "

    readonly property int consecutiveInput: timeString.replace(/^0+/, "").length

    readonly property color textColor: outOfRange ? ColorSemantic.contentDanger : ColorSemantic.contentDefault

    readonly property int totalSecs: Number(container.hoursMinutes) * (isHoursFormat ? 3600 : 60)  + Number(container.minutesSeconds) * (isHoursFormat ? 60 : 1)

    readonly property bool outOfRange: totalSecs > maxTimeInSeconds || totalSecs < minTimeInSeconds


    width: parent.width
    height: ScalingUtility.getScaledValue(Spacing.space12)

    signal deleteClicked()

    function formatTime(seconds, format) {

        var baseDate = new Date(1970, 0, 1);
        baseDate.setSeconds(seconds);

        if (format.startsWith("hh")) {
            var h = Math.floor(seconds / 3600);
            return padNumber(h, 2) + Qt.formatTime(baseDate, format.replace("hh", ""))
        }

        return Qt.formatTime(baseDate, format)
    }

    function padNumber(num, length) {
        var r = "" + num;
        while (r.length < length) {
            r = "0" + r;
        }
        return r;
    }

    function normalizeTime() {

        var first = Number(container.hoursMinutes)
        var second = Number(container.minutesSeconds)
        if (second > 59) {
            first++
            second = second % 60
        }

        if (first > 99)
            first = 99

        timeString = padNumber(first,2) + padNumber(second,2)
    }

    function removeLastDigit() {
        var res = timeString.substring(0, timeString.length-1)
        timeString = "0" + res
        container.userChanged = true
        if (autoAdjust && outOfRange && adjustTimer.running)
            adjustTimer.restart()
    }

    function addDigit(number) {

        if (container.userChanged === false) {
            timeString = "000" + number
            container.userChanged = true
        }
        else{
            var res = timeString.substring(1)
            timeString = res + number
        }

        if (autoAdjust && outOfRange && adjustTimer.running)
            adjustTimer.restart()
    }

    function getTimeInSecs() {
        return totalSecs
    }

    onOutOfRangeChanged: {
        if (autoAdjust)
            outOfRange ? adjustTimer.start() : adjustTimer.stop()
    }

    Component.onCompleted: {
        container.timeString = formatTime(initialTime, timeFormat).replace(":","")
        container.userChanged = false
    }

    Timer {
        id: adjustTimer
        interval: 2000
        onTriggered: {
            if (totalSecs < minTimeInSeconds)
                timeString = minTimeString
            else if (totalSecs > maxTimeInSeconds)
                initialTime = maxTimeString
        }
    }

    IconButton {
        id: keyboardDelete

        anchors.top: parent.top
        anchors.right: parent.right
        size: IconButton.Size.Large
        defaultIcon: "../images/kbdDeleteLarge.png"
        anchors.verticalCenter: parent.verticalCenter

        onClicked: container.removeLastDigit()
    }

    Row {
        id: inputValueItem
        height: ScalingUtility.getScaledValue(42)
        anchors.top: container.top
        anchors.horizontalCenter: container.horizontalCenter

        Text {
            id: hoursMinutes
            horizontalAlignment: Text.AlignRight

            anchors.verticalCenter: parent.verticalCenter
            text: container.hoursMinutes
            font: FontStyle.xxlRegular
            color: textColor
        }
        Text {
            id: hoursMinutesText
            horizontalAlignment: Text.AlignRight

            anchors.baseline: hoursMinutes.baseline
            text: isHoursFormat ? "h" : "m"
            font: FontStyle.xlRegular
            color: textColor
        }

        Text {
            id: minutesSeconds
            horizontalAlignment: Text.AlignRight

            anchors.verticalCenter: parent.verticalCenter
            text: container.space + container.minutesSeconds
            font: FontStyle.xxlRegular
            color: textColor
        }
        Text {
            id: minutesSecondsText
            horizontalAlignment: Text.AlignRight

            anchors.baseline: minutesSeconds.baseline
            text: isHoursFormat ? "m" : "s"
            font: FontStyle.xlRegular
            color: textColor
        }
    }
}
