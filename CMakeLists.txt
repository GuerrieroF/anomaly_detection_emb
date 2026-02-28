cmake_minimum_required(VERSION 3.16)

project(anomaly_detection_emb VERSION 0.1 LANGUAGES CXX)
set(CMAKE_AUTOMOC ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

find_package(Qt6 REQUIRED COMPONENTS Core Gui  Qml Quick DBus)

qt_standard_project_setup(REQUIRES 6.5)

add_subdirectory(client)
add_subdirectory(server)
