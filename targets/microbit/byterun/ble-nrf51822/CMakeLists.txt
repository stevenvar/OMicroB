cmake_minimum_required(VERSION 2.8.12)

project(ble-nrf51822)

file(GLOB BLE-NRF51822_CPP_FILES
  "source/*.cpp"
  "source/btle/*.cpp"
  "source/btle/custom/*.cpp"
)

include("include_headers.cmake")

# Link the librairies
link_directories("../mbed-classic")
link_directories("../ble")
link_directories("../nrf51-sdk")

# And include their headers
include("../mbed-classic/include_headers.cmake")
include("../ble/include_headers.cmake")
include("../nrf51-sdk/include_headers.cmake")

add_library(ble-nrf51822
  ${BLE-NRF51822_CPP_FILES}
  "bootloader/s110_nrf51822_8.0.0_bootloader.hex"
)

target_link_libraries(ble-nrf51822
  mbed-classic
  nrf51-sdk
  ble
)
