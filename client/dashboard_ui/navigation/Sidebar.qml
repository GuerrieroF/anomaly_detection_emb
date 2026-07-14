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
    signal navigationRequested(int index)

    width: DashboardSpacing.sidebarWidth
    color: DashboardColors.background

    Column {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: DashboardSpacing.lg
        spacing: DashboardSpacing.sm

        Repeater {
            model: root.items

            SidebarButton {
                iconName: modelData.icon
                label: modelData.label
                selected: index === root.currentIndex
                onClicked: root.navigationRequested(index)
            }
        }
    }

    SidebarButton {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: DashboardSpacing.lg
        iconName: "settings"
        label: "Impostazioni"
        selected: false
        onClicked: root.navigationRequested(root.items.length)
    }
}
