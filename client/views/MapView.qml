import QtQuick
import QtLocation
import Dashboard.Ui 1.0

MapPanel {
    id: root

    property var mapConfiguration: ({})
    readonly property bool usesThunderforest: mapConfiguration.usesThunderforest === true

    mapPlugin: usesThunderforest ? thunderforestPlugin : standardPlugin

    readonly property Plugin thunderforestPlugin: Plugin {
        name: "osm"
        PluginParameter {
            name: "osm.mapping.providersrepository.address"
            value: root.mapConfiguration.providersRepository || ""
        }
        PluginParameter {
            name: "osm.mapping.cache.directory"
            value: root.mapConfiguration.cacheDirectory || ""
        }
        PluginParameter {
            name: "osm.useragent"
            value: "AnomalyDashboard/0.1"
        }
        PluginParameter {
            name: "osm.mapping.prefetching_style"
            value: "NoPrefetching"
        }
    }

    readonly property Plugin standardPlugin: Plugin {
        name: "osm"

        // Select a known endpoint instead of the plugin's changing provider list.
        PluginParameter {
            name: "osm.mapping.providersrepository.disabled"
            value: true
        }
        PluginParameter {
            name: "osm.mapping.custom.host"
            value: "https://tile.openstreetmap.org/"
        }
        PluginParameter {
            name: "osm.mapping.custom.datacopyright"
            value: '© <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
        }
        PluginParameter {
            name: "osm.useragent"
            value: "AnomalyDashboard/0.1"
        }
        PluginParameter {
            name: "osm.mapping.prefetching_style"
            value: "NoPrefetching"
        }
    }

    function selectTileProvider() {
        var style = usesThunderforest ? MapType.StreetMap : MapType.CustomMap
        for (var i = 0; i < supportedMapTypes.length; ++i) {
            if (supportedMapTypes[i].style === style) {
                root.activeMapType = supportedMapTypes[i]
                return
            }
        }
    }

    onSupportedMapTypesChanged: selectTileProvider()
    Component.onCompleted: selectTileProvider()
}
