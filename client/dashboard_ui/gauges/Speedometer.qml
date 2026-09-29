import QtQuick
import Dashboard.Ui 1.0

DashboardCard {
    id: root

    property color trackColor: DashboardColors.border
    property color progressColor: DashboardColors.accent
    property color tickColor: DashboardColors.borderStrong
    property color labelColor: DashboardColors.textSecondary
    property color valueColor: DashboardColors.textPrimary
    property real trackWidth: 12
    property real progressWidth: 8
    property int tickCount: 9
    property font chartFont: Qt.font({ family: DashboardTypography.family, pixelSize: DashboardTypography.caption })
    property font valueFont: Qt.font({ family: DashboardTypography.family, pixelSize: DashboardTypography.display * 2, bold: true })
    onTrackColorChanged: gauge.requestPaint()
    onProgressColorChanged: gauge.requestPaint()
    onTickColorChanged: gauge.requestPaint()
    onLabelColorChanged: gauge.requestPaint()
    onValueColorChanged: gauge.requestPaint()
    onTrackWidthChanged: gauge.requestPaint()
    onProgressWidthChanged: gauge.requestPaint()
    onTickCountChanged: gauge.requestPaint()
    onChartFontChanged: gauge.requestPaint()
    onValueFontChanged: gauge.requestPaint()

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
        readonly property real centerY: height * 0.62

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
            var cy = gauge.centerY
            var start = Math.PI * 0.78
            var end = Math.PI * 2.22
            var clamped = Math.max(0, Math.min(root.maxSpeed, root.speed))
            var progress = root.maxSpeed <= 0 ? 0 : clamped / root.maxSpeed

            ctx.strokeStyle = root.trackColor
            ctx.lineWidth = root.trackWidth
            ctx.beginPath()
            ctx.arc(cx, cy, r, start, end)
            ctx.stroke()

            ctx.strokeStyle = root.progressColor
            ctx.lineWidth = root.progressWidth
            ctx.beginPath()
            ctx.arc(cx, cy, r, start, start + (end - start) * progress)
            ctx.stroke()

            ctx.strokeStyle = root.tickColor
            ctx.lineWidth = 1
            ctx.fillStyle = root.labelColor
            ctx.font = root.chartFont.pixelSize + "px " + root.chartFont.family
            var ticks = Math.max(1, root.tickCount)
            for (var i = 0; i <= ticks; ++i) {
                var a = start + (end - start) * i / ticks
                var x0 = cx + Math.cos(a) * (r - 12)
                var y0 = cy + Math.sin(a) * (r - 12)
                var x1 = cx + Math.cos(a) * (r + 7)
                var y1 = cy + Math.sin(a) * (r + 7)
                ctx.beginPath()
                ctx.moveTo(x0, y0)
                ctx.lineTo(x1, y1)
                ctx.stroke()

                var label = Math.round(root.maxSpeed * i / ticks)
                var lx = cx + Math.cos(a) * (r - 32)
                var ly = cy + Math.sin(a) * (r - 32)
                ctx.fillText(label.toString(), lx - 9, ly + 4)
            }
        }
    }

    Text {
        id: speedLabel
        anchors.horizontalCenter: gauge.horizontalCenter
        y: gauge.y + gauge.centerY - height / 2
        text: Math.round(root.speed).toString()
        color: root.valueColor
        font: root.valueFont
    }

    Text {
        anchors.horizontalCenter: speedLabel.horizontalCenter
        anchors.top: speedLabel.bottom
        text: root.unit
        color: root.labelColor
        font: root.chartFont
    }
}
