cmake_minimum_required(VERSION 3.10)
project(ctp4java)

# Set modern CMake policies for SWIG
cmake_policy(SET CMP0078 NEW)
cmake_policy(SET CMP0086 NEW)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Windows specific settings
if(WIN32)
    set(CMAKE_CXX_FLAGS_RELEASE "/MD /O2")
    set(CMAKE_CXX_FLAGS_DEBUG "/MDd /Zi /Ob0 /Od")
endif()

# Find SWIG
find_package(SWIG REQUIRED)
include(${SWIG_USE_FILE})

# Find Java
find_package(Java REQUIRED)
find_package(JNI REQUIRED)
include(UseJava)

# Include directories
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/lib)
include_directories(${JNI_INCLUDE_DIRS})

# SWIG options for Java (only use SWIG-specific flags)
set(CMAKE_SWIG_FLAGS "-I${CMAKE_CURRENT_SOURCE_DIR}/lib" "-I${CMAKE_CURRENT_SOURCE_DIR}/swig")
set_source_files_properties(${CMAKE_CURRENT_SOURCE_DIR}/swig/ctp.i PROPERTIES CPLUSPLUS ON)

# Create SWIG module for Java
# OUTPUT_DIR: where .java files go (must match Maven package com.yourpkg.ctp)
swig_add_library(ctp4java
    TYPE SHARED
    LANGUAGE java
    OUTPUT_DIR ${CMAKE_CURRENT_SOURCE_DIR}/src/main/java/com/yourpkg/ctp
    SOURCES ${CMAKE_CURRENT_SOURCE_DIR}/swig/ctp.i
)
# -package for Java package declaration
set_property(TARGET ctp4java PROPERTY SWIG_COMPILE_OPTIONS -package;com.yourpkg.ctp)

# Add include directories for SWIG target (swig/ 供生成的 cxx 中 #include "wrapper.h")
target_include_directories(ctp4java PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/lib
    ${CMAKE_CURRENT_SOURCE_DIR}/swig
    ${JNI_INCLUDE_DIRS}
)

# Add CTP library directories
link_directories(${CMAKE_CURRENT_SOURCE_DIR}/lib)

# Link CTP libraries (lib 目录下为 _se 版本) 与 JNI
target_link_libraries(ctp4java PRIVATE
    ${JNI_LIBRARIES}
    ${CMAKE_CURRENT_SOURCE_DIR}/lib/thosttraderapi_se.lib
    ${CMAKE_CURRENT_SOURCE_DIR}/lib/thostmduserapi_se.lib
)

# Set Windows DLL output directory
# OUTPUT_NAME "ctp" 与 %module ctp 对应，使 System.loadLibrary("ctp") 可加载 ctp.dll
set_target_properties(ctp4java PROPERTIES
    PREFIX ""
    SUFFIX ".dll"
    OUTPUT_NAME "ctp"
    LIBRARY_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/target/lib"
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/target/lib"
)
