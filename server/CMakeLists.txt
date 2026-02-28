cmake_minimum_required(VERSION 3.16)

project(server LANGUAGES CXX)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Core DBus LinguistTools)
#find_package(QT NAMES Qt6 Qt5 REQUIRED COMPONENTS Core DBus LinguistTools)
#find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS Core DBus LinguistTools)

set(TS_FILES server_it_IT.ts)

add_executable(appserver
  main.cpp
  ${TS_FILES}
  connection/dbusserver.h connection/dbusserver.cpp
  connection/dbusserver_interface.h connection/dbusserver_interface.cpp
  ${dbus_adaptor_SRCS}
  parameters/ParameterType.h
  parameters/Parameter.h parameters/Parameter.cpp
  parameters/ParameterValue.h
  parameters/ParameterLut.h
  parameters/ParameterManager.h parameters/ParameterManager.cpp
  dbus/ParameterManagerDBus.h dbus/ParameterManagerDBus.cpp
  dbus/parameters_adaptor.h dbus/parameters_adaptor.cpp
  dbus/ParameterDBus.h dbus/ParameterDBus.cpp
  parameters/ParameterLut.cpp
)

target_link_libraries(appserver
    Qt6::Core
    Qt6::DBus)

if(COMMAND qt_create_translation)
    qt_create_translation(QM_FILES ${CMAKE_SOURCE_DIR} ${TS_FILES})
else()
    qt5_create_translation(QM_FILES ${CMAKE_SOURCE_DIR} ${TS_FILES})
endif()

include(GNUInstallDirs)
install(TARGETS appserver
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
