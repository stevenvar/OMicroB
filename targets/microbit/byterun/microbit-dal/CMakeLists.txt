# This file is no longer auto-generated to make the repository builds with GCC
# and ARMCC no matter what.

cmake_minimum_required(VERSION 2.8.12)

enable_language(ASM)

file(GLOB MICROBIT-DAL_CPP_FILES
  "source/core/*.cpp"
  "source/types/*.cpp"
  "source/drivers/*.cpp"
  "source/bluetooth/*.cpp"
)

set(MICROBIT_DAL_VERSION_FLAGS "-DMICROBIT_DAL_VERSION=\\\"${MICROBIT_DAL_VERSION_STRING}\\\"")

set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${MICROBIT_DAL_VERSION_FLAGS}")

# Use the correct assembly file depending on 
if(CMAKE_COMPILER_IS_GNUCC)
  file(REMOVE "source/asm/CortexContextSwitch.s")
  configure_file("source/asm/CortexContextSwitch.s.gcc" "source/asm/CortexContextSwitch.s" COPYONLY)
else()
  file(REMOVE "source/asm/CortexContextSwitch.s")
  configure_file("source/asm/CortexContextSwitch.s.armcc" "source/asm/CortexContextSwitch.s" COPYONLY)
endif()

set(MICROBIT-DAL_S_FILES
    "source/asm/CortexContextSwitch.s"
)

include("include_headers.cmake")

add_library(microbit-dal
    ${MICROBIT-DAL_CPP_FILES}
    ${MICROBIT-DAL_S_FILES}
)

# Link the other libraries
link_directories("../mbed-classic")
link_directories("../nrf51-sdk")
link_directories("../ble")
link_directories("../ble-nrf51822")

# And include their headers
include("../mbed-classic/include_headers.cmake")
include("../nrf51-sdk/include_headers.cmake")
include("../ble/include_headers.cmake")
include("../ble-nrf51822/include_headers.cmake")

target_link_libraries(microbit-dal
    mbed-classic
    nrf51-sdk
    ble
    ble-nrf51822
)
