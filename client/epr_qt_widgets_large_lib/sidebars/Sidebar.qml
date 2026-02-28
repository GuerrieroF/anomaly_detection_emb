import QtQuick
import QtQuick.Controls
import "../"
import "../parts"
import "../colors"

Item {
    id: root

    property alias showSidebarTop: sidebarTop.visible
    property alias showSidebarBottom: sidebarBottom.visible
    property bool showScrollbar: true
    property bool showSidebarHeader: true

    property alias sidebarTopTitle: sidebarTop.title
    property alias sidebarTopType: sidebarTop.type
    property string sidebarHeader: "Heading"
    property alias sidebarBottomLabel: sidebarBottom.title
    property alias sidebarBottomIcon: sidebarBottom.icon
    property alias showSidebarBottomIcon: sidebarBottom.showIcon

    property alias list: sidebarList
    property alias sidebarList: sidebarList.model
    property alias sidebarListItem: sidebarList.delegate

    readonly property Component listHeader: root.showSidebarHeader ? listHeaderComponent : null

    signal topClicked()
    signal bottomClicked()
    Rectangle {
        anchors.fill: parent
        color: ColorSemantic.layerVariant1BackgroundDefault
    }

    SidebarTop {
        id: sidebarTop

        anchors {
            left: parent.left
            right: parent.right
            top: visible ? parent.top : undefined
        }
        showShadow: scrollbar.position > 0
        onClicked: root.topClicked()
        z: 2

    }

    ListView{
        id: sidebarList

        anchors {
            left: parent.left
            right: parent.right
            top: sidebarTop.visible ? sidebarTop.bottom : parent.top
            topMargin: sidebarTop.visible ? -sidebarTop.shadowHeight : 0
            bottom: sidebarBottom.visible ? sidebarBottom.top : parent.bottom
            bottomMargin: sidebarBottom.visible ? -sidebarBottom.shadowHeight : 0

        }
        clip: true
        boundsBehavior: ListView.StopAtBounds

        header: root.listHeader

        ScrollBar.vertical: Scrollbar {
            id: scrollbar
            visible: root.showScrollbar && (sidebarList.contentHeight > sidebarList.height)
        }
    }

    SidebarBottom {
        id: sidebarBottom

        anchors {
            left: parent.left
            right: parent.right
            bottom: visible ? parent.bottom : undefined
        }
        showShadow: scrollbar.position + scrollbar.size < 1
        onClicked: root.bottomClicked()
        z:2
    }

    // Header list component
    Component {
        id: listHeaderComponent
        SideNavigationHeader {
            label: root.sidebarHeader
        }
    }
}
