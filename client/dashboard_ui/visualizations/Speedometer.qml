import QtQuick
import Dashboard.Ui 1.0

DashboardCard {
    id: root

    property real speed: 0
    property real maxSpeed: 180
    property string unit: "km/h"

    title: "Tachimetro"
    subtitle: "velocita veicolo"

    onSpeedChanged: gauge.requestPaint()
    onMaxSpeedChanged: gauge.requestPaint()

    Canvas {
        id: gauge
        anchors.fill: parent

        onWidthChanged: requestPaint()
        onHeightChanged: requestPaint()
        Component.onCompleted: requestPaint()

        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            ctx.clearRect(0, 0, width, height)

            var size = Math.min(width, height) * 0.9
            var r = size * 0.42
            var cx = width / 2
            var cy = height * 0.62
            var start = Math.PI * 0.78
            var end = Math.PI * 2.22
            var clamped = Math.max(0, Math.min(root.maxSpeed, root.speed))
            var progress = root.maxSpeed <= 0 ? 0 : clamped / root.maxSpeed

            ctx.strokeStyle = DashboardColors.border
            ctx.lineWidth = 12
            ctx.beginPath()
            ctx.arc(cx, cy, r, start, end)
            ctx.stroke()

            ctx.strokeStyle = DashboardColors.accent
            ctx.lineWidth = 8
            ctx.beginPath()
            ctx.arc(cx, cy, r, start, start + (end - start) * progress)
            ctx.stroke()

            ctx.strokeStyle = DashboardColors.borderStrong
            ctx.lineWidth = 1
            ctx.fillStyle = DashboardColors.textSecondary
            ctx.font = DashboardTypography.caption + "px " + DashboardTypography.family
            for (var i = 0; i <= 9; ++i) {
                var a = start + (end - start) * i / 9
                var x0 = cx + Math.cos(a) * (r - 12)
                var y0 = cy + Math.sin(a) * (r - 12)
                var x1 = cx + Math.cos(a) * (r + 7)
                var y1 = cy + Math.sin(a) * (r + 7)
                ctx.beginPath()
                ctx.moveTo(x0, y0)
                ctx.lineTo(x1, y1)
                ctx.stroke()

                var label = Math.round(root.maxSpeed * i / 9)
                var lx = cx + Math.cos(a) * (r - 32)
                var ly = cy + Math.sin(a) * (r - 32)
                ctx.fillText(label.toString(), lx - 9, ly + 4)
            }
        }
    }

    Column {
        anchors.centerIn: parent
        spacing: 0

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: Math.round(root.speed).toString()
            color: DashboardColors.textPrimary
            font.family: DashboardTypography.family
            font.pixelSize: DashboardTypography.display
            font.bold: true
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: root.unit
            color: DashboardColors.textSecondary
            font.family: DashboardTypography.family
            font.pixelSize: DashboardTypography.caption
        }
    }
}
