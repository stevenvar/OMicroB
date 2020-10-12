cmake_minimum_required(VERSION 2.8.12)

project(microbit)

file(GLOB MICROBIT_CPP_FILES "source/*.cpp")

include("include_headers.cmake")

# Link all of the libraries
link_directories("../mbed-classic")
link_directories("../nrf51-sdk")
link_directories("../ble")
link_directories("../ble-nrf51822")
link_directories("../microbit-dal")

# And include their headers
include("../mbed-classic/include_headers.cmake")
include("../nrf51-sdk/include_headers.cmake")
include("../ble/include_headers.cmake")
include("../ble-nrf51822/include_headers.cmake")
include("../microbit-dal/include_headers.cmake")

add_library(microbit
  ${MICROBIT_CPP_FILES}
)

target_link_libraries(microbit
  microbit-dal
)
