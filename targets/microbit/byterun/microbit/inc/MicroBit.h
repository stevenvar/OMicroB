/*
The MIT License (MIT)

Copyright (c) 2016 British Broadcasting Corporation.
This software is provided by Lancaster University by arrangement with the BBC.

Permission is hereby granted, free of charge, to any person obtaining a
copy of this software and associated documentation files (the "Software"),
to deal in the Software without restriction, including without limitation
the rights to use, copy, modify, merge, publish, distribute, sublicense,
and/or sell copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
DEALINGS IN THE SOFTWARE.
*/

#ifndef MICROBIT_H
#define MICROBIT_H

#include "mbed.h"

#include "MicroBitConfig.h"
#include "MicroBitHeapAllocator.h"
#include "MicroBitDevice.h"
#include "ErrorNo.h"
#include "MicroBitSystemTimer.h"
#include "MicroBitCompat.h"
#include "MicroBitComponent.h"
#include "ManagedType.h"
#include "ManagedString.h"
#include "MicroBitImage.h"
#include "MicroBitFont.h"
#include "MicroBitEvent.h"
#include "DynamicPwm.h"
#include "MicroBitI2C.h"
#include "NotifyEvents.h"

#include "MicroBitButton.h"
#include "MicroBitPin.h"
#include "MicroBitCompass.h"
#include "MicroBitCompassCalibrator.h"
#include "MicroBitAccelerometer.h"
#include "MicroBitThermometer.h"
#include "MicroBitLightSensor.h"
#include "MicroBitMultiButton.h"

#include "MicroBitSerial.h"
#include "MicroBitIO.h"
#include "MicroBitMatrixMaps.h"
#include "MicroBitDisplay.h"

#include "MicroBitFiber.h"
#include "MicroBitMessageBus.h"

#include "MicroBitBLEManager.h"
#include "MicroBitRadio.h"
#include "MicroBitStorage.h"

// MicroBit::flags values
#define MICROBIT_INITIALIZED                    0x01

/**
  * Class definition for a MicroBit device.
  *
  * Represents the device as a whole, and includes member variables that represent various device drivers
  * used to control aspects of the micro:bit.
  */
class MicroBit
{
    private:

    /**
      * A listener to perform actions as a result of Message Bus reflection.
      *
      * In some cases we want to perform lazy instantiation of components, such as
      * the compass and the accelerometer, where we only want to add them to the idle
      * fiber when someone has the intention of using these components.
      */
    void                        onListenerRegisteredEvent(MicroBitEvent evt);

    uint8_t                     status;

    public:

    // Serial Interface
    MicroBitSerial              serial;

	// Reset Button
	InterruptIn     		    resetButton;

    // Persistent key value store
    MicroBitStorage             storage;

    // I2C Interface
    MicroBitI2C                 i2c;

    // Device level Message Bus abstraction
    MicroBitMessageBus          messageBus;

    // Member variables to represent each of the core components on the device.
    MicroBitDisplay             display;
    MicroBitButton              buttonA;
    MicroBitButton              buttonB;
    MicroBitMultiButton         buttonAB;
    MicroBitAccelerometer       &accelerometer;
    MicroBitCompass             &compass;
    MicroBitCompassCalibrator   compassCalibrator;
    MicroBitThermometer         thermometer;

    //An object of available IO pins on the device
    MicroBitIO                  io;

    // Bluetooth related member variables.
	MicroBitBLEManager		    bleManager;
    MicroBitRadio               radio;
    BLEDevice                   *ble;

    /**
      * Constructor.
      *
      * Create a representation of a MicroBit device, which includes member variables
      * that represent various device drivers used to control aspects of the micro:bit.
      */
    MicroBit();

    /**
      * Post constructor initialisation method.
      *
      * This call will initialised the scheduler, memory allocator and Bluetooth stack.
      *
      * This is required as the Bluetooth stack can't be brought up in a
      * static context i.e. in a constructor.
      *
      * @code
      * uBit.init();
      * @endcode
      *
      * @note This method must be called before user code utilises any functionality
      *       contained by uBit.
      */
    void init();

    /**
      * Return the friendly name for this device.
      *
      * @return A ManagedString representing the friendly name of this device.
      *
      * @code
      * ManagedString name = uBit.getName();
      * @endcode
      */
    static ManagedString getName();

    /**
      * Return the serial number of this device.
      *
      * @return A ManagedString representing the serial number of this device.
      *
      * @code
      * ManagedString serialNumber = uBit.getSerial();
      * @endcode
      */
    static ManagedString getSerial();

    /**
      * Will reset the micro:bit when called.
      *
      * @code
      * uBit.reset();
      * @endcode
      */
    void reset();

    /**
      * Delay execution for the given amount of time.
      *
      * If the scheduler is running, this will deschedule the current fiber and perform
      * a power efficient, concurrent sleep operation.
      *
      * If the scheduler is disabled or we're running in an interrupt context, this
      * will revert to a busy wait.
      *
      * Alternatively: wait, wait_ms, wait_us can be used which will perform a blocking sleep
      * operation.
      *
      * @param milliseconds the amount of time, in ms, to wait for. This number cannot be negative.
      *
      * @return MICROBIT_OK on success, MICROBIT_INVALID_PARAMETER milliseconds is less than zero.
      *
      * @code
      * uBit.sleep(20); //sleep for 20ms
      * @endcode
      *
      * @note This operation is currently limited by the rate of the system timer, therefore
      *       the granularity of the sleep operation is limited to 6 ms unless the rate of
      *       the system timer is modified.
      */
    void sleep(uint32_t milliseconds);

    /**
      * Seed the pseudo random number generator using the hardware random number generator.
      *
      * @code
      * uBit.seedRandom();
      * @endcode
      */
    void seedRandom();

    /**
      * Seed the pseudo random number generator using the given value.
      *
      * @param seed The 32-bit value to seed the generator with.
      *
      * @code
      * uBit.seedRandom(0xBB5EED);
      * @endcode
      */
    void seedRandom(uint32_t seed);


    /**
      * Generate a random number in the given range.
      * We use a simple Galois LFSR random number generator here,
      * as a Galois LFSR is sufficient for our applications, and much more lightweight
      * than the hardware random number generator built int the processor, which takes
      * a long time and uses a lot of energy.
      *
      * KIDS: You shouldn't use this in the real world to generate cryptographic keys though...
      * have a think why not. :-)
      *
      * @param max the upper range to generate a number for. This number cannot be negative.
      *
      * @return A random, natural number between 0 and the max-1. Or MICROBIT_INVALID_VALUE if max is <= 0.
      *
      * @code
      * uBit.random(200); //a number between 0 and 199
      * @endcode
      */
    int random(int max);

    /**
      * Determine the time since this MicroBit was last reset.
      *
      * @return The time since the last reset, in milliseconds.
      *
      * @note This will value overflow after 1.6 months.
      */
      //TODO: handle overflow case.
    unsigned long systemTime();

    /**
      * Determine the version of the micro:bit runtime currently in use.
      *
      * @return A textual description of the version of the micro:bit runtime that
      *         is currently running on this device.
      */
    const char *systemVersion();

    /**
      * Triggers a microbit panic where an loop will display a panic face
      * and the status code, if provided.
      *
      * This loop will continue for panic_timeout iterations, defaults to 0 (infinite).
      *
      * panic_timeout can be configured via a call to microbit_panic_timeout.
      *
      * @param statusCode the status code of the associated error.
      *
      * @code
      * microbit_panic_timeout(4);
      *
      * // will display loop for 4 iterations.
      * uBit.panic(10);
      * @endcode
      */
    void panic(int statusCode = 0);

    /**
      * Add a component to the array of system components. This component will then receive
      * periodic callbacks, once every tick period in interrupt context.
      *
      * @param component The component to add.
      *
      * @return MICROBIT_OK on success or MICROBIT_NO_RESOURCES if the component array is full.
      *
      * @code
      * // heap allocated - otherwise it will be paged out!
      * MicroBitDisplay* display = new MicroBitDisplay();
      *
      * uBit.addSystemComponent(display);
      * @endcode
      *
      * @note This interface is now deprecated, and will be removed in the next major release. Please use system_timer_add_component().
      */
	int addSystemComponent(MicroBitComponent *component);

    /**
      * Remove a component from the array of system components. This component will no longer receive
      * periodic callbacks.
      *
      * @param component The component to remove.
      *
      * @return MICROBIT_OK on success or MICROBIT_INVALID_PARAMETER is returned if the given component has not been previously added.
      *
      * @code
      * // heap allocated - otherwise it will be paged out!
      * MicroBitDisplay* display = new MicroBitDisplay();
      *
      * uBit.addSystemComponent(display);
      *
      * uBit.removeSystemComponent(display);
      * @endcode
      *
      * @note This interface is now deprecated, and will be removed in the next major release. Please use system_timer_remove_component().
      */
	int removeSystemComponent(MicroBitComponent *component);

    /**
      * Adds a component to the array of idle thread components, which are processed
      * when the run queue is empty.
      *
      * The system timer will poll isIdleCallbackNeeded on each component to determine
      * if the scheduler should schedule the idle_task imminently.
      *
      * @param component The component to add to the array.
      *
      * @return MICROBIT_OK on success or MICROBIT_NO_RESOURCES if the fiber components array is full.
      *
      * @code
      * MicroBitI2C i2c(I2C_SDA0, I2C_SCL0);
      *
      * // heap allocated - otherwise it will be paged out!
      * MicroBitAccelerometer* accelerometer = new MicroBitAccelerometer(i2c);
      *
      * fiber_add_idle_component(accelerometer);
      * @endcode
      *
      * @note This interface is now deprecated, and will be removed in the next major release. Please use fiber_add_idle_component().
      */
	int addIdleComponent(MicroBitComponent *component);

    /**
      * Remove a component from the array of idle thread components
      *
      * @param component The component to remove from the idle component array.
      *
      * @return MICROBIT_OK on success. MICROBIT_INVALID_PARAMETER is returned if the given component has not been previously added.
      *
      * @code
      * MicroBitI2C i2c(I2C_SDA0, I2C_SCL0);
      *
      * // heap allocated - otherwise it will be paged out!
      * MicroBitAccelerometer* accelerometer = new MicroBitAccelerometer(i2c);
      *
      * uBit.addIdleComponent(accelerometer);
      *
      * uBit.removeIdleComponent(accelerometer);
      * @endcode
      *
      * @note This interface is now deprecated, and will be removed in the next major release. Please use fiber_remove_idle_component().
      */
	int removeIdleComponent(MicroBitComponent *component);
};

/**
  * Return the friendly name for this device.
  *
  * @return A ManagedString representing the friendly name of this device.
  *
  * @code
  * ManagedString name = uBit.getName();
  * @endcode
  */
inline ManagedString MicroBit::getName()
{
    return ManagedString(microbit_friendly_name());
}

/**
  * Return the serial number of this device.
  *
  * @return A ManagedString representing the serial number of this device.
  *
  * @code
  * ManagedString serialNumber = uBit.getSerial();
  * @endcode
  */
inline ManagedString MicroBit::getSerial()
{
    // We take to 16 bit numbers here, as we want the full range of ID bits, but don't want negative numbers...
    int n1 = microbit_serial_number() & 0xffff;
    int n2 = (microbit_serial_number() >> 16) & 0xffff;

    // Simply concat the two numbers.
    ManagedString s1(n1);
    ManagedString s2(n2);

    return s1 + s2;
}

/**
  * Will reset the micro:bit when called.
  *
  * @code
  * uBit.reset();
  * @endcode
  */
inline void MicroBit::reset()
{
    if(ble && ble->getGapState().connected) {

        // We have a connected BLE peer. Disconnect the BLE session.
        ble->gap().disconnect(Gap::REMOTE_USER_TERMINATED_CONNECTION);

        // Wait a little while for the connection to drop.
        wait_ms(100);
    }

    microbit_reset();
}

/**
  * Delay execution for the given amount of time.
  *
  * If the scheduler is running, this will deschedule the current fiber and perform
  * a power efficient, concurrent sleep operation.
  *
  * If the scheduler is disabled or we're running in an interrupt context, this
  * will revert to a busy wait.
  *
  * Alternatively: wait, wait_ms, wait_us can be used which will perform a blocking sleep
  * operation.
  *
  * @param milliseconds the amount of time, in ms, to wait for. This number cannot be negative.
  *
  * @return MICROBIT_OK on success, MICROBIT_INVALID_PARAMETER milliseconds is less than zero.
  *
  * @code
  * uBit.sleep(20); //sleep for 20ms
  * @endcode
  *
  * @note This operation is currently limited by the rate of the system timer, therefore
  *       the granularity of the sleep operation is limited to 6 ms unless the rate of
  *       the system timer is modified.
  */
inline void MicroBit::sleep(uint32_t milliseconds)
{
    fiber_sleep(milliseconds);
}

/**
  * Generate a random number in the given range.
  * We use a simple Galois LFSR random number generator here,
  * as a Galois LFSR is sufficient for our applications, and much more lightweight
  * than the hardware random number generator built int the processor, which takes
  * a long time and uses a lot of energy.
  *
  * KIDS: You shouldn't use this is the real world to generate cryptographic keys though...
  * have a think why not. :-)
  *
  * @param max the upper range to generate a number for. This number cannot be negative.
  *
  * @return A random, natural number between 0 and the max-1. Or MICROBIT_INVALID_VALUE if max is <= 0.
  *
  * @code
  * uBit.random(200); //a number between 0 and 199
  * @endcode
  */
inline int MicroBit::random(int max)
{
    return microbit_random(max);
}

/**
  * Seed the pseudo random number generator using the hardware random number generator.
  *
  * @code
  * uBit.seedRandom();
  * @endcode
  */
inline void MicroBit::seedRandom()
{
    microbit_seed_random();
}


/**
  * Seed the pseudo random number generator using the given value.
  *
  * @param seed The 32-bit value to seed the generator with.
  *
  * @code
  * uBit.seedRandom(0xBB5EED);
  * @endcode
  */
inline void MicroBit::seedRandom(uint32_t seed)
{
    microbit_seed_random(seed);
}


/**
  * Add a component to the array of system components. This component will then receive
  * periodic callbacks, once every tick period in interrupt context.
  *
  * @param component The component to add.
  *
  * @return MICROBIT_OK on success or MICROBIT_NO_RESOURCES if the component array is full.
  *
  * @code
  * // heap allocated - otherwise it will be paged out!
  * MicroBitDisplay* display = new MicroBitDisplay();
  *
  * uBit.addSystemComponent(display);
  * @endcode
  *
  * @note This interface is now deprecated, and will be removed in the next major release. Please use system_timer_add_component().
  */
inline int MicroBit::addSystemComponent(MicroBitComponent *component)
{
	return system_timer_add_component(component);
}

/**
  * Remove a component from the array of system components. This component will no longer receive
  * periodic callbacks.
  *
  * @param component The component to remove.
  *
  * @return MICROBIT_OK on success or MICROBIT_INVALID_PARAMETER is returned if the given component has not been previously added.
  *
  * @code
  * // heap allocated - otherwise it will be paged out!
  * MicroBitDisplay* display = new MicroBitDisplay();
  *
  * uBit.addSystemComponent(display);
  *
  * uBit.removeSystemComponent(display);
  * @endcode
  *
  * @note This interface is now deprecated, and will be removed in the next major release. Please use system_timer_remove_component().
  */
inline int MicroBit::removeSystemComponent(MicroBitComponent *component)
{
	return system_timer_remove_component(component);
}

/**
  * Adds a component to the array of idle thread components, which are processed
  * when the run queue is empty.
  *
  * The system timer will poll isIdleCallbackNeeded on each component to determine
  * if the scheduler should schedule the idle_task imminently.
  *
  * @param component The component to add to the array.
  *
  * @return MICROBIT_OK on success or MICROBIT_NO_RESOURCES if the fiber components array is full.
  *
  * @code
  * MicroBitI2C i2c(I2C_SDA0, I2C_SCL0);
  *
  * // heap allocated - otherwise it will be paged out!
  * MicroBitAccelerometer* accelerometer = new MicroBitAccelerometer(i2c);
  *
  * fiber_add_idle_component(accelerometer);
  * @endcode
  *
  * @note This interface is now deprecated, and will be removed in the next major release. Please use fiber_add_idle_component().
  */
inline int MicroBit::addIdleComponent(MicroBitComponent *component)
{
	return fiber_add_idle_component(component);
}

/**
  * Remove a component from the array of idle thread components
  *
  * @param component The component to remove from the idle component array.
  *
  * @return MICROBIT_OK on success. MICROBIT_INVALID_PARAMETER is returned if the given component has not been previously added.
  *
  * @code
  * MicroBitI2C i2c(I2C_SDA0, I2C_SCL0);
  *
  * // heap allocated - otherwise it will be paged out!
  * MicroBitAccelerometer* accelerometer = new MicroBitAccelerometer(i2c);
  *
  * uBit.addIdleComponent(accelerometer);
  *
  * uBit.removeIdleComponent(accelerometer);
  * @endcode
  *
  * @note This interface is now deprecated, and will be removed in the next major release. Please use fiber_remove_idle_component().
  */
inline int MicroBit::removeIdleComponent(MicroBitComponent *component)
{
	return fiber_remove_idle_component(component);
}


/**
  * Determine the time since this MicroBit was last reset.
  *
  * @return The time since the last reset, in milliseconds.
  *
  * @note This will value overflow after 1.6 months.
  */
inline unsigned long MicroBit::systemTime()
{
    return system_timer_current_time();
}


/**
  * Determine the version of the micro:bit runtime currently in use.
  *
  * @return A textual description of the version of the micro:bit runtime that
  *         is currently running on this device.
  */
inline const char *MicroBit::systemVersion()
{
    return microbit_dal_version();
}

/**
  * Triggers a microbit panic where an loop will display a panic face
  * and the status code, if provided.
  *
  * This loop will continue for panic_timeout iterations, defaults to 0 (infinite).
  *
  * panic_timeout can be configured via a call to microbit_panic_timeout.
  *
  * @param statusCode the status code of the associated error.
  *
  * @code
  * microbit_panic_timeout(4);
  *
  * // will display loop for 4 iterations.
  * uBit.panic(10);
  * @endcode
  */
inline void MicroBit::panic(int statusCode)
{
    //show error and enter infinite while
	microbit_panic(statusCode);
}

#endif
