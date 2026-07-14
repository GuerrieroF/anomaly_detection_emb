import QtQuick
import Dashboard.Ui 1.0

DashboardCard {
    id: root

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

            ctx.strokeStyle = DashboardColors.border
            ctx.lineWidth = 1
            for (var i = 1; i <= 4; ++i) {
                ctx.beginPath()
                ctx.arc(cx, cy, r * i / 4, 0, Math.PI * 2)
                ctx.stroke()
            }

            ctx.strokeStyle = DashboardColors.borderStrong
            ctx.beginPath()
            ctx.moveTo(cx - r, cy)
            ctx.lineTo(cx + r, cy)
            ctx.moveTo(cx, cy - r)
            ctx.lineTo(cx, cy + r)
            ctx.stroke()

            ctx.fillStyle = DashboardColors.textMuted
            ctx.font = DashboardTypography.caption + "px " + DashboardTypography.family
            ctx.fillText("ACC", cx - 12, cy - r + 12)
            ctx.fillText("BRAKE", cx - 20, cy + r - 4)
            ctx.fillText("LEFT", cx - r + 4, cy - 6)
            ctx.fillText("RIGHT", cx + r - 40, cy - 6)

            if (root.history && root.history.length > 1) {
                ctx.strokeStyle = "#9fb4c8"
                ctx.lineWidth = 1
                ctx.beginPath()
                for (var j = 0; j < root.history.length; ++j) {
                    var pt = root.history[j]
                    var px = cx + Math.max(-root.range, Math.min(root.range, pt.x)) / root.range * r
                    var py = cy - Math.max(-root.range, Math.min(root.range, pt.y)) / root.range * r
                    if (j === 0) {
                        ctx.moveTo(px, py)
                    } else {
                        ctx.lineTo(px, py)
                    }
                }
                ctx.stroke()
            }

            var dx = cx + Math.max(-root.range, Math.min(root.range, root.xValue)) / root.range * r
            var dy = cy - Math.max(-root.range, Math.min(root.range, root.yValue)) / root.range * r
            ctx.fillStyle = DashboardColors.danger
            ctx.beginPath()
            ctx.arc(dx, dy, 8, 0, Math.PI * 2)
            ctx.fill()
        }
    }
}
