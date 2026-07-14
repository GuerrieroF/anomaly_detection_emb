cmake_minimum_required(VERSION 3.16)

project(anomaly_detection_emb VERSION 0.1 LANGUAGES CXX)
set(CMAKE_AUTOMOC ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

set(CMAKE_FIND_PACKAGE_PREFER_CONFIG ON)

set(QT_COMPONENTS
    Core
    Gui
    Qml
    Quick
    DBus
    SerialPort
    LinguistTools
)

if(DEFINED Qt6_DIR)
    get_filename_component(QT6_CMAKE_DIR "${Qt6_DIR}/.." ABSOLUTE)

    foreach(QT_COMPONENT IN LISTS QT_COMPONENTS)
        set(QT_COMPONENT_DIR_VARIABLE "Qt6${QT_COMPONENT}_DIR")
        if(DEFINED ${QT_COMPONENT_DIR_VARIABLE})
            get_filename_component(QT_COMPONENT_DIR "${${QT_COMPONENT_DIR_VARIABLE}}" ABSOLUTE)
            string(FIND "${QT_COMPONENT_DIR}" "${QT6_CMAKE_DIR}/" QT_COMPONENT_DIR_INDEX)

            if(NOT QT_COMPONENT_DIR_INDEX EQUAL 0)
                message(STATUS "Clearing stale ${QT_COMPONENT_DIR_VARIABLE}: ${QT_COMPONENT_DIR}")
                unset(${QT_COMPONENT_DIR_VARIABLE} CACHE)
            endif()
        endif()
    endforeach()
endif()

find_package(Qt6 REQUIRED COMPONENTS ${QT_COMPONENTS})

qt_standard_project_setup(REQUIRES 6.5)

add_subdirectory(client)
add_subdirectory(server)
