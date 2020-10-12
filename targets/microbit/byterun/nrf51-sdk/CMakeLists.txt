cmake_minimum_required(VERSION 2.8.12)

project(nrf51-sdk)

file(GLOB NRF51_C_FILES
  "source/ble/ble_radio_notification/*.c"
  "source/ble/ble_services/ble_dfu/*.c"
  "source/ble/common/*.c"
  "source/ble/device_manager/*.c"
  "source/ble/peer_manager/*.c"

  "source/drivers_nrf/ble_flash/*.c"
  "source/drivers_nrf/delay/*.c"
  "source/drivers_nrf/hal/*.c"
  "source/drivers_nrf/pstorage/*.c"

  "source/libraries/bootloader_dfu/*.c"
  "source/libraries/crc16/*.c"
  "source/libraries/fds/*.c"
  "source/libraries/fstorage/*.c"
  "source/libraries/hci/*.c"
  "source/libraries/scheduler/*.c"
  "source/libraries/util/*.c"

  "source/softdevice/common/softdevice_handler/*.c"
)

include("include_headers.cmake")

# Link mbed-classic and include it's header
link_directories("../mbed-classic")
include("../mbed-classic/include_headers.cmake")

add_library(nrf51-sdk
  ${NRF51_C_FILES}
)

target_link_libraries(nrf51-sdk
  mbed-classic
)
