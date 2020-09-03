cmake_minimum_required(VERSION 2.8.12)

project(ble)

file(GLOB BLE_C_FILES
  "source/*.cpp"
  "source/service/*.cpp"
)

include("include_headers.cmake")


# Link mbed-classing and include it's headers
link_directories("../mbed-classic")
include("../mbed-classic/include_headers.cmake")

add_library(ble
  ${BLE_C_FILES}
)

target_link_libraries(ble
  mbed-classic
)
