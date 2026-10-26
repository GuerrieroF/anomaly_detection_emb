import QtQuick
import Dashboard.Ui 1.0

Item {
    id: root

    implicitWidth: 180
    implicitHeight: 52
    Accessible.role: Accessible.Graphic
    Accessible.name: qsTr("Anomaly Detection · Rilevamento anomalie stradali")

    Canvas {
        id: symbol
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width
        height: Math.max(0, parent.height - title.implicitHeight - 4)
        onWidthChanged: requestPaint()
        onHeightChanged: requestPaint()
        Connections {
            target: DashboardColors
            function onAccentChanged() { symbol.requestPaint() }
            function onWarningChanged() { symbol.requestPaint() }
        }
        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            ctx.clearRect(0, 0, width, height)
            var points = [[0, 65], [70, 65], [100, 50], [125, 80],
                          [150, 65], [235, 65], [255, 10], [280, 115],
                          [305, 43], [330, 65], [390, 65], [415, 55],
                          [440, 73], [460, 65], [520, 65]]
            var scaleX = (width - 4) / 520
            var scaleY = (height - 4) / 125
            ctx.strokeStyle = DashboardColors.accent
            ctx.lineWidth = 2.5
            ctx.lineJoin = "round"
            ctx.lineCap = "round"
            ctx.beginPath()
            for (var i = 0; i < points.length; ++i) {
                var x = 2 + points[i][0] * scaleX
                var y = 2 + points[i][1] * scaleY
                if (i === 0) ctx.moveTo(x, y)
                else ctx.lineTo(x, y)
            }
            ctx.stroke()
            ctx.beginPath()
            ctx.arc(2 + 255 * scaleX, 2 + 10 * scaleY, 3.5, 0, Math.PI * 2)
            ctx.fillStyle = DashboardColors.warning
            ctx.fill()
        }
    }

    Text {
        id: title
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        text: "ANOMALY DETECTION"
        color: DashboardColors.textPrimary
        font.family: DashboardTypography.family
        font.pixelSize: 13
        font.bold: true
        font.letterSpacing: 0.6
    }
}
