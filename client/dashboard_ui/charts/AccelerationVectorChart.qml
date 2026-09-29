import QtQuick
import Dashboard.Ui 1.0

DashboardCard {
    id: root

    property color gridColor: DashboardColors.border
    property color axisColor: DashboardColors.borderStrong
    property color labelColor: DashboardColors.textMuted
    property color historyColor: DashboardColors.textSecondary
    property color pointColor: DashboardColors.danger
    property real pointRadius: 8
    property int ringCount: 4
    property string topLabel: "ACC"
    property string bottomLabel: "BRAKE"
    property string leftLabel: "LEFT"
    property string rightLabel: "RIGHT"
    property font chartFont: Qt.font({ family: DashboardTypography.family, pixelSize: DashboardTypography.caption })
    onGridColorChanged: vectorCanvas.requestPaint()
    onAxisColorChanged: vectorCanvas.requestPaint()
    onLabelColorChanged: vectorCanvas.requestPaint()
    onHistoryColorChanged: vectorCanvas.requestPaint()
    onPointColorChanged: vectorCanvas.requestPaint()
    onPointRadiusChanged: vectorCanvas.requestPaint()
    onRingCountChanged: vectorCanvas.requestPaint()
    onTopLabelChanged: vectorCanvas.requestPaint()
    onBottomLabelChanged: vectorCanvas.requestPaint()
    onLeftLabelChanged: vectorCanvas.requestPaint()
    onRightLabelChanged: vectorCanvas.requestPaint()
    onChartFontChanged: vectorCanvas.requestPaint()

    property var history: []
    property real xValue: 0
    property real yValue: 0
    property real range: 2

    title: "Accelerazioni"
    subtitle: "laterale / longitudinale"

    onHistoryChanged: vectorCanvas.requestPaint()
    onXValueChanged: vectorCanvas.requestPaint()
    onYValueChanged: vectorCanvas.requestPaint()
    onRangeChanged: vectorCanvas.requestPaint()

    Canvas {
        id: vectorCanvas
        anchors.fill: parent

        onWidthChanged: requestPaint()
        onHeightChanged: requestPaint()
        Component.onCompleted: requestPaint()

        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            ctx.clearRect(0, 0, width, height)

            var size = Math.min(width, height) * 0.86
            var r = size / 2
            var cx = width / 2
            var cy = height / 2

            ctx.strokeStyle = root.gridColor
            ctx.lineWidth = 1
            var rings = Math.max(1, root.ringCount)
            var scale = Math.max(0.001, root.range)
            for (var i = 1; i <= rings; ++i) {
                ctx.beginPath()
                ctx.arc(cx, cy, r * i / rings, 0, Math.PI * 2)
                ctx.stroke()
            }

            ctx.strokeStyle = root.axisColor
            ctx.beginPath()
            ctx.moveTo(cx - r, cy)
            ctx.lineTo(cx + r, cy)
            ctx.moveTo(cx, cy - r)
            ctx.lineTo(cx, cy + r)
            ctx.stroke()

            ctx.fillStyle = root.labelColor
            ctx.font = root.chartFont.pixelSize + "px " + root.chartFont.family
            ctx.textAlign = "center"
            ctx.fillText(root.topLabel, cx, cy - r + 12)
            ctx.fillText(root.bottomLabel, cx, cy + r - 4)
            ctx.textAlign = "left"
            ctx.fillText(root.leftLabel, cx - r + 4, cy - 6)
            ctx.textAlign = "right"
            ctx.fillText(root.rightLabel, cx + r - 4, cy - 6)

            if (root.history && root.history.length > 1) {
                ctx.strokeStyle = root.historyColor
                ctx.lineWidth = 1
                ctx.beginPath()
                for (var j = 0; j < root.history.length; ++j) {
                    var pt = root.history[j]
                    var px = cx + Math.max(-scale, Math.min(scale, pt.x)) / scale * r
                    var py = cy - Math.max(-scale, Math.min(scale, pt.y)) / scale * r
                    if (j === 0) {
                        ctx.moveTo(px, py)
                    } else {
                        ctx.lineTo(px, py)
                    }
                }
                ctx.stroke()
            }

            var dx = cx + Math.max(-scale, Math.min(scale, root.xValue)) / scale * r
            var dy = cy - Math.max(-scale, Math.min(scale, root.yValue)) / scale * r
            ctx.fillStyle = root.pointColor
            ctx.beginPath()
            ctx.arc(dx, dy, Math.max(0, root.pointRadius), 0, Math.PI * 2)
            ctx.fill()
        }
    }
}
