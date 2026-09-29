pragma ComponentBehavior: Bound

import QtQuick
import Dashboard.Ui 1.0

Rectangle {
    id: root

    property int currentIndex: 0
    property var items: [
        { "icon": "home", "label": "Home" },
        { "icon": "map", "label": "Mappa" },
        { "icon": "charts", "label": "Telemetria" },
        { "icon": "speed", "label": "Veicolo" }
    ]
    property int padding: DashboardSpacing.lg
    property int itemSpacing: DashboardSpacing.sm
    property int buttonSize: DashboardSpacing.minTouch
    property bool showSettings: true
    property string settingsIcon: "settings"
    property string settingsLabel: qsTr("Impostazioni")
    property color selectedColor: DashboardColors.accent
    property color buttonColor: DashboardColors.surfaceMuted
    signal navigationRequested(int index)

    implicitWidth: DashboardSpacing.sidebarWidth
    color: DashboardColors.background

    Column {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: root.padding
        spacing: root.itemSpacing

        Repeater {
            model: root.items

            SidebarButton {
                required property var modelData
                required property int index
                objectName: "navigationButton" + index
                width: root.buttonSize
                height: root.buttonSize
                backgroundColor: root.buttonColor
                selectedColor: root.selectedColor
                iconName: modelData.icon
                label: modelData.label
                selected: index === root.currentIndex
                onClicked: root.navigationRequested(index)
            }
        }
    }

    SidebarButton {
        objectName: "settingsButton"
        visible: root.showSettings
        width: root.buttonSize
        height: root.buttonSize
        backgroundColor: root.buttonColor
        selectedColor: root.selectedColor
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: root.padding
        iconName: root.settingsIcon
        label: root.settingsLabel
        selected: root.currentIndex === root.items.length
        onClicked: root.navigationRequested(root.items.length)
    }
}
