import QtQuick
import QtQuick.Layouts
import Dashboard.Ui 1.0

RowLayout {
    id: root

    property var zHistory: []
    property var vectorHistory: []
    property real zValue: 0
    property real lateralValue: 0
    property real longitudinalValue: 0

    spacing: DashboardSpacing.lg

    SeriesLineChart {
        objectName: "verticalAcceleration"
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.preferredWidth: 1
        title: qsTr("Accelerazione Z")
        subtitle: qsTr("lineare")
        history: root.zHistory
        currentValue: root.zValue
        minValue: -2
        maxValue: 2
    }

    AccelerationVectorChart {
        objectName: "lateralAcceleration"
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.preferredWidth: 1
        history: root.vectorHistory
        xValue: root.lateralValue
        yValue: root.longitudinalValue
        range: 2
    }
}
