import QtQuick
import QtQuick.Layouts
import Dashboard.Ui 1.0

RowLayout {
    id: root

    property real speedKmh: 0
    property real rollDeg: 0
    property real pitchDeg: 0
    property real yawDeg: 0

    spacing: DashboardSpacing.lg

    Speedometer {
        objectName: "vehicleSpeedometer"
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.preferredWidth: 1
        speed: root.speedKmh
    }

    CarAttitudeView {
        objectName: "vehicleAttitude"
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.preferredWidth: 1
        title: qsTr("Assetto veicolo")
        subtitle: qsTr("Pitch / Roll")
        orientation: Qt.Vertical
        rollDeg: root.rollDeg
        pitchDeg: root.pitchDeg
        yawDeg: root.yawDeg
    }
}
