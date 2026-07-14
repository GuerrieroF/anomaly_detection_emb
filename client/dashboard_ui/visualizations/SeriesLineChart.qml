import QtQuick
import Dashboard.Ui 1.0

DashboardCard {
    id: root

    property var history: []
    property real currentValue: 0
    property real minValue: -2
    property real maxValue: 2
    property string unit: "g"
    property color lineColor: DashboardColors.cyan

    onHistoryChanged: chartCanvas.requestPaint()
    onCurrentValueChanged: chartCanvas.requestPaint()
    onMinValueChanged: chartCanvas.requestPaint()
    onMaxValueChanged: chartCanvas.requestPaint()

    Canvas {
        id: chartCanvas
        anchors.fill: parent

        onWidthChanged: requestPaint()
        onHeightChanged: requestPaint()
        Component.onCompleted: requestPaint()

        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            ctx.clearRect(0, 0, width, height)

            var left = 32
            var right = 8
            var top = 10
            var bottom = 20
            var plotW = Math.max(1, width - left - right)
            var plotH = Math.max(1, height - top - bottom)
            var range = Math.max(0.1, root.maxValue - root.minValue)

            ctx.strokeStyle = DashboardColors.border
            ctx.lineWidth = 1
            for (var i = 0; i <= 4; ++i) {
                var y = top + (plotH / 4) * i
                ctx.beginPath()
                ctx.moveTo(left, y)
                ctx.lineTo(width - right, y)
                ctx.stroke()
            }

            ctx.fillStyle = DashboardColors.textMuted
            ctx.font = DashboardTypography.caption + "px " + DashboardTypography.family
            ctx.fillText(root.maxValue.toFixed(0) + root.unit, 2, top + 9)
            ctx.fillText("0", 10, top + plotH / 2 + 4)
            ctx.fillText(root.minValue.toFixed(0) + root.unit, 2, top + plotH)

            var values = root.history && root.history.length > 0 ? root.history : [root.currentValue]
            ctx.strokeStyle = root.lineColor
            ctx.lineWidth = 2
            ctx.beginPath()
            for (var j = 0; j < values.length; ++j) {
                var x = left + (values.length === 1 ? plotW : (j / (values.length - 1)) * plotW)
                var v = Math.max(root.minValue, Math.min(root.maxValue, values[j]))
                var yv = top + (root.maxValue - v) / range * plotH
                if (j === 0) {
                    ctx.moveTo(x, yv)
                } else {
                    ctx.lineTo(x, yv)
                }
            }
            ctx.stroke()
        }
    }

    Text {
        anchors.right: parent.right
        anchors.rightMargin: DashboardSpacing.sm
        anchors.top: parent.top
        anchors.topMargin: DashboardSpacing.xs
        text: root.currentValue.toFixed(2) + " " + root.unit
        color: root.lineColor
        font.family: DashboardTypography.family
        font.pixelSize: DashboardTypography.body
        font.bold: true
    }
}
