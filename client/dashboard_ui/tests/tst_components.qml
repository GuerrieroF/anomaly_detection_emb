import QtQuick
import QtTest
import QtLocation
import Dashboard.Ui 1.0
import "../../views" as Views

TestCase {
    id: testCase
    name: "DashboardUi"
    width: 800
    height: 600
    visible: true
    when: windowShown

    Component { id: cardComponent; DashboardCard { width: 320; height: 200 } }
    Component { id: buttonComponent; DashboardButton { text: "Azione" } }
    Component { id: shellComponent; DashboardShell { width: 800; height: 600 } }
    Component { id: lineComponent; SeriesLineChart { width: 400; height: 240; showValue: false; history: [0, 1, -1, 0] } }
    Component { id: vectorComponent; AccelerationVectorChart { width: 320; height: 320 } }
    Component { id: gaugeComponent; Speedometer { width: 320; height: 320; speed: 60 } }
    Component { id: carComponent; CarAttitudeView { width: 500; height: 300 } }
    Component { id: mapComponent; MapPanel { width: 320; height: 320 } }
    SignalSpy { id: clickSpy; signalName: "clicked" }

    QtObject {
        id: mockTelemetry
        property bool serverAvailable: false
        property real tiltXDeg: 12
        property real tiltYDeg: -8
        property real tiltZDeg: 0
        property real linearAccelXg: 0.2
        property real linearAccelYg: 0.3
        property real linearAccelZg: 0.4
        property bool gpsHasFix: false
        property real gpsLatitude: 0
        property real gpsLongitude: 0
        property real gpsHeading: 0
        signal imuDataChanged()
    }

    Component {
        id: dashboardComponent
        Views.DashboardView {
            width: 1024
            height: 600
            telemetry: mockTelemetry
        }
    }

    function test_dashboard_navigation_and_layout() {
        var dashboard = createTemporaryObject(dashboardComponent, testCase)
        verify(dashboard)
        var pages = findChild(dashboard, "dashboardPages")
        var vehicle = findChild(dashboard, "vehiclePage")
        var accelerations = findChild(dashboard, "accelerationsPage")
        var map = findChild(dashboard, "mapPage")
        var settings = findChild(dashboard, "settingsPage")
        // Setting custom.host alone is insufficient: Qt must select CustomMap.
        tryVerify(function() { return map.activeMapType.style === MapType.CustomMap })
        tryCompare(vehicle, "visible", true)
        compare(accelerations.visible, false)
        compare(map.visible, false)
        compare(settings.visible, false)

        var speed = findChild(vehicle, "vehicleSpeedometer")
        var attitude = findChild(vehicle, "vehicleAttitude")
        tryVerify(function() { return Math.abs(speed.width - attitude.width) <= 1 })
        verify(speed.x < attitude.x)
        var pitch = findChild(attitude, "pitchSection")
        var roll = findChild(attitude, "rollSection")
        tryVerify(function() { return pitch.y < roll.y })
        compare(pitch.x, roll.x)
        compare(attitude.pitchDeg, mockTelemetry.tiltYDeg)
        compare(attitude.rollDeg, mockTelemetry.tiltXDeg)

        mockTelemetry.imuDataChanged()
        compare(pages.accelZHistory.length, 1)
        mouseClick(findChild(dashboard, "navigationButton1"))
        compare(dashboard.currentIndex, 1)
        tryCompare(accelerations, "visible", true)
        compare(vehicle.visible, false)
        var z = findChild(accelerations, "verticalAcceleration")
        var lateral = findChild(accelerations, "lateralAcceleration")
        tryVerify(function() { return Math.abs(z.width - lateral.width) <= 1 })
        verify(z.x < lateral.x)
        compare(z.history.length, 1)

        mouseClick(findChild(dashboard, "navigationButton2"))
        tryCompare(map, "visible", true)
        compare(accelerations.visible, false)
        compare(map.width, pages.width)
        compare(map.height, pages.height)
        compare(map.mapToItem(dashboard, 0, 0).x, 0)
        compare(map.width, dashboard.width)
        map.zoomLevel = 12
        mockTelemetry.imuDataChanged()
        mouseClick(findChild(dashboard, "settingsButton"))
        compare(dashboard.currentIndex, 3)
        tryCompare(settings, "visible", true)
        compare(map.visible, false)
        verify(findChild(dashboard, "settingsButton").selected)

        mouseClick(findChild(dashboard, "navigationButton1"))
        compare(z.history.length, 2)
        mouseClick(findChild(dashboard, "navigationButton2"))
        compare(map.zoomLevel, 12)
        mouseClick(findChild(dashboard, "navigationButton0"))
        tryCompare(vehicle, "visible", true)
        compare(settings.visible, false)
    }

    function test_card_header_layout() {
        var card = createTemporaryObject(cardComponent, testCase)
        verify(card)
        tryCompare(card.contentItem, "y", card.padding)
        card.subtitle = "Sottotitolo senza titolo"
        tryVerify(function() { return card.contentItem.y > card.padding + card.headerSpacing })
        card.title = "Titolo"
        var subtitleOnlyY = card.contentItem.y
        tryVerify(function() { return card.contentItem.y > subtitleOnlyY })
        card.showHeader = false
        tryCompare(card.contentItem, "y", card.padding)
        compare(card.contentItem.width, card.width - 2 * card.padding)
    }

    function test_button_keyboard_and_disabled() {
        var button = createTemporaryObject(buttonComponent, testCase)
        verify(button)
        clickSpy.target = button
        clickSpy.clear()
        button.forceActiveFocus()
        keyClick(Qt.Key_Space)
        compare(clickSpy.count, 1)
        button.enabled = false
        mouseClick(button)
        keyClick(Qt.Key_Space)
        compare(clickSpy.count, 1)
        clickSpy.target = null
    }

    function test_shell_optional_chrome() {
        var shell = createTemporaryObject(shellComponent, testCase)
        verify(shell)
        shell.showSidebar = false
        shell.showTopBanner = false
        tryCompare(shell.contentItem, "x", shell.contentPadding)
        tryCompare(shell.contentItem, "y", shell.contentPadding)
        compare(shell.contentItem.width, shell.width - 2 * shell.contentPadding)
        shell.showSidebar = true
        tryVerify(function() { return shell.contentItem.x > shell.contentPadding })
        shell.sidebar.navigationRequested(2)
        compare(shell.currentIndex, 2)
    }

    function test_canvas_style_repaints_data() {
        return [
            { tag: "series", component: lineComponent, propertyName: "lineColor" },
            { tag: "vector", component: vectorComponent, propertyName: "pointColor" },
            { tag: "gauge", component: gaugeComponent, propertyName: "progressColor" }
        ]
    }

    function test_canvas_style_repaints(data) {
        var item = createTemporaryObject(data.component, testCase)
        verify(item)
        verify(waitForRendering(item))
        // Allow the Canvas texture to be uploaded before taking the baseline.
        wait(50)
        var before = grabImage(item)
        item[data.propertyName] = "#ff00ff"
        tryVerify(function() { return !grabImage(item).equals(before) })
    }

    function test_global_palette_repaints_canvas() {
        var item = createTemporaryObject(vectorComponent, testCase)
        verify(item)
        verify(waitForRendering(item))
        wait(50)
        var before = grabImage(item)
        var original = DashboardColors.border
        try {
            DashboardColors.border = "#ff00ff"
            tryVerify(function() { return !grabImage(item).equals(before) })
        } finally {
            DashboardColors.border = original
        }
    }

    function test_specialized_components_load() {
        var car = createTemporaryObject(carComponent, testCase, { rollDeg: 12, pitchDeg: -8, showMetrics: false })
        verify(car)
        var map = createTemporaryObject(mapComponent, testCase, { interactive: false, markerSize: 48 })
        verify(map)
        // No GPS fix or network connection is required to display the placeholder.
        compare(map.hasPosition, false)
    }
}
