cmake_minimum_required(VERSION 3.21)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_OSX_ARCHITECTURES "arm64;x86_64")
set(CMAKE_CXX_VISIBILITY_PRESET hidden)

project(showcase VERSION 1.0.0)

file(GLOB_RECURSE SOURCES
    src/*.cpp
)

# add_compile_definitions(WITH_SOCKET)

add_library(${PROJECT_NAME} SHARED ${SOURCES})

if (NOT DEFINED ENV{GEODE_SDK})
    message(FATAL_ERROR "Unable to find Geode SDK! Please define GEODE_SDK environment variable to point to Geode")
else()
    message(STATUS "Found Geode: $ENV{GEODE_SDK}")
endif()

add_subdirectory($ENV{GEODE_SDK} ${CMAKE_CURRENT_BINARY_DIR}/geode)

CPMAddPackage("gh:maxnut/GDReplayFormat#638e72cf0e30f148d12b483f258626f5ee31f431")
target_link_libraries(${PROJECT_NAME} libGDR)

# Set up dependencies, resources, and link Geode.
setup_geode_mod(${PROJECT_NAME})
