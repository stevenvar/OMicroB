#
# mbed-2 yotta-compatible build system
#

cmake_minimum_required(VERSION 2.8.12)

# make sure necessary features are enabled:
project(mbed-classic)
enable_language(ASM)

# override compilation flags:
if(CMAKE_C_COMPILER_ID MATCHES GNU)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -std=gnu99")
endif()

# the mbed.a library is built from two sets of source files + include
# directories:
#
# MBED_COMMON_SOURCES: the source files that are the same for all targets,
# these are easily found by globbing:
#
file(GLOB MBED_COMMON_SOURCES
  "common/*.cpp" "common/*.c"
  "cmsis/*.c" "cmsis/*.cpp" "cmsis/*.s" "cmsis/*.S"
  "hal/*.c" "hal/*.cpp"
)
#
# (always include the hal header directory, too)
set(MBED_COMMON_INCLUDE_DIRS "api")
set(MBED_TARGET_INCLUDE_DIRS "hal" "cmsis")

# finally, we can construct a library using the determined set of include paths
# + source files. Note that the library name must match the name of the yotta
# module (defined in module.json) for this module to link properly with other
# yotta modules.
include_directories(${MBED_COMMON_INCLUDE_DIRS})
include_directories(${MBED_TARGET_INCLUDE_DIRS})
add_library(mbed-classic
    ${MBED_COMMON_SOURCES}
    ${MBED_TARGET_SOURCES}
)
if(CMAKE_COMPILER_IS_GNUCC)
    target_link_libraries(mbed-classic
        -lnosys
    )
endif()
