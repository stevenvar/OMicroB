CMAKE_OPTS = -DCMAKE_TOOLCHAIN_FILE:PATH="toolchain.cmake"

CPU = -mcpu=cortex-m0 -mthumb
CFLAGS = -O -g -Wall
CC = arm-none-eabi-g++

LIBS := mbed-classic/libmbed-classic.a \
        nrf51-sdk/libnrf51-sdk.a \
        ble/libble.a \
        ble-nrf51822/libble-nrf51822.a \
        microbit-dal/libmicrobit-dal.a \
        microbit/libmicrobit.a

INCLUDES :=\
	-Imbed-classic/api\
	-Imbed-classic/hal\
	-Imbed-classic/cmsis\
  -Inrf51-sdk/source/ble/ble_radio_notification\
  -Inrf51-sdk/source/ble/ble_services/ble_dfu\
  -Inrf51-sdk/source/ble/common\
	-Inrf51-sdk/source/ble/device_manager\
  -Inrf51-sdk/source/ble/device_manager/config\
	-Inrf51-sdk/source/ble/peer_manager\
  -Inrf51-sdk/source/device\
	-Inrf51-sdk/source/drivers_nrf/ble_flash\
  -Inrf51-sdk/source/drivers_nrf/delay\
	-Inrf51-sdk/source/drivers_nrf/hal\
  -Inrf51-sdk/source/drivers_nrf/pstorage\
	-Inrf51-sdk/source/drivers_nrf/pstorage/config\
  -Inrf51-sdk/source/libraries/bootloader_dfu\
	-Inrf51-sdk/source/libraries/bootloader_dfu/hci_transport\
  -Inrf51-sdk/source/libraries/crc16\
	-Inrf51-sdk/source/libraries/experimental_section_vars\
  -Inrf51-sdk/source/libraries/fds\
	-Inrf51-sdk/source/libraries/fstorage\
  -Inrf51-sdk/source/libraries/hci\
	-Inrf51-sdk/source/libraries/scheduler\
  -Inrf51-sdk/source/libraries/timer\
	-Inrf51-sdk/source/libraries/util\
  -Inrf51-sdk/source/softdevice/common/softdevice_handler\
	-Inrf51-sdk/source/softdevice/s130/headers\
  -Ible\
	-Ible/ble\
	-Ible/ble/services\
  -Ible-nrf51822/source\
	-Ible-nrf51822/source/common\
  -Ible-nrf51822/source/btle\
	-Ible-nrf51822/source/btle/custom\
  -Imicrobit-dal/inc/core\
	-Imicrobit-dal/inc/types\
	-Imicrobit-dal/inc/drivers\
  -Imicrobit-dal/inc/bluetooth\
	-Imicrobit-dal/inc/platform\
  -Imicrobit/inc
all: $(LIBS) microbitlib.o

mbed-classic/libmbed-classic.a:
	cmake -S mbed-classic -B mbed-classic ${CMAKE_OPTS}
	make -C mbed-classic

nrf51-sdk/libnrf51-sdk.a:
	cmake -S nrf51-sdk -B nrf51-sdk ${CMAKE_OPTS}
	make -C nrf51-sdk

ble/libble.a:
	cmake -S ble -B ble ${CMAKE_OPTS}
	make -C ble

ble-nrf51822/libble-nrf51822.a:
	cmake -S ble-nrf51822 -B ble-nrf51822 ${CMAKE_OPTS}
	make -C ble-nrf51822

microbit-dal/libmicrobit-dal.a:
	cmake -S microbit-dal -B microbit-dal ${CMAKE_OPTS}
	make -C microbit-dal

microbit/libmicrobit.a:
	cmake -S microbit -B microbit ${CMAKE_OPTS}
	make -C microbit

microbitlib.o: microbitlib.cpp
	$(CC) $(CPU) $(CFLAGS) $(INCLUDES) -c $< -o $@

clean:
	make -C mbed-classic clean
	make -C nrf51-sdk clean
	make -C ble clean
	make -C ble-nrf51822 clean
	make -C microbit-dal clean
	make -C microbit clean
