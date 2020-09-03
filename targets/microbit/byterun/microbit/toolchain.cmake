set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR arm)

set(CMAKE_C_COMPILER "/usr/bin/arm-none-eabi-gcc")
set(CMAKE_ASM_COMPILER ${CMAKE_C_COMPILER})
set(CMAKE_CXX_COMPILER "/usr/bin/arm-none-eabi-g++")

add_compile_options(
  "-mcpu=cortex-m0"
  "-Os"
  "-fno-exceptions"
  "-fno-unwind-tables"
  "-ffunction-sections"
  "-fdata-sections"
)
add_link_options("--specs=nosys.specs")
