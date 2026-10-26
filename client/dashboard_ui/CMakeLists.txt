set_source_files_properties(
    colors/DashboardColors.qml
    spacing/DashboardSpacing.qml
    typography/DashboardTypography.qml
    PROPERTIES
        QT_QML_SINGLETON_TYPE TRUE
)

find_package(Qt6 REQUIRED COMPONENTS Quick QuickControls2 Location Positioning)

qt_add_library(dashboard_ui STATIC)

target_link_libraries(dashboard_ui PRIVATE Qt6::Quick Qt6::QuickControls2 Qt6::Location Qt6::Positioning)

qt6_add_qml_module(dashboard_ui
    URI Dashboard.Ui
    VERSION 1.0
    OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/Dashboard/Ui
    QML_FILES
        colors/DashboardColors.qml
        spacing/DashboardSpacing.qml
        typography/DashboardTypography.qml
        buttons/DashboardButton.qml
        buttons/SidebarButton.qml
        cards/DashboardCard.qml
        icons/IconGlyph.qml
        indicators/ApplicationLogo.qml
        indicators/MetricChip.qml
        indicators/StatusPill.qml
        bars/TopBanner.qml
        navigation/Sidebar.qml
        layout/DashboardShell.qml
        charts/AccelerationVectorChart.qml
        charts/SeriesLineChart.qml
        gauges/Speedometer.qml
        maps/MapPanel.qml
        vehicle/CarAttitudeView.qml
    RESOURCES
        assets/car_attitude_rear.PNG
        assets/car_attitude_side.PNG
    NO_PLUGIN
)

option(DASHBOARD_UI_BUILD_TESTS "Build Dashboard.Ui QML component tests" OFF)
if(DASHBOARD_UI_BUILD_TESTS)
    find_package(Qt6 REQUIRED COMPONENTS QuickTest)
    qt_add_executable(dashboard_ui_tests tests/quicktest.cpp)
    target_link_libraries(dashboard_ui_tests PRIVATE dashboard_ui Qt6::QuickTest)
    target_compile_definitions(dashboard_ui_tests PRIVATE
        QUICK_TEST_SOURCE_DIR="${CMAKE_CURRENT_SOURCE_DIR}/tests"
    )
endif()
