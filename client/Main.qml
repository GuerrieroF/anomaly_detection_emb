import QtQuick
import QtQuick.Window
import QtQuick.Controls 2.15
import QtQuick.Controls.Material
import epr_qt_widgets_large_lib 1.0
import DBusExample.io

Window {
    width: 1024
    height: 600
    visible: true
    title: qsTr("Anomaly Dashboard")

    Rectangle {
        id: root
        anchors.fill: parent
        color: "#090c12"
        property real gRange: 4.0
        property real xyDisplayRange: 2.0
        property real zDisplayRange: 2.0
        property var accelHistory: []
        property var accelZHistory: []
        property real maxAccelForward: 0
        property real maxBrake: 0
        property real maxLeft: 0
        property real maxRight: 0
        property real maxZPlus: 0
        property real maxZMinus: 0

        function resetMaxima() {
            maxAccelForward = 0
            maxBrake = 0
            maxLeft = 0
            maxRight = 0
            maxZPlus = 0
            maxZMinus = 0
        }

        function updateHistory() {
            var ax = Math.max(-gRange, Math.min(gRange, DBusClient.linearAccelXg))
            var ay = Math.max(-gRange, Math.min(gRange, DBusClient.linearAccelYg))
            var az = Math.max(-gRange, Math.min(gRange, DBusClient.linearAccelZg))
            accelHistory.push({x: ay, y: -ax})
            accelZHistory.push(az)
            if (accelHistory.length > 180) {
                accelHistory.shift()
            }
            if (accelZHistory.length > 180) {
                accelZHistory.shift()
            }
            maxAccelForward = Math.max(maxAccelForward, Math.max(0, ax))
            maxBrake = Math.max(maxBrake, Math.max(0, -ax))
            maxLeft = Math.max(maxLeft, Math.max(0, ay))
            maxRight = Math.max(maxRight, Math.max(0, -ay))
            maxZPlus = Math.max(maxZPlus, Math.max(0, az))
            maxZMinus = Math.max(maxZMinus, Math.max(0, -az))
            accelCanvas.requestPaint()
            zAccelCanvas.requestPaint()
            tiltXCanvas.requestPaint()
            tiltYCanvas.requestPaint()
            tiltZCanvas.requestPaint()
        }

        Connections {
            target: DBusClient
            function onImuDataChanged() { root.updateHistory() }
        }

        Row {
            anchors.fill: parent
            anchors.margins: 24
            spacing: 24

            Rectangle {
                id: accelPanel
                width: parent.width * 0.62
                height: parent.height
                radius: 18
                color: "#0f1523"
                border.width: 1
                border.color: "#2c3443"

                Button {
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.leftMargin: 14
                    anchors.topMargin: 12
                    text: "CALIBRATE"
                    onClicked: root.resetMaxima()
                }

                Canvas {
                    id: accelCanvas
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: 16
                    width: Math.min(parent.width * 0.84, parent.height * 0.62)
                    height: width

                    onPaint: {
                        var ctx = getContext("2d")
                        ctx.reset()
                        var cx = width / 2
                        var cy = height / 2
                        var r = width * 0.46

                        ctx.strokeStyle = "#ffffff"
                        ctx.lineWidth = 2
                        ctx.beginPath()
                        ctx.arc(cx, cy, r, 0, Math.PI * 2)
                        ctx.stroke()

                        ctx.strokeStyle = "#d6dae2"
                        ctx.lineWidth = 1.2
                        ctx.setLineDash([6, 5])
                        for (var i = 1; i <= 3; ++i) {
                            var rr = r * (i * 0.25)
                            ctx.beginPath()
                            ctx.arc(cx, cy, rr, 0, Math.PI * 2)
                            ctx.stroke()
                        }
                        ctx.setLineDash([])

                        ctx.strokeStyle = "#d6dae2"
                        ctx.beginPath()
                        ctx.moveTo(cx - r, cy)
                        ctx.lineTo(cx + r, cy)
                        ctx.moveTo(cx, cy - r)
                        ctx.lineTo(cx, cy + r)
                        ctx.stroke()

                        ctx.fillStyle = "#ffffff"
                        ctx.font = "12px sans-serif"
                        ctx.fillText("LEFT", cx - r + 8, cy - 8)
                        ctx.fillText("RIGHT", cx + r - 42, cy - 8)
                        ctx.fillText("ACC", cx - 12, cy - r + 18)
                        ctx.fillText("BRAKE", cx - 18, cy + r - 8)

                        if (root.accelHistory.length > 1) {
                            ctx.strokeStyle = "#a8b0c1"
                            ctx.lineWidth = 1
                            ctx.beginPath()
                            for (var j = 0; j < root.accelHistory.length; ++j) {
                                var pt = root.accelHistory[j]
                                var sx = Math.max(-root.xyDisplayRange, Math.min(root.xyDisplayRange, pt.x))
                                var sy = Math.max(-root.xyDisplayRange, Math.min(root.xyDisplayRange, pt.y))
                                var px = cx + (sx / root.xyDisplayRange) * r
                                var py = cy + (sy / root.xyDisplayRange) * r
                                if (j === 0) {
                                    ctx.moveTo(px, py)
                                } else {
                                    ctx.lineTo(px, py)
                                }
                            }
                            ctx.stroke()
                        }

                        var dotAy = Math.max(-root.xyDisplayRange, Math.min(root.xyDisplayRange, DBusClient.linearAccelYg))
                        var dotAx = Math.max(-root.xyDisplayRange, Math.min(root.xyDisplayRange, DBusClient.linearAccelXg))
                        var dotX = cx + (dotAy / root.xyDisplayRange) * r
                        var dotY = cy + (-dotAx / root.xyDisplayRange) * r
                        ctx.fillStyle = "#ff4d57"
                        ctx.beginPath()
                        ctx.arc(dotX, dotY, 8, 0, Math.PI * 2)
                        ctx.fill()
                    }
                }

                Rectangle {
                    id: zPanel
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.leftMargin: 14
                    anchors.rightMargin: 14
                    anchors.top: accelCanvas.bottom
                    anchors.topMargin: 10
                    height: 112
                    radius: 12
                    color: "#0b1120"
                    border.width: 1
                    border.color: "#2c3443"

                    Text {
                        anchors.left: parent.left
                        anchors.leftMargin: 12
                        anchors.top: parent.top
                        anchors.topMargin: 8
                        text: "ACC Z (LINEARE)"
                        color: "#d6dae2"
                        font.pixelSize: 11
                        font.bold: true
                    }

                    Canvas {
                        id: zAccelCanvas
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.margins: 10
                        anchors.topMargin: 30

                        onPaint: {
                            var ctx = getContext("2d")
                            ctx.reset()

                            ctx.strokeStyle = "#41506a"
                            ctx.lineWidth = 1
                            for (var gy = -2; gy <= 2; gy += 1) {
                                var gyPos = (height / 2) - (gy / root.zDisplayRange) * (height * 0.44)
                                ctx.beginPath()
                                ctx.moveTo(0, gyPos)
                                ctx.lineTo(width, gyPos)
                                ctx.stroke()
                            }

                            ctx.fillStyle = "#8a94a8"
                            ctx.font = "11px sans-serif"
                            ctx.fillText("+2g", 4, (height / 2) - (height * 0.44) + 11)
                            ctx.fillText("0", 4, (height / 2) + 4)
                            ctx.fillText("-2g", 4, (height / 2) + (height * 0.44))

                            if (root.accelZHistory.length > 1) {
                                ctx.strokeStyle = "#52b6ff"
                                ctx.lineWidth = 2
                                ctx.beginPath()
                                for (var i = 0; i < root.accelZHistory.length; ++i) {
                                    var x = (i / (root.accelZHistory.length - 1)) * width
                                    var zDisplay = Math.max(-root.zDisplayRange, Math.min(root.zDisplayRange, root.accelZHistory[i]))
                                    var y = (height / 2) - (zDisplay / root.zDisplayRange) * (height * 0.44)
                                    if (i === 0) {
                                        ctx.moveTo(x, y)
                                    } else {
                                        ctx.lineTo(x, y)
                                    }
                                }
                                ctx.stroke()
                            }
                        }
                    }
                }

                Rectangle {
                    id: maximaPanel
                    anchors.left: zPanel.left
                    anchors.right: zPanel.right
                    anchors.top: zPanel.bottom
                    anchors.topMargin: 8
                    height: 50
                    radius: 12
                    color: "#0b1120"
                    border.width: 1
                    border.color: "#2c3443"

                    Grid {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.leftMargin: 12
                        anchors.rightMargin: 12
                        anchors.topMargin: 8
                        columns: 3
                        rowSpacing: 4
                        columnSpacing: 20

                        Text { width: (parent.width - (parent.columns - 1) * parent.columnSpacing) / parent.columns; text: "ACC MAX G: " + root.maxAccelForward.toFixed(2); color: "#d6dae2"; font.pixelSize: 11; font.bold: true }
                        Text { width: (parent.width - (parent.columns - 1) * parent.columnSpacing) / parent.columns; text: "BRAKE MAX G: " + root.maxBrake.toFixed(2); color: "#d6dae2"; font.pixelSize: 11; font.bold: true }
                        Text { width: (parent.width - (parent.columns - 1) * parent.columnSpacing) / parent.columns; text: "LEFT MAX G: " + root.maxLeft.toFixed(2); color: "#d6dae2"; font.pixelSize: 11; font.bold: true }
                        Text { width: (parent.width - (parent.columns - 1) * parent.columnSpacing) / parent.columns; text: "RIGHT MAX G: " + root.maxRight.toFixed(2); color: "#d6dae2"; font.pixelSize: 11; font.bold: true }
                        Text { width: (parent.width - (parent.columns - 1) * parent.columnSpacing) / parent.columns; text: "ACC MAX Z +: " + root.maxZPlus.toFixed(2); color: "#d6dae2"; font.pixelSize: 11; font.bold: true }
                        Text { width: (parent.width - (parent.columns - 1) * parent.columnSpacing) / parent.columns; text: "ACC MAX Z -: " + root.maxZMinus.toFixed(2); color: "#d6dae2"; font.pixelSize: 11; font.bold: true }
                    }

                }
            }

            Rectangle {
                id: tiltPanel
                width: parent.width - accelPanel.width - parent.spacing
                height: parent.height
                radius: 18
                color: "#111726"
                border.width: 1
                border.color: "#2c3443"

                Column {
                    anchors.fill: parent
                    anchors.margins: 18
                    spacing: 14

                    Text {
                        text: "INCLINAZIONE ASSI"
                        color: "#ffffff"
                        font.pixelSize: 24
                        font.bold: true
                    }

                    Text {
                        text: DBusClient.serverAvailable ? "Server online" : "Server offline"
                        color: DBusClient.serverAvailable ? "#12B76A" : "#F04438"
                        font.pixelSize: 16
                        font.bold: true
                    }

                    Rectangle {
                        width: parent.width
                        height: (parent.height - 90) / 3
                        radius: 12
                        color: "#0b1120"
                        border.width: 1
                        border.color: "#2c3443"

                        Text {
                            anchors.left: parent.left
                            anchors.leftMargin: 12
                            anchors.top: parent.top
                            anchors.topMargin: 8
                            text: "ASSE X (ROLL): " + DBusClient.tiltXDeg.toFixed(1) + "°"
                            color: "#d6dae2"
                            font.pixelSize: 14
                            font.bold: true
                        }

                        Canvas {
                            id: tiltXCanvas
                            anchors.fill: parent
                            anchors.margins: 10
                            anchors.topMargin: 34
                            onPaint: {
                                var ctx = getContext("2d")
                                ctx.reset()
                                var centerY = height / 2
                                var x0 = 8
                                var x1 = width - 8
                                var value = Math.max(-90, Math.min(90, DBusClient.tiltXDeg))
                                var px = x0 + ((value + 90) / 180) * (x1 - x0)

                                ctx.strokeStyle = "#5f6f88"
                                ctx.lineWidth = 3
                                ctx.beginPath()
                                ctx.moveTo(x0, centerY)
                                ctx.lineTo(x1, centerY)
                                ctx.stroke()

                                ctx.fillStyle = "#ff6d4d"
                                ctx.beginPath()
                                ctx.arc(px, centerY, 8, 0, Math.PI * 2)
                                ctx.fill()
                            }
                        }
                    }

                    Rectangle {
                        width: parent.width
                        height: (parent.height - 90) / 3
                        radius: 12
                        color: "#0b1120"
                        border.width: 1
                        border.color: "#2c3443"

                        Text {
                            anchors.left: parent.left
                            anchors.leftMargin: 12
                            anchors.top: parent.top
                            anchors.topMargin: 8
                            text: "ASSE Y (PITCH): " + DBusClient.tiltYDeg.toFixed(1) + "°"
                            color: "#d6dae2"
                            font.pixelSize: 14
                            font.bold: true
                        }

                        Canvas {
                            id: tiltYCanvas
                            anchors.fill: parent
                            anchors.margins: 10
                            anchors.topMargin: 34
                            onPaint: {
                                var ctx = getContext("2d")
                                ctx.reset()
                                var centerY = height / 2
                                var x0 = 8
                                var x1 = width - 8
                                var value = Math.max(-90, Math.min(90, DBusClient.tiltYDeg))
                                var px = x0 + ((value + 90) / 180) * (x1 - x0)

                                ctx.strokeStyle = "#5f6f88"
                                ctx.lineWidth = 3
                                ctx.beginPath()
                                ctx.moveTo(x0, centerY)
                                ctx.lineTo(x1, centerY)
                                ctx.stroke()

                                ctx.fillStyle = "#ff6d4d"
                                ctx.beginPath()
                                ctx.arc(px, centerY, 8, 0, Math.PI * 2)
                                ctx.fill()
                            }
                        }
                    }

                    Rectangle {
                        width: parent.width
                        height: (parent.height - 90) / 3
                        radius: 12
                        color: "#0b1120"
                        border.width: 1
                        border.color: "#2c3443"

                        Text {
                            anchors.left: parent.left
                            anchors.leftMargin: 12
                            anchors.top: parent.top
                            anchors.topMargin: 8
                            text: "ASSE Z (YAW): " + DBusClient.tiltZDeg.toFixed(1) + "°"
                            color: "#d6dae2"
                            font.pixelSize: 14
                            font.bold: true
                        }

                        Canvas {
                            id: tiltZCanvas
                            anchors.fill: parent
                            anchors.margins: 10
                            anchors.topMargin: 34
                            onPaint: {
                                var ctx = getContext("2d")
                                ctx.reset()
                                var centerY = height / 2
                                var x0 = 8
                                var x1 = width - 8
                                var value = Math.max(-180, Math.min(180, DBusClient.tiltZDeg))
                                var px = x0 + ((value + 180) / 360) * (x1 - x0)

                                ctx.strokeStyle = "#5f6f88"
                                ctx.lineWidth = 3
                                ctx.beginPath()
                                ctx.moveTo(x0, centerY)
                                ctx.lineTo(x1, centerY)
                                ctx.stroke()

                                ctx.fillStyle = "#ff6d4d"
                                ctx.beginPath()
                                ctx.arc(px, centerY, 8, 0, Math.PI * 2)
                                ctx.fill()
                            }
                        }
                    }
                }
            }
        }
    }
}
