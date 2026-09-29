# Dashboard.Ui

Libreria QML del client, indipendente da D-Bus e dalla logica applicativa.
Il client compila e collega solo `dashboard_ui`: `epr_qt_widgets_large_lib`
resta nel repository come riferimento, senza dipendenze di build o import QML.

La suddivisione per categorie riguarda i sorgenti. L'import pubblico e i nomi
preesistenti dei componenti restano invariati:

```qml
import Dashboard.Ui 1.0
```

| Categoria | Componenti |
| --- | --- |
| `colors` | `DashboardColors`: palette semantica |
| `spacing` | `DashboardSpacing`: spaziature, raggi, dimensioni di base |
| `typography` | `DashboardTypography`: famiglia e dimensioni dei font |
| `buttons` | `DashboardButton`, `SidebarButton` |
| `cards` | `DashboardCard` |
| `indicators` | `MetricChip`, `StatusPill` |
| `icons` | `IconGlyph` |
| `bars` | `TopBanner` |
| `navigation` | `Sidebar` |
| `layout` | `DashboardShell` |
| `charts` | `SeriesLineChart`, `AccelerationVectorChart` |
| `gauges` | `Speedometer` |
| `maps` | `MapPanel` |
| `vehicle` | `CarAttitudeView` |
| `assets` | Immagini predefinite del veicolo |

## Personalizzazione globale

I singleton di colori, spaziature e tipografia espongono proprietà modificabili.
Impostarli all'avvio applica un tema comune; i binding aggiornano anche le
istanze già create. I Canvas vengono ridisegnati al cambio delle loro proprietà
di stile, senza dover attendere nuovi campioni telemetrici.

```qml
Component.onCompleted: {
    DashboardColors.accent = "#68b5ff"
    DashboardColors.surface = "#202630"
    DashboardSpacing.radiusMd = 12
    DashboardTypography.family = "Sans Serif"
}
```

## Personalizzazione per istanza

Ogni componente usa i token come default. Le proprietà locali permettono di
specializzare una singola istanza senza modificare il tema globale.
Un valore assegnato esplicitamente sostituisce il relativo binding al token.

```qml
DashboardCard {
    width: 360
    height: 220
    title: "Diagnostica"
    subtitle: "Contenuto personalizzato"
    padding: 20
    radius: 12
    color: "#202630"
    border.color: "#536274"
    titleColor: "#68b5ff"
    titleFont.pixelSize: 20

    Text {
        anchors.centerIn: parent
        text: "Il contenuto viene inserito nell'area interna della card"
        color: DashboardColors.textPrimary
        width: parent.width
        wrapMode: Text.WordWrap
    }
}

DashboardButton {
    text: "Mappa"
    iconName: "map"
    toolTip: "Apri la mappa"
    checkable: true
    selectedColor: "#68b5ff"
    cornerRadius: 12
    onClicked: console.log("Mappa richiesta")
}

SeriesLineChart {
    width: 400
    height: 220
    title: "Accelerazione Z"
    unit: "g"
    minValue: -4
    maxValue: 4
    history: [0, 0.4, -0.2, 0.8]
    lineColor: "#ffb454"
    lineWidth: 3
    gridDivisions: 8
    valueDecimals: 3
}
```

| Componente | Proprietà principali di personalizzazione |
| --- | --- |
| `DashboardCard` | `padding`, `headerSpacing`, `showHeader`, `titleColor`, `subtitleColor`, `titleFont`, `subtitleFont`; proprietà Rectangle `color`, `radius`, `border` |
| `DashboardButton` | `text`, `iconName`, `iconSource`, `iconSize`, `toolTip`, `selected`, `checkable`, `font`, `padding`, `spacing`, `cornerRadius`, colori degli stati, `disabledOpacity`; contenuto e sfondo sostituibili tramite `contentItem` e `background` |
| `SidebarButton` | Stessa API di `DashboardButton`, più `label` per tooltip e nome accessibile |
| `MetricChip` | `label`, `value`, `accentColor`, `labelColor`, `labelFont`, `valueFont`, `padding` |
| `StatusPill` | `online`, `onlineText`, `offlineText`, `onlineColor`, `offlineColor`, `textColor`, `textFont`, `indicatorSize`, `padding`, `spacing` |
| `IconGlyph` | `name` (`home`, `map`, `charts`, `speed`, `settings`), `strokeColor`, `fillColor`, `strokeWidth`, `width`, `height` |
| `Sidebar` | `items` (array di `{icon, label}`), `currentIndex`, `buttonSize`, `itemSpacing`, `padding`, `showSettings`, `settingsIcon`, `settingsLabel`, `selectedColor`, `buttonColor` |
| `TopBanner` | `now`, `clockRunning`, `showClock`, `showStatus`, `timeFormat`, `dateFormat`, `padding`, `timeColor`, `dateColor`, `statusIndicator` |
| `DashboardShell` | `navigationItems`, `currentIndex`, `contentPadding`, `showSidebar`, `showTopBanner`; accesso a `sidebar`, `topBanner`, `contentItem` |
| `SeriesLineChart` | `history`, `currentValue`, `minValue`, `maxValue`, `unit`, `lineColor`, `lineWidth`, `gridColor`, `gridDivisions`, `labelColor`, `chartFont`, `valueDecimals`, `showValue` |
| `AccelerationVectorChart` | `history` (array di `{x, y}`), `xValue`, `yValue`, `range`, colori di griglia/assi/traccia/punto, `pointRadius`, `ringCount`, `topLabel`, `bottomLabel`, `leftLabel`, `rightLabel`, `chartFont` |
| `Speedometer` | `speed`, `maxSpeed`, `unit`, `trackColor`, `progressColor`, `tickColor`, `labelColor`, `valueColor`, `trackWidth`, `progressWidth`, `tickCount`, `chartFont`, `valueFont` |
| `MapPanel` | coordinate e direzione, `zoomLevel`, `mapPlugin`, `activeMapType`, `supportedMapTypes` (sola lettura), `interactive`, `showZoomControls`, `markerColor`, `markerBorderColor`, `markerSize`, `waitingText` |
| `CarAttitudeView` | `orientation` (`Qt.Vertical` di default: pitch sopra, roll sotto; `Qt.Horizontal` per affiancarli), angoli, `rollImageSource`, `pitchImageSource`, testi delle etichette, `angleUnit`, `valueDecimals`, `rollScale`, `pitchScale`, limiti di rotazione, `showMetrics`, `rollColor`, `pitchColor`, `shadowColor` |

Grafici, tachimetro, mappa e vista veicolo ereditano anche le proprietà della card.
Per gli array di campioni assegnare un nuovo array dopo ogni modifica, in modo
che QML emetta il segnale di aggiornamento. Usare limiti numerici ordinati
(`minValue < maxValue`) e scale positive.

`MapPanel.mapPlugin` accetta un `Plugin` Qt Location configurato alla creazione,
anche con parametri specifici del provider. Il default del componente resta il plugin OSM; eventuali
chiavi API e disponibilità delle tile dipendono dal provider. La libreria non
contiene credenziali. Quando si configura `osm.mapping.custom.host`, selezionare
anche il tipo `MapType.CustomMap` da `supportedMapTypes`, assegnandolo ad
`activeMapType`. La pagina applicativa `client/views/MapView.qml` usa la
configurazione locale descritta sotto. Senza configurazione Thunderforest
completa, usa le tile standard OpenStreetMap via HTTPS, senza chiave API.
Entrambi i provider mantengono attribuzione, User-Agent applicativo, cache Qt
e prefetch disabilitato, senza dipendere dalla lista remota dei provider Qt.
Per l'uso del servizio pubblico valgono le
[condizioni OSM](https://operations.osmfoundation.org/policies/tiles/),
che non permettono download massivi o pre-caricamento per uso offline.
Il servizio non garantisce disponibilità: per distribuzioni estese scegliere
un provider adatto o un server di tile proprio.

Con `interactive: false` la mappa non accetta pan e zoom.

## Configurazione locale di Thunderforest

Copiare `client/map.example.ini` in `client/map.local.ini` e compilare:

```ini
[map]
provider=thunderforest
apiKey=INSERIRE_LA_PROPRIA_CHIAVE
style=transport-dark
```

`map.local.ini` è escluso da Git. CMake lo copia accanto all'eseguibile durante
la configurazione, senza incorporarlo nelle risorse o nel binario. Dopo una
modifica al file, ricompilare e riavviare il client. In distribuzione, collocare
il file accanto ad `appclient`, oppure impostare `ANOMALY_MAP_CONFIG` con il
percorso assoluto della configurazione locale. Il file non viene installato
automaticamente dal target CMake di installazione.

Stili supportati: `atlas`, `cycle`, `transport`, `transport-dark`, `landscape`,
`outdoors`, `mobile-atlas`, `neighbourhood`, `pioneer`, `spinal-map`,
`atlas-canvas`. Per tornare alle tile standard OSM impostare `provider=osm`.

Qt 6.5.3 aggiunge automaticamente `%z/%x/%y.png` a `osm.mapping.custom.host`:
questo non consente di inserire direttamente un URL completo con `apikey`.
`MapConfiguration` genera quindi un repository locale temporaneo di descrittori
con l'URL completo. Qt risolve tutti i suoi tipi di mappa interni; ogni
descrittore punta allo stile scelto e la pagina seleziona `StreetMap`.
I descrittori sono leggibili solo dal proprietario e vengono eliminati alla
chiusura normale del client. La cache è separata per stile e credenziale, così
non riutilizza tile OSM o risposte ottenute con una chiave precedente.

Una configurazione incompleta o uno stile sconosciuto produce un avviso e usa
OSM. Una chiave presente ma rifiutata dal servizio va corretta nel file locale:
il client non verifica preventivamente la validità della chiave all'avvio.

La navigazione emette `navigationRequested(index)`: la scelta della pagina e
i binding a D-Bus rimangono responsabilità del client. La libreria non introduce
pagine o funzioni applicative associate ai pulsanti.

## Build e verifica

Richiede Qt 6.5 o successivo con Quick, QuickControls2, Location e Positioning,
oltre ai moduli richiesti dal progetto principale.

```sh
cmake -S . -B build -DQt6_DIR=/percorso/Qt/lib/cmake/Qt6 -DDASHBOARD_UI_BUILD_TESTS=ON
cmake --build build -j 4
QT_QPA_PLATFORM=offscreen QT_QUICK_BACKEND=software \
    build/client/dashboard_ui/dashboard_ui_tests
build/client/map_configuration_tests
```

I test verificano layout delle card, navigazione, attivazione da tastiera,
stato disabilitato, ridisegno dei Canvas al cambio di stile e caricamento dei
componenti specializzati. Non richiedono il server o una board collegata.
La build dei test è opzionale (disabilitata per default) e richiede Qt QuickTest.
Il runner collega la libreria statica per verificare le stesse risorse QML
incorporate nel client.

Per aggiungere un componente: scegliere la categoria, usare i token per i
default, esporre proprietà e segnali necessari e registrare il file in
`dashboard_ui/CMakeLists.txt`. Evitare import relativi alle cartelle interne
nei consumer: usare sempre `Dashboard.Ui`.
