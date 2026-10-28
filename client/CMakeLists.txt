cmake_minimum_required(VERSION 3.16)

project(client VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick QuickControls2 DBus Core Location Positioning)

set(ANOMALY_MAP_BACKEND "osm" CACHE STRING "Map backend: osm or google")
set_property(CACHE ANOMALY_MAP_BACKEND PROPERTY STRINGS osm google)
if(NOT ANOMALY_MAP_BACKEND STREQUAL "osm" AND NOT ANOMALY_MAP_BACKEND STREQUAL "google")
    message(FATAL_ERROR "ANOMALY_MAP_BACKEND must be osm or google")
endif()
if(ANOMALY_MAP_BACKEND STREQUAL "google")
    find_package(Qt6 REQUIRED COMPONENTS WebEngineQuick)
    configure_file(views/GoogleMapView.qml
        ${CMAKE_CURRENT_BINARY_DIR}/selected_map/MapView.qml COPYONLY)
    set(MAP_VIEW_QML ${CMAKE_CURRENT_BINARY_DIR}/selected_map/MapView.qml)
    set_source_files_properties(${MAP_VIEW_QML} PROPERTIES QT_RESOURCE_ALIAS views/MapView.qml)
else()
    set(MAP_VIEW_QML views/MapView.qml)
endif()

qt_standard_project_setup(REQUIRES 6.5)

qt6_generate_dbus_interface(client_dbus_iface
    ../dbusinterfaces/com.example.DBusInterface.xml
)

qt_add_executable(appclient
    main.cpp
    system/DevicePower.h
    system/DeviceBattery.h
    system/DeviceWifi.h
    system/WifiManager.h system/WifiManager.cpp
    maps/MapConfiguration.h maps/MapConfiguration.cpp
    ${client_dbus_iface}
)

# Keep credentials out of QML resources and the executable.
if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/map.local.ini")
    configure_file(map.local.ini map.local.ini COPYONLY)
endif()

qt_add_qml_module(appclient
    URI client
    VERSION 1.0
    RESOURCE_PREFIX /qt/qml
    QML_FILES
        Main.qml
        dialogs/PowerDialog.qml
        views/DashboardView.qml
        views/HomeView.qml
        views/VehicleView.qml
        views/AccelerationsView.qml
        ${MAP_VIEW_QML}
        views/SettingsView.qml
        views/LogsView.qml
    SOURCES
        connection/dbusclient.h connection/dbusclient.cpp
)

if(ANOMALY_MAP_BACKEND STREQUAL "google")
    target_link_libraries(appclient PRIVATE Qt6::WebEngineQuick)
    target_compile_definitions(appclient PRIVATE ANOMALY_GOOGLE_MAPS)
    qt_add_resources(appclient google_maps_resources
        PREFIX /maps
        FILES maps/google-map.html
    )
endif()

# Dashboard.Ui is the only UI library built by the client.
# epr_qt_widgets_large_lib is kept in the source tree as a reference only.
add_subdirectory(dashboard_ui)

if(DASHBOARD_UI_BUILD_TESTS)
    find_package(Qt6 REQUIRED COMPONENTS Test)
    qt_add_executable(wifi_manager_tests
        tests/WifiManagerTest.cpp
        system/WifiManager.h system/WifiManager.cpp
    )
    target_include_directories(wifi_manager_tests PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})
    target_link_libraries(wifi_manager_tests PRIVATE Qt6::Core Qt6::Test)

    qt_add_executable(map_configuration_tests
        tests/MapConfigurationTest.cpp
        maps/MapConfiguration.h maps/MapConfiguration.cpp
    )
    target_include_directories(map_configuration_tests PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})
    target_link_libraries(map_configuration_tests PRIVATE Qt6::Core Qt6::Test)
endif()

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appclient PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appclient
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appclient
    PRIVATE Qt6::Quick
            Qt6::DBus
            Qt6::Core
            Qt6::Location
            Qt6::Positioning
            dashboard_ui
)

include(GNUInstallDirs)
install(TARGETS appclient
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
