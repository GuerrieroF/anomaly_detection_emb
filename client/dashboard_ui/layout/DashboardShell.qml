import QtQuick
import Dashboard.Ui 1.0

Rectangle {
    id: root

    default property alias content: contentHost.data
    readonly property alias contentItem: contentHost
    property alias navigationItems: sideBar.items
    property alias sidebar: sideBar
    property alias topBanner: banner
    property int contentPadding: DashboardSpacing.lg
    property bool overlaySidebar: false
    property bool edgeToEdgeContent: false
    property bool showSidebar: true
    property bool showTopBanner: true
    property int currentIndex: 0
    property bool serverAvailable: false
    property bool wifiAvailable: false
    property bool wifiConnected: false
    property int wifiSignalBars: 0
    property int batteryPercentage: -1
    property bool batteryCharging: false
    property int gpsSatellites: 0
    property bool gpsHasFix: false
    signal navigationRequested(int index)
    signal shutdownRequested()

    color: DashboardColors.background

    TopBanner {
        id: banner
        visible: root.showTopBanner
        height: visible ? implicitHeight : 0
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        serverAvailable: root.serverAvailable
        wifiAvailable: root.wifiAvailable
        wifiConnected: root.wifiConnected
        wifiSignalBars: root.wifiSignalBars
        batteryPercentage: root.batteryPercentage
        batteryCharging: root.batteryCharging
        gpsSatellites: root.gpsSatellites
        gpsHasFix: root.gpsHasFix
    }

    Sidebar {
        id: sideBar
        visible: root.showSidebar
        width: visible ? implicitWidth : 0
        z: root.overlaySidebar ? 1 : 0
        color: root.overlaySidebar ? "transparent" : DashboardColors.background
        anchors.left: parent.left
        anchors.top: banner.bottom
        anchors.bottom: parent.bottom
        currentIndex: root.currentIndex
        onShutdownRequested: root.shutdownRequested()
        onNavigationRequested: function(index) {
            root.currentIndex = index
            root.navigationRequested(index)
        }
    }

    Item {
        id: contentHost
        anchors.left: root.overlaySidebar ? parent.left : sideBar.right
        anchors.right: parent.right
        anchors.top: banner.bottom
        anchors.bottom: parent.bottom
        anchors.margins: root.edgeToEdgeContent ? 0 : root.contentPadding
    }
}
