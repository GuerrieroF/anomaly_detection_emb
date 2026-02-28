cmake_minimum_required(VERSION 3.16)

project(client VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick DBus Core)

qt_standard_project_setup(REQUIRES 6.5)

qt6_generate_dbus_interface(client_dbus_iface
    ../dbusinterfaces/com.example.DBusInterface.xml
)

qt_add_executable(appclient
    main.cpp
    ${client_dbus_iface}
)

qt_add_qml_module(appclient
    URI client
    VERSION 1.0
    QML_FILES
        Main.qml
    SOURCES
        connection/dbusclient.h connection/dbusclient.cpp
)

add_subdirectory(epr_qt_widgets_large_lib)

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
            epr_qt_widgets_large_lib
)

include(GNUInstallDirs)
install(TARGETS appclient
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
