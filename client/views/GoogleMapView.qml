import QtQuick
import QtWebEngine
import Dashboard.Ui 1.0

Item {
    id: root

    property var mapConfiguration: ({})
    property bool hasPosition: false
    property real latitude: 0
    property real longitude: 0
    property real heading: 0
    property var anomalies: []
    property real zoomLevel: 16
    readonly property bool hasApiKey: !!(mapConfiguration.googleApiKey && mapConfiguration.googleApiKey.length)

    function syncPosition() {
        if (!webView.ready)
            return
        var points = []
        if (Array.isArray(anomalies)) {
            for (var i = 0; i < anomalies.length; ++i) {
                var entry = anomalies[i]
                if (entry && isFinite(entry.latitude) && isFinite(entry.longitude)
                        && entry.latitude >= -90 && entry.latitude <= 90
                        && entry.longitude >= -180 && entry.longitude <= 180) {
                    points.push({
                        latitude: Number(entry.latitude),
                        longitude: Number(entry.longitude),
                        label: String(entry.label || entry.type || qsTr("Anomalia"))
                    })
                }
            }
        }
        var state = {
            valid: hasPosition && isFinite(latitude) && isFinite(longitude)
                   && latitude >= -90 && latitude <= 90
                   && longitude >= -180 && longitude <= 180,
            latitude: Number(latitude),
            longitude: Number(longitude),
            heading: isFinite(heading) ? Number(heading) : 0,
            anomalies: points
        }
        webView.runJavaScript("window.updateTelemetry(" + JSON.stringify(state) + ")")
    }

    onHasPositionChanged: syncPosition()
    onLatitudeChanged: syncPosition()
    onLongitudeChanged: syncPosition()
    onHeadingChanged: syncPosition()
    onAnomaliesChanged: syncPosition()

    WebEngineView {
        id: webView
        anchors.fill: parent
        property bool ready: false
        visible: root.hasApiKey
        url: "qrc:/maps/maps/google-map.html"

        onLoadingChanged: function(request) {
            if (request.status === WebEngineView.LoadSucceededStatus) {
                ready = true
                runJavaScript("window.configureGoogleMaps("
                              + JSON.stringify(root.mapConfiguration.googleApiKey) + ", "
                              + JSON.stringify(root.mapConfiguration.googleMapId || "DEMO_MAP_ID") + ")")
                root.syncPosition()
            } else if (request.status === WebEngineView.LoadFailedStatus) {
                ready = false
            }
        }
    }

    Text {
        anchors.centerIn: parent
        width: parent.width - DashboardSpacing.xl
        visible: !root.hasApiKey || !root.hasPosition
        text: !root.hasApiKey
              ? qsTr("Impostare la chiave Google Maps in map.local.ini")
              : qsTr("In attesa della posizione dalla scheda")
        color: DashboardColors.textSecondary
        font.family: DashboardTypography.family
        font.pixelSize: DashboardTypography.caption
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap
        padding: DashboardSpacing.sm
        Rectangle {
            anchors.fill: parent
            z: -1
            color: DashboardColors.surface
            radius: DashboardSpacing.sm
        }
    }
}
