import QtQuick
import Dashboard.Ui 1.0

Canvas {
    id: root

    property string name: "home"
    property color strokeColor: DashboardColors.textPrimary
    property color fillColor: "transparent"
    property real strokeWidth: 2

    implicitWidth: 22
    implicitHeight: 22

    onNameChanged: requestPaint()
    onStrokeColorChanged: requestPaint()
    onFillColorChanged: requestPaint()
    onStrokeWidthChanged: requestPaint()
    onWidthChanged: requestPaint()
    onHeightChanged: requestPaint()

    onPaint: {
        var ctx = getContext("2d")
        ctx.reset()
        ctx.clearRect(0, 0, width, height)
        ctx.strokeStyle = strokeColor
        ctx.fillStyle = fillColor
        ctx.lineWidth = strokeWidth
        ctx.lineCap = "round"
        ctx.lineJoin = "round"

        var w = width
        var h = height
        var cx = w / 2
        var cy = h / 2

        if (name === "home") {
            ctx.beginPath()
            ctx.moveTo(w * 0.18, h * 0.48)
            ctx.lineTo(cx, h * 0.18)
            ctx.lineTo(w * 0.82, h * 0.48)
            ctx.stroke()
            ctx.beginPath()
            ctx.rect(w * 0.28, h * 0.46, w * 0.44, h * 0.34)
            ctx.stroke()
            return
        }

        if (name === "map") {
            ctx.beginPath()
            ctx.moveTo(w * 0.2, h * 0.22)
            ctx.lineTo(w * 0.38, h * 0.16)
            ctx.lineTo(w * 0.62, h * 0.24)
            ctx.lineTo(w * 0.8, h * 0.18)
            ctx.lineTo(w * 0.8, h * 0.78)
            ctx.lineTo(w * 0.62, h * 0.84)
            ctx.lineTo(w * 0.38, h * 0.76)
            ctx.lineTo(w * 0.2, h * 0.82)
            ctx.closePath()
            ctx.stroke()
            ctx.beginPath()
            ctx.moveTo(w * 0.38, h * 0.16)
            ctx.lineTo(w * 0.38, h * 0.76)
            ctx.moveTo(w * 0.62, h * 0.24)
            ctx.lineTo(w * 0.62, h * 0.84)
            ctx.stroke()
            return
        }

        if (name === "charts") {
            ctx.beginPath()
            ctx.moveTo(w * 0.16, h * 0.76)
            ctx.lineTo(w * 0.84, h * 0.76)
            ctx.stroke()
            ctx.beginPath()
            ctx.moveTo(w * 0.22, h * 0.68)
            ctx.lineTo(w * 0.36, h * 0.46)
            ctx.lineTo(w * 0.52, h * 0.56)
            ctx.lineTo(w * 0.72, h * 0.28)
            ctx.stroke()
            return
        }

        if (name === "speed") {
            ctx.beginPath()
            ctx.arc(cx, cy + h * 0.12, w * 0.32, Math.PI * 0.9, Math.PI * 2.1)
            ctx.stroke()
            ctx.beginPath()
            ctx.moveTo(cx, cy + h * 0.12)
            ctx.lineTo(w * 0.68, h * 0.38)
            ctx.stroke()
            return
        }

        if (name === "settings") {
            ctx.beginPath()
            ctx.arc(cx, cy, w * 0.2, 0, Math.PI * 2)
            ctx.stroke()
            for (var i = 0; i < 8; ++i) {
                var a = (Math.PI * 2 / 8) * i
                ctx.beginPath()
                ctx.moveTo(cx + Math.cos(a) * w * 0.31, cy + Math.sin(a) * h * 0.31)
                ctx.lineTo(cx + Math.cos(a) * w * 0.4, cy + Math.sin(a) * h * 0.4)
                ctx.stroke()
            }
            return
        }

        ctx.beginPath()
        ctx.arc(cx, cy, w * 0.28, 0, Math.PI * 2)
        ctx.stroke()
    }
}
