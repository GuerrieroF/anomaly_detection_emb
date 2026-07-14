import QtQuick
import Dashboard.Ui 1.0

DashboardCard {
    id: root

    property real rollDeg: 0
    property real pitchDeg: 0
    property real yawDeg: 0
    property url rollImageSource: Qt.resolvedUrl("../assets/car_attitude_rear.PNG")
    property url pitchImageSource: Qt.resolvedUrl("../assets/car_attitude_side.PNG")

    onRollDegChanged: {
        rollCanvas.requestPaint()
        rollShadow.requestPaint()
    }
    onPitchDegChanged: {
        pitchCanvas.requestPaint()
        pitchShadow.requestPaint()
    }
    onYawDegChanged: {
        rollShadow.requestPaint()
        pitchShadow.requestPaint()
    }

    Item {
        id: stage
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: chips.top
        anchors.bottomMargin: DashboardSpacing.sm

        Row {
            anchors.fill: parent
            spacing: DashboardSpacing.lg

            Item {
                width: (parent.width - parent.spacing) / 2
                height: parent.height

                Text {
                    id: rollLabel
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    text: "Roll"
                    color: DashboardColors.textSecondary
                    font.family: DashboardTypography.family
                    font.pixelSize: DashboardTypography.caption
                    horizontalAlignment: Text.AlignHCenter
                }

                Canvas {
                    id: rollShadow
                    anchors.centerIn: rollCanvas
                    width: rollCanvas.width * 0.96
                    height: rollCanvas.height * 0.34
                    rotation: root.yawDeg * 0.12

                    onWidthChanged: requestPaint()
                    onHeightChanged: requestPaint()
                    onRotationChanged: requestPaint()
                    Component.onCompleted: requestPaint()

                    onPaint: {
                        var ctx = getContext("2d")
                        ctx.reset()
                        ctx.clearRect(0, 0, width, height)
                        ctx.strokeStyle = DashboardColors.accentMuted
                        ctx.lineWidth = 3
                        ctx.beginPath()
                        ctx.save()
                        ctx.translate(width / 2, height / 2)
                        ctx.scale(1, 0.32)
                        ctx.arc(0, 0, width * 0.42, 0, Math.PI * 2)
                        ctx.restore()
                        ctx.stroke()
                    }
                }

                Canvas {
                    id: rollCanvas
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: rollLabel.bottom
                    anchors.bottom: parent.bottom
                    anchors.topMargin: DashboardSpacing.sm
                    width: Math.min(parent.width * 0.94, height * 1.55)
                    rotation: Math.max(-24, Math.min(24, root.rollDeg * 0.45))
                    visible: root.rollImageSource.toString().length === 0 || rollImage.status === Image.Error

                    onWidthChanged: requestPaint()
                    onHeightChanged: requestPaint()
                    onRotationChanged: requestPaint()
                    Component.onCompleted: requestPaint()

                    onPaint: {
                        var ctx = getContext("2d")
                        ctx.reset()
                        ctx.clearRect(0, 0, width, height)

                        var x = width * 0.12
                        var y = height * 0.18
                        var w = width * 0.76
                        var h = height * 0.58

                        ctx.fillStyle = "#d8dedf"
                        ctx.strokeStyle = "#f6f8f8"
                        ctx.lineWidth = 2
                        ctx.beginPath()
                        ctx.moveTo(x + w * 0.16, y + h * 0.1)
                        ctx.lineTo(x + w * 0.84, y + h * 0.1)
                        ctx.quadraticCurveTo(x + w, y + h * 0.38, x + w * 0.92, y + h * 0.86)
                        ctx.lineTo(x + w * 0.08, y + h * 0.86)
                        ctx.quadraticCurveTo(x, y + h * 0.38, x + w * 0.16, y + h * 0.1)
                        ctx.closePath()
                        ctx.fill()
                        ctx.stroke()

                        ctx.fillStyle = "#acb7b8"
                        ctx.fillRect(x + w * 0.25, y + h * 0.2, w * 0.5, h * 0.18)
                        ctx.fillStyle = "#f5f7f8"
                        ctx.fillRect(x + w * 0.22, y + h * 0.44, w * 0.56, h * 0.26)

                        ctx.fillStyle = DashboardColors.danger
                        ctx.fillRect(x + w * 0.08, y + h * 0.42, w * 0.12, h * 0.2)
                        ctx.fillRect(x + w * 0.8, y + h * 0.42, w * 0.12, h * 0.2)
                        ctx.fillStyle = "#1f2428"
                        ctx.fillRect(x + w * 0.12, y + h * 0.84, w * 0.18, h * 0.07)
                        ctx.fillRect(x + w * 0.7, y + h * 0.84, w * 0.18, h * 0.07)

                        ctx.fillStyle = DashboardColors.danger
                        ctx.fillRect(x + w * 0.42, y + h * 0.04, w * 0.16, 3)
                    }
                }

                Image {
                    id: rollImage
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: rollLabel.bottom
                    anchors.bottom: parent.bottom
                    anchors.topMargin: DashboardSpacing.sm
                    width: Math.min(parent.width * 0.94, height * 1.55)
                    source: root.rollImageSource
                    visible: source.toString().length > 0 && status !== Image.Error
                    fillMode: Image.PreserveAspectFit
                    mipmap: true
                    smooth: true
                    rotation: Math.max(-24, Math.min(24, root.rollDeg * 0.45))
                }
            }

            Item {
                width: (parent.width - parent.spacing) / 2
                height: parent.height

                Text {
                    id: pitchLabel
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    text: "Pitch"
                    color: DashboardColors.textSecondary
                    font.family: DashboardTypography.family
                    font.pixelSize: DashboardTypography.caption
                    horizontalAlignment: Text.AlignHCenter
                }

                Canvas {
                    id: pitchShadow
                    anchors.horizontalCenter: pitchCanvas.horizontalCenter
                    anchors.verticalCenter: pitchCanvas.verticalCenter
                    width: pitchCanvas.width * 0.86
                    height: Math.max(28, pitchCanvas.height * 0.18)
                    rotation: root.yawDeg * 0.12

                    onWidthChanged: requestPaint()
                    onHeightChanged: requestPaint()
                    onRotationChanged: requestPaint()
                    Component.onCompleted: requestPaint()

                    onPaint: {
                        var ctx = getContext("2d")
                        ctx.reset()
                        ctx.clearRect(0, 0, width, height)
                        ctx.strokeStyle = DashboardColors.accentMuted
                        ctx.lineWidth = 3
                        ctx.beginPath()
                        ctx.save()
                        ctx.translate(width / 2, height / 2)
                        ctx.scale(1, 0.28)
                        ctx.arc(0, 0, width * 0.42, 0, Math.PI * 2)
                        ctx.restore()
                        ctx.stroke()
                    }
                }

                Canvas {
                    id: pitchCanvas
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: pitchLabel.bottom
                    anchors.bottom: parent.bottom
                    anchors.topMargin: DashboardSpacing.sm
                    width: Math.min(parent.width * 0.96, height * 1.72)
                    rotation: Math.max(-18, Math.min(18, -root.pitchDeg * 0.7))
                    visible: root.pitchImageSource.toString().length === 0 || pitchImage.status === Image.Error

                    onWidthChanged: requestPaint()
                    onHeightChanged: requestPaint()
                    onRotationChanged: requestPaint()
                    Component.onCompleted: requestPaint()

                    onPaint: {
                        var ctx = getContext("2d")
                        ctx.reset()
                        ctx.clearRect(0, 0, width, height)

                        var x = width * 0.1
                        var y = height * 0.32
                        var w = width * 0.8
                        var h = height * 0.38

                        ctx.fillStyle = "#d8dedf"
                        ctx.strokeStyle = "#f6f8f8"
                        ctx.lineWidth = 2
                        ctx.beginPath()
                        ctx.moveTo(x + w * 0.12, y + h * 0.7)
                        ctx.lineTo(x + w * 0.22, y + h * 0.28)
                        ctx.lineTo(x + w * 0.58, y + h * 0.12)
                        ctx.lineTo(x + w * 0.84, y + h * 0.3)
                        ctx.lineTo(x + w * 0.94, y + h * 0.7)
                        ctx.closePath()
                        ctx.fill()
                        ctx.stroke()

                        ctx.fillStyle = "#acb7b8"
                        ctx.fillRect(x + w * 0.34, y + h * 0.22, w * 0.24, h * 0.18)
                        ctx.fillStyle = "#f5f7f8"
                        ctx.fillRect(x + w * 0.18, y + h * 0.48, w * 0.7, h * 0.2)

                        ctx.fillStyle = DashboardColors.danger
                        ctx.fillRect(x + w * 0.08, y + h * 0.55, w * 0.08, h * 0.14)
                        ctx.fillStyle = DashboardColors.cyan
                        ctx.fillRect(x + w * 0.84, y + h * 0.55, w * 0.08, h * 0.14)

                        ctx.fillStyle = "#1f2428"
                        ctx.beginPath()
                        ctx.arc(x + w * 0.25, y + h * 0.78, h * 0.12, 0, Math.PI * 2)
                        ctx.arc(x + w * 0.78, y + h * 0.78, h * 0.12, 0, Math.PI * 2)
                        ctx.fill()
                    }
                }

                Image {
                    id: pitchImage
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: pitchLabel.bottom
                    anchors.bottom: parent.bottom
                    anchors.topMargin: DashboardSpacing.sm
                    width: Math.min(parent.width * 0.96, height * 1.72)
                    source: root.pitchImageSource
                    visible: source.toString().length > 0 && status !== Image.Error
                    fillMode: Image.PreserveAspectFit
                    mipmap: true
                    smooth: true
                    rotation: Math.max(-18, Math.min(18, -root.pitchDeg * 0.7))
                }
            }
        }
    }

    Row {
        id: chips
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        spacing: DashboardSpacing.sm

        MetricChip {
            width: (parent.width - parent.spacing) / 2
            label: "Roll"
            value: root.rollDeg.toFixed(1) + " deg"
            accentColor: DashboardColors.accent
        }

        MetricChip {
            width: (parent.width - parent.spacing) / 2
            label: "Pitch"
            value: root.pitchDeg.toFixed(1) + " deg"
            accentColor: DashboardColors.warning
        }
    }
}
