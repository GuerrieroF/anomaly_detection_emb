cmake_minimum_required(VERSION 3.16)

project(client VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick DBus Core Location Positioning)

qt_standard_project_setup(REQUIRES 6.5)

qt6_generate_dbus_interface(client_dbus_iface
    ../dbusinterfaces/com.example.DBusInterface.xml
)

qt_add_executable(appclient
    main.cpp
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
        views/DashboardView.qml
        views/HomeView.qml
        views/VehicleView.qml
        views/AccelerationsView.qml
        views/MapView.qml
        views/SettingsView.qml
    SOURCES
        connection/dbusclient.h connection/dbusclient.cpp
)

# Dashboard.Ui is the only UI library built by the client.
# epr_qt_widgets_large_lib is kept in the source tree as a reference only.
add_subdirectory(dashboard_ui)

if(DASHBOARD_UI_BUILD_TESTS)
    find_package(Qt6 REQUIRED COMPONENTS Test)
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
