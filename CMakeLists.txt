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
swig_add_library(ctp4java
    TYPE SHARED
    LANGUAGE java
    OUTPUT_DIR ${CMAKE_CURRENT_SOURCE_DIR}/src/main/java
    SOURCES ${CMAKE_CURRENT_SOURCE_DIR}/swig/ctp.i
)

# Add include directories for SWIG target
target_include_directories(ctp4java PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/lib ${JNI_INCLUDE_DIRS})

# Add CTP library directories
link_directories(${CMAKE_CURRENT_SOURCE_DIR}/lib)

# Link CTP libraries
target_link_libraries(ctp4java PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/lib/thosttraderapi.lib
    ${CMAKE_CURRENT_SOURCE_DIR}/lib/thostmduserapi.lib
)

# Set Windows DLL output directory
set_target_properties(ctp4java PROPERTIES
    PREFIX ""
    SUFFIX ".dll"
    LIBRARY_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/target/lib"
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/target/lib"
)
