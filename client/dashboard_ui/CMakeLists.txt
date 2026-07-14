set_source_files_properties(
    tokens/DashboardColors.qml
    tokens/DashboardSpacing.qml
    tokens/DashboardTypography.qml
    PROPERTIES
        QT_QML_SINGLETON_TYPE TRUE
)

qt_add_library(dashboard_ui STATIC)

qt6_add_qml_module(dashboard_ui
    URI Dashboard.Ui
    VERSION 1.0
    OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/Dashboard/Ui
    QML_FILES
        tokens/DashboardColors.qml
        tokens/DashboardSpacing.qml
        tokens/DashboardTypography.qml
        controls/DashboardCard.qml
        controls/IconGlyph.qml
        controls/MetricChip.qml
        controls/StatusPill.qml
        navigation/Sidebar.qml
        navigation/SidebarButton.qml
        layout/DashboardShell.qml
        layout/TopBanner.qml
        visualizations/AccelerationVectorChart.qml
        visualizations/CarAttitudeView.qml
        visualizations/MapPanel.qml
        visualizations/SeriesLineChart.qml
        visualizations/Speedometer.qml
    RESOURCES
        assets/car_attitude_rear.PNG
        assets/car_attitude_side.PNG
    NO_PLUGIN
)
