import QtQuick
import Dashboard.Ui 1.0

DashboardCard {
    id: root

    property real vehicleProgress: 0.62
    property string routeInstruction: "400 m"
    property string routeDetail: "Turn left onto Correlia St."

    title: "Mappa"
    subtitle: routeDetail

    Canvas {
        id: mapCanvas
        anchors.fill: parent

        onWidthChanged: requestPaint()
        onHeightChanged: requestPaint()
        Component.onCompleted: requestPaint()

        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            ctx.clearRect(0, 0, width, height)

            ctx.fillStyle = DashboardColors.surfaceMuted
            ctx.fillRect(0, 0, width, height)

            ctx.strokeStyle = "#222b31"
            ctx.lineWidth = 10
            for (var gx = -40; gx < width + 80; gx += 54) {
                ctx.beginPath()
                ctx.moveTo(gx, 0)
                ctx.lineTo(gx + 22, height)
                ctx.stroke()
            }
            for (var gy = 36; gy < height; gy += 58) {
                ctx.beginPath()
                ctx.moveTo(0, gy)
                ctx.lineTo(width, gy - 16)
                ctx.stroke()
            }

            var pts = [
                { x: width * 0.2, y: height * 0.2 },
                { x: width * 0.48, y: height * 0.28 },
                { x: width * 0.5, y: height * 0.52 },
                { x: width * 0.7, y: height * 0.62 },
                { x: width * 0.74, y: height * 0.82 }
            ]

            ctx.strokeStyle = DashboardColors.accentMuted
            ctx.lineWidth = 16
            ctx.lineCap = "round"
            ctx.lineJoin = "round"
            ctx.beginPath()
            ctx.moveTo(pts[0].x, pts[0].y)
            for (var i = 1; i < pts.length; ++i) {
                ctx.lineTo(pts[i].x, pts[i].y)
            }
            ctx.stroke()

            ctx.strokeStyle = DashboardColors.accent
            ctx.lineWidth = 7
            ctx.beginPath()
            ctx.moveTo(pts[0].x, pts[0].y)
            for (var j = 1; j < pts.length; ++j) {
                ctx.lineTo(pts[j].x, pts[j].y)
            }
            ctx.stroke()

            var p = Math.max(0, Math.min(1, root.vehicleProgress))
            var segment = Math.min(pts.length - 2, Math.floor(p * (pts.length - 1)))
            var local = (p * (pts.length - 1)) - segment
            var a = pts[segment]
            var b = pts[segment + 1]
            var vx = a.x + (b.x - a.x) * local
            var vy = a.y + (b.y - a.y) * local

            ctx.fillStyle = DashboardColors.accent
            ctx.beginPath()
            ctx.arc(vx, vy, 13, 0, Math.PI * 2)
            ctx.fill()
            ctx.fillStyle = DashboardColors.background
            ctx.beginPath()
            ctx.moveTo(vx, vy - 7)
            ctx.lineTo(vx + 7, vy + 6)
            ctx.lineTo(vx - 7, vy + 6)
            ctx.closePath()
            ctx.fill()
        }
    }

    Rectangle {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: DashboardSpacing.md
        anchors.topMargin: DashboardSpacing.md
        width: Math.min(parent.width - DashboardSpacing.xl, 156)
        height: 48
        radius: DashboardSpacing.radiusSm
        color: "#cc1b2229"
        border.width: 1
        border.color: DashboardColors.border

        Column {
            anchors.fill: parent
            anchors.margins: DashboardSpacing.sm
            spacing: 1

            Text {
                width: parent.width
                text: root.routeInstruction
                color: DashboardColors.textPrimary
                font.family: DashboardTypography.family
                font.pixelSize: DashboardTypography.body
                font.bold: true
                elide: Text.ElideRight
            }

            Text {
                width: parent.width
                text: root.routeDetail
                color: DashboardColors.textSecondary
                font.family: DashboardTypography.family
                font.pixelSize: DashboardTypography.tiny
                elide: Text.ElideRight
            }
        }
    }
}
