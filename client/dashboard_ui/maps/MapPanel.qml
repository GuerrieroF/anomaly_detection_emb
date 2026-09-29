import QtQuick
import QtLocation
import QtPositioning
import QtQuick.Shapes
import Dashboard.Ui 1.0

DashboardCard {
    id: root

    property bool hasPosition: false
    property real latitude: 0
    property real longitude: 0
    property real heading: 0
    property alias zoomLevel: map.zoomLevel
    property alias activeMapType: map.activeMapType
    readonly property alias supportedMapTypes: map.supportedMapTypes
    property Plugin mapPlugin: Plugin { name: "osm" }
    property bool interactive: true
    property bool showZoomControls: true
    property color markerColor: DashboardColors.accent
    property color markerBorderColor: DashboardColors.textPrimary
    property int markerSize: 32
    property string waitingText: qsTr("In attesa della posizione dalla scheda")

    title: "Mappa"
    subtitle: hasPosition ? "Posizione GPS" : "In attesa di un fix GPS valido"

    Map {
        id: map
        anchors.fill: parent
        visible: root.hasPosition
        plugin: root.mapPlugin
        center: QtPositioning.coordinate(root.latitude, root.longitude)
        zoomLevel: 16

        WheelHandler {
            enabled: root.interactive
            target: null
            onWheel: function(event) {
                map.zoomLevel = Math.max(map.minimumZoomLevel,
                                         Math.min(map.maximumZoomLevel,
                                                  map.zoomLevel + event.angleDelta.y / 120))
                event.accepted = true
            }
        }

        DragHandler {
            enabled: root.interactive
            target: null
            onTranslationChanged: function(delta) {
                map.pan(-delta.x, -delta.y)
            }
        }

        MapQuickItem {
            visible: root.hasPosition
            coordinate: QtPositioning.coordinate(root.latitude, root.longitude)
            anchorPoint: Qt.point(root.markerSize / 2, root.markerSize / 2)

            sourceItem: Item {
                width: root.markerSize
                height: root.markerSize
                rotation: root.heading

                Shape {
                    width: 32
                    height: 32
                    scale: root.markerSize / 32
                    transformOrigin: Item.TopLeft
                    ShapePath {
                        strokeColor: root.markerBorderColor
                        strokeWidth: 2
                        fillColor: root.markerColor
                        startX: 16
                        startY: 2
                        PathLine { x: 29; y: 29 }
                        PathLine { x: 16; y: 22 }
                        PathLine { x: 3; y: 29 }
                        PathLine { x: 16; y: 2 }
                    }
                }
            }
        }
    }

    Column {
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: DashboardSpacing.sm
        spacing: DashboardSpacing.xs
        visible: root.hasPosition && root.showZoomControls

        DashboardButton {
            text: "+"
            toolTip: qsTr("Aumenta zoom")
            enabled: root.interactive && map.zoomLevel < map.maximumZoomLevel
            onClicked: map.zoomLevel = Math.min(map.maximumZoomLevel, map.zoomLevel + 1)
        }

        DashboardButton {
            text: "−"
            toolTip: qsTr("Riduci zoom")
            enabled: root.interactive && map.zoomLevel > map.minimumZoomLevel
            onClicked: map.zoomLevel = Math.max(map.minimumZoomLevel, map.zoomLevel - 1)
        }
    }

    Text {
        anchors.centerIn: parent
        visible: !root.hasPosition
        text: root.waitingText
        color: DashboardColors.textSecondary
        font.family: DashboardTypography.family
        font.pixelSize: DashboardTypography.caption
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap
        width: parent.width - DashboardSpacing.xl
    }
}
