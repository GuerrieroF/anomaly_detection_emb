import QtQuick
import Dashboard.Ui 1.0

Rectangle {
    id: root

    default property alias content: contentHost.data
    property int currentIndex: 0
    property bool serverAvailable: false
    signal navigationRequested(int index)

    color: DashboardColors.background

    TopBanner {
        id: banner
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        serverAvailable: root.serverAvailable
    }

    Sidebar {
        id: sideBar
        anchors.left: parent.left
        anchors.top: banner.bottom
        anchors.bottom: parent.bottom
        currentIndex: root.currentIndex
        onNavigationRequested: function(index) {
            root.currentIndex = index
            root.navigationRequested(index)
        }
    }

    Item {
        id: contentHost
        anchors.left: sideBar.right
        anchors.right: parent.right
        anchors.top: banner.bottom
        anchors.bottom: parent.bottom
        anchors.margins: DashboardSpacing.lg
    }
}
