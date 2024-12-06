cmake_minimum_required(VERSION 3.21)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_OSX_ARCHITECTURES "arm64;x86_64")
set(CMAKE_CXX_VISIBILITY_PRESET hidden)

project(showcase VERSION 1.0.0)

file(GLOB_RECURSE SOURCES
    src/*.cpp
)

add_library(${PROJECT_NAME} SHARED ${SOURCES})

if (NOT DEFINED ENV{GEODE_SDK})
    message(FATAL_ERROR "Unable to find Geode SDK! Please define GEODE_SDK environment variable to point to Geode")
else()
    message(STATUS "Found Geode: $ENV{GEODE_SDK}")
endif()

add_subdirectory($ENV{GEODE_SDK} ${CMAKE_CURRENT_BINARY_DIR}/geode)

CPMAddPackage("gh:FireMario211/dashauth#main")
target_link_libraries(${PROJECT_NAME} DashAuth)

CPMAddPackage("gh:maxnut/GDReplayFormat#aa9438ab594056c86cae50efbd8c56b2f6a1093c")
target_link_libraries(${PROJECT_NAME} libGDR)

CPMAddPackage("gh:System-Glitch/SHA256#1de731e3762ccb9d50ddd3c8f86ccd36fdb51aad")
target_link_libraries(${PROJECT_NAME} sha256)

CPMAddPackage("gh:tobiaslocker/base64#387b32f337b83d358ac1ffe574e596ba99c41d31")
target_include_directories(${PROJECT_NAME} PRIVATE ${base64_SOURCE_DIR}/include)

# Set up dependencies, resources, and link Geode.
setup_geode_mod(${PROJECT_NAME})
