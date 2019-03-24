/*
 * Copyright (c) 2017, Majenko Technologies
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 * this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * 3. Neither the name of Majenko Technologies nor the names of its contributors
 * may be used to endorse or promote products derived from this software without
 * specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#ifndef _USB_H
#define _USB_H

#include "pins_arduino.h"
#if defined(_USB)

#include "Print.h"
#include "Stream.h"
#include "wiring.h"

#define USB_TX_TIMEOUT 75

struct bdt
{
        uint32_t flags;
        uint8_t *buffer;
} __attribute__((packed));  // 512 byte aligned in buffer

struct epBuffer {
	uint8_t *rx[2];
	uint8_t *tx[2];
	uint8_t data;
	uint8_t txAB;
    uint32_t size;
    uint32_t length;
    uint8_t *buffer;
    uint8_t *bufferPtr;
};

struct DeviceDescriptor {
    uint8_t     bLength;
    uint8_t     bDescriptorType;
    uint16_t    bcdUSB;
    uint8_t     bDeviceClass;
    uint8_t     bDeviceSubClass;
    uint8_t     bDeviceProtocol;
    uint8_t     bMaxPacketSize;
    uint16_t    idVendor;
    uint16_t    idProduct;
    uint16_t    bcdDevice;
    uint8_t     iManufacturer;
    uint8_t     iProduct;
    uint8_t     iSerialNumber;
    uint8_t     bNumConfigurations;
} __attribute__((packed));

struct ConfigurationDescriptor {
    uint8_t     bLength;
    uint8_t     bDescriptorType;
    uint16_t    wTotalLength;
    uint8_t     bNumInterfaces;
    uint8_t     bConfigurationValue;
    uint8_t     iConfiguration;
    uint8_t     bmAttributes;
    uint8_t     bMaxPower;
} __attribute__((packed));

struct InterfaceDescriptor {
    uint8_t     bLength;
    uint8_t     bDescriptorType;
    uint8_t     bInterfaceNumber;
    uint8_t     bAlternateSetting;
    uint8_t     bNumEndpoints;
    uint8_t     bInterfaceClass;
    uint8_t     bInterfaceSubClass;
    uint8_t     bInterfaceProtocol;
    uint8_t     iInterface;
} __attribute__((packed));

struct StringDescriptorHeader {
    uint8_t     bLength;
    uint8_t     bDescriptorType;
    uint16_t    wLANGID;
} __attribute__((packed));

#define EP_IN 0
#define EP_OUT 1

#define EP_CTL 0
#define EP_INT 1
#define EP_BLK 2
#define EP_ISO 3

class USBManager;
class USBDevice;

class USBDriver {
	public:
		USBDriver() {}
		virtual bool enableUSB() = 0;       // Turn on and configure USB
		virtual bool disableUSB() = 0;      // Turn off USB
		virtual bool addEndpoint(uint8_t id, uint8_t direction, uint8_t type, uint32_t size, uint8_t *a, uint8_t *b) = 0;    // Add an endpoint
		virtual bool enqueuePacket(uint8_t ep, const uint8_t *data, uint32_t len) = 0;  // Queue a single packet on an endpoint
        virtual bool canEnqueuePacket(uint8_t ep) = 0;  // True if a packet can be enqueued
        virtual bool sendBuffer(uint8_t ep, const uint8_t *data, uint32_t len) = 0; // Send an entire buffer through and endpoint
		virtual bool setAddress(uint8_t address) = 0;   // Set the device address
        virtual void setManager(USBManager *mgr) {  // Add the manager object to this driver.
            _manager = mgr;
        }

        virtual bool isHighSpeed() = 0;
        virtual void haltEndpoint(uint8_t ep) = 0;
        virtual void resumeEndpoint(uint8_t ep) = 0;

        virtual bool isIdle(uint8_t ep) = 0;
        virtual int populateDefaultSerial(char *defSerial) = 0;

        virtual void resume() = 0;


        USBManager *_manager;
};
#ifdef __PIC32MX__
class USBFS : public USBDriver {
	private:
		static __USER_ISR void _usbInterrupt() {
			_this->handleInterrupt();
		}
		static USBFS *_this;
		uint32_t _enabledEndpoints;
		struct epBuffer _endpointBuffers[16];

        uint8_t _ctlRxA[64];
        uint8_t _ctlRxB[64];
        uint8_t _ctlTxA[64];
        uint8_t _ctlTxB[64];

        volatile bool _inIsr;

	public:
		USBFS() : _enabledEndpoints(0), _inIsr(false) { _this = this; }
		bool enableUSB();
		bool disableUSB();
		bool addEndpoint(uint8_t id, uint8_t direction, uint8_t type, uint32_t size, uint8_t *a, uint8_t *b);
		bool enqueuePacket(uint8_t ep, const uint8_t *data, uint32_t len);
		bool setAddress(uint8_t address);
        bool canEnqueuePacket(uint8_t ep);
        bool sendBuffer(uint8_t ep, const uint8_t *data, uint32_t len);

        bool isHighSpeed() { return false; }

        void haltEndpoint(uint8_t __attribute__((unused)) ep) {}
        void resumeEndpoint(uint8_t __attribute__((unused)) ep) {}

		void handleInterrupt();

        bool isIdle(uint8_t ep);
        int populateDefaultSerial(char *defSerial);

        void resume();

		__attribute__ ((aligned(512))) volatile struct bdt _bufferDescriptorTable[16][4];

        using USBDriver::_manager;

};
#endif

#ifdef __PIC32MZ__
class USBFS;
class USBHS : public USBDriver {
	protected:
		static __USER_ISR void _usbInterrupt() {
			_this->handleInterrupt();
		}
		static USBHS *_this;
        uint32_t _fifoOffset;
		uint32_t _enabledEndpoints;
		struct epBuffer _endpointBuffers[16];

        uint8_t _ctlRxA[64];
        uint8_t _ctlRxB[64];
        uint8_t _ctlTxA[64];
        uint8_t _ctlTxB[64];

        volatile bool _inIsr;

	public:
		USBHS() : _fifoOffset(8), _enabledEndpoints(0), _inIsr(false) { _this = this; }
		virtual bool enableUSB();
        virtual bool isHighSpeed() { return true; }
		bool disableUSB();
		bool addEndpoint(uint8_t id, uint8_t direction, uint8_t type, uint32_t size, uint8_t *a, uint8_t *b);
		bool enqueuePacket(uint8_t ep, const uint8_t *data, uint32_t len);
		bool setAddress(uint8_t address);
        bool canEnqueuePacket(uint8_t ep);
        bool sendBuffer(uint8_t ep, const uint8_t *data, uint32_t len);
        int populateDefaultSerial(char *defSerial);


		void handleInterrupt();

        void haltEndpoint(uint8_t ep);
        void resumeEndpoint(uint8_t ep);
        bool isIdle(uint8_t ep);

        void resume();

        using USBDriver::_manager;

        friend USBFS;

};

class USBFS : public USBHS {
    public:
        bool enableUSB();
        bool isHighSpeed() { return false; }
};
#endif

struct USBDeviceList {
    USBDevice *device;
    struct USBDeviceList *next;
};

class USBManager {
	protected:
		// Private functions and variables here
        USBDriver *_driver;
        uint8_t _wantedAddress;
        USBDeviceList *_devices;
        uint16_t _vid;
        uint16_t _pid;
        uint8_t _ifCount;
        uint8_t _epCount;
        uint8_t _stringCount;
        uint8_t _target;

        const char *_manufacturer;
        const char *_product;
        const char *_serial;
        uint32_t _serialLen;
        char _defSerial[16];

        bool _enumerated;

        uint8_t _deviceAttributes;
        uint8_t _devicePower;

	public:
        void onSetupPacket(uint8_t ep, uint8_t *data, uint32_t l);
        void onInPacket(uint8_t ep, uint8_t *data, uint32_t l);
        void onOutPacket(uint8_t ep, uint8_t *data, uint32_t l);

        bool isEnumerated();
        void setEnumerated(bool e) { _enumerated = e; }

        bool isHighSpeed() { return _driver->isHighSpeed(); }

		USBManager(USBDriver *driver, uint16_t vid, uint16_t pid, const char *mfg = "chipKIT", const char *prod = _BOARD_NAME_, const char *ser = NULL);
		USBManager(USBDriver &driver, uint16_t vid, uint16_t pid, const char *mfg = "chipKIT", const char *prod = _BOARD_NAME_, const char *ser = NULL) :
            USBManager(&driver, vid, pid, mfg, prod, ser) {}
//		USBManager(USBDriver *driver, uint16_t vid, uint16_t pid);
//		USBManager(USBDriver &driver, uint16_t vid, uint16_t pid);

        void begin();
        void addDevice(USBDevice *d);
        void addDevice(USBDevice &d) { addDevice(&d); }

        uint8_t allocateInterface();
        uint8_t allocateEndpoint();
        uint8_t allocateString();

        bool addEndpoint(uint8_t id, uint8_t direction, uint8_t type, uint32_t size, uint8_t *a, uint8_t *b) {
            return _driver->addEndpoint(id, direction, type, size, a, b);
        }

        bool sendBuffer(uint8_t ep, const uint8_t *data, uint32_t len) {
            if (_enumerated) {
                return _driver->sendBuffer(ep, data, len);
            }
            return true; // Honest, guv, we sent it!
        }

        bool canEnqueuePacket(uint8_t ep) {
            if (_enumerated) {
                return _driver->canEnqueuePacket(ep);
            }
            return true; // Sure, guv, you can send it... honest...
        }

		bool enqueuePacket(uint8_t ep, const uint8_t *data, uint32_t len) {
            if (_enumerated) {
                return _driver->enqueuePacket(ep, data, len);
            }
            return true; // Honest, guv, we sent it!
        }

        void haltEndpoint(uint8_t ep) {
            _driver->haltEndpoint(ep);
        }

        void resumeEndpoint(uint8_t ep) {
            _driver->resumeEndpoint(ep);
        }

        bool isIdle(uint8_t ep) {
            return _driver->isIdle(ep);
        }

        void end();

        void setSelfPowered() {
            _deviceAttributes &= 0x7F;
        }

        void setBusPowered() {
            _deviceAttributes |= 0x80;
        }

        void setPowerLimit(int power) {
            if (power < 0) power = 0;
            if (power > 500) power = 500;
            _devicePower = power / 2;
        }

        void resume() {
            _driver->resume();
        }

};

class USBDevice {
    public:
        virtual uint16_t getDescriptorLength() = 0; // Returns the length of the config descriptor block
        virtual uint8_t getInterfaceCount() = 0;    // Returns the number of interfaces for this device
        virtual bool getStringDescriptor(uint8_t idx, uint16_t maxlen) = 0; // Send a string descriptor matching this index
        virtual uint32_t populateConfigurationDescriptor(uint8_t *buf) = 0; // Fills *buf with the config descriptor data. Returns the number of bytes used
        virtual void initDevice(USBManager *manager) = 0;   // Initialize a device and set the manager object

        virtual bool getDescriptor(uint8_t ep, uint8_t target, uint8_t id, uint8_t maxlen) = 0; // Called when GET_DESCRIPTOR arrives
        virtual bool getReportDescriptor(uint8_t ep, uint8_t target, uint8_t id, uint8_t maxlen) = 0;   // called when GET_REPORT_DESCRIPTOR arrives
        virtual void configureEndpoints() = 0;  // Configures all the endpoints for the device

        virtual bool onSetupPacket(uint8_t ep, uint8_t target, uint8_t *data, uint32_t l) = 0;  // Called when a SETUP packet arrives
        virtual bool onInPacket(uint8_t ep, uint8_t target, uint8_t *data, uint32_t l) = 0; // Called when an IN packet is requested
        virtual bool onOutPacket(uint8_t ep, uint8_t target, uint8_t *data, uint32_t l) = 0;    // Called when an OUT packet arrives
        virtual void onEnumerated() = 0; // Called when enumeration is finished and the device is attached
};

class CDCACM : public USBDevice, public Stream {
    private:
        USBManager *_manager;
        uint8_t _ifControl;
        uint8_t _ifBulk;
        uint8_t _epControl;
        uint8_t _epBulk;
        uint8_t _outAction;

        uint8_t _lineState;
        uint32_t _baud;
        uint32_t _previousBaud;
        uint8_t _stopBits;
        uint8_t _dataBits;
        uint8_t _parity;
#if defined (__PIC32MX__)
#define CDCACM_BUFFER_SIZE 256
#define CDCACM_BULKEP_SIZE 64
        uint8_t _rxBuffer[CDCACM_BUFFER_SIZE];
        uint8_t _txBuffer[CDCACM_BUFFER_SIZE];
        uint8_t _bulkRxA[CDCACM_BULKEP_SIZE];
        uint8_t _bulkRxB[CDCACM_BULKEP_SIZE];
        uint8_t _bulkTxA[CDCACM_BULKEP_SIZE];
        uint8_t _bulkTxB[CDCACM_BULKEP_SIZE];
#define CDCACM_BUFFER_HIGH 4
#elif defined(__PIC32MZ__)
#define CDCACM_BUFFER_SIZE 256
#define CDCACM_BULKEP_SIZE 512
        uint8_t _rxBuffer[CDCACM_BUFFER_SIZE];
        uint8_t _txBuffer[CDCACM_BUFFER_SIZE];
        uint8_t _bulkRxA[CDCACM_BULKEP_SIZE];
        uint8_t _bulkRxB[CDCACM_BULKEP_SIZE];
        uint8_t _bulkTxA[CDCACM_BULKEP_SIZE];
        uint8_t _bulkTxB[CDCACM_BULKEP_SIZE];
#define CDCACM_BUFFER_HIGH 8
#endif
        volatile uint32_t _txHead;
        volatile uint32_t _txTail;
        volatile uint32_t _rxHead;
        volatile uint32_t _rxTail;

        uint8_t _ctlA[8];
        uint8_t _ctlB[8];

    public:
        CDCACM() : _txHead(0), _txTail(0), _rxHead(0), _rxTail(0) {}

        operator int();
        uint16_t getDescriptorLength();
        uint8_t getInterfaceCount();
        uint32_t populateConfigurationDescriptor(uint8_t *buf);
        void initDevice(USBManager *manager);
        bool getDescriptor(uint8_t ep, uint8_t target, uint8_t id, uint8_t maxlen);
        bool getReportDescriptor(uint8_t __attribute__((unused)) ep, uint8_t __attribute__((unused)) target, uint8_t __attribute__((unused)) id, uint8_t __attribute__((unused)) maxlen)  { return false; }
        bool getStringDescriptor(uint8_t __attribute__((unused)) idx, uint16_t __attribute__((unused)) maxlen) { return false; }
        void configureEndpoints();

        bool onSetupPacket(uint8_t ep, uint8_t target, uint8_t *data, uint32_t l);
        bool onInPacket(uint8_t ep, uint8_t target, uint8_t *data, uint32_t l);
        bool onOutPacket(uint8_t ep, uint8_t target, uint8_t *data, uint32_t l);
        void onEnumerated();

        int getLineState() { return _lineState; }
        uint32_t getBaud() { return _baud; }
        bool getDTR() { return ((_lineState & 0x01) == 0x01); }
        bool getRTS() { return ((_lineState & 0x02) == 0x02); }

        size_t write(uint8_t);
        size_t write(const uint8_t *b, size_t len);

        int available();
        int read();
        int peek();
        void flush();
        void begin() {}
        void begin(uint32_t __attribute__((unused)) baud) {}
        void end() {}

        int availableForWrite();
};

// Raw keys - give you direct access to every button.

#define KEY_RAW_MOD_LCTRL  0x01
#define KEY_RAW_MOD_LSHIFT 0x02
#define KEY_RAW_MOD_LALT   0x04
#define KEY_RAW_MOD_LMETA  0x08
#define KEY_RAW_MOD_RCTRL  0x10
#define KEY_RAW_MOD_RSHIFT 0x20
#define KEY_RAW_MOD_RALT   0x40
#define KEY_RAW_MOD_RMETA  0x80

#define KEY_RAW_NONE 0x00 // No key pressed
#define KEY_RAW_ERR_OVF 0x01 //  Keyboard Error Roll Over - used for all slots if too many keys are pressed ("Phantom key")
// 0x02 //  Keyboard POST Fail
// 0x03 //  Keyboard Error Undefined
#define KEY_RAW_A 0x04 // Keyboard a and A
#define KEY_RAW_B 0x05 // Keyboard b and B
#define KEY_RAW_C 0x06 // Keyboard c and C
#define KEY_RAW_D 0x07 // Keyboard d and D
#define KEY_RAW_E 0x08 // Keyboard e and E
#define KEY_RAW_F 0x09 // Keyboard f and F
#define KEY_RAW_G 0x0a // Keyboard g and G
#define KEY_RAW_H 0x0b // Keyboard h and H
#define KEY_RAW_I 0x0c // Keyboard i and I
#define KEY_RAW_J 0x0d // Keyboard j and J
#define KEY_RAW_K 0x0e // Keyboard k and K
#define KEY_RAW_L 0x0f // Keyboard l and L
#define KEY_RAW_M 0x10 // Keyboard m and M
#define KEY_RAW_N 0x11 // Keyboard n and N
#define KEY_RAW_O 0x12 // Keyboard o and O
#define KEY_RAW_P 0x13 // Keyboard p and P
#define KEY_RAW_Q 0x14 // Keyboard q and Q
#define KEY_RAW_R 0x15 // Keyboard r and R
#define KEY_RAW_S 0x16 // Keyboard s and S
#define KEY_RAW_T 0x17 // Keyboard t and T
#define KEY_RAW_U 0x18 // Keyboard u and U
#define KEY_RAW_V 0x19 // Keyboard v and V
#define KEY_RAW_W 0x1a // Keyboard w and W
#define KEY_RAW_X 0x1b // Keyboard x and X
#define KEY_RAW_Y 0x1c // Keyboard y and Y
#define KEY_RAW_Z 0x1d // Keyboard z and Z

#define KEY_RAW_1 0x1e // Keyboard 1 and !
#define KEY_RAW_2 0x1f // Keyboard 2 and @
#define KEY_RAW_3 0x20 // Keyboard 3 and #
#define KEY_RAW_4 0x21 // Keyboard 4 and $
#define KEY_RAW_5 0x22 // Keyboard 5 and %
#define KEY_RAW_6 0x23 // Keyboard 6 and ^
#define KEY_RAW_7 0x24 // Keyboard 7 and &
#define KEY_RAW_8 0x25 // Keyboard 8 and *
#define KEY_RAW_9 0x26 // Keyboard 9 and (
#define KEY_RAW_0 0x27 // Keyboard 0 and )

#define KEY_RAW_ENTER 0x28 // Keyboard Return (ENTER)
#define KEY_RAW_ESC 0x29 // Keyboard ESCAPE
#define KEY_RAW_BACKSPACE 0x2a // Keyboard DELETE (Backspace)
#define KEY_RAW_TAB 0x2b // Keyboard Tab
#define KEY_RAW_SPACE 0x2c // Keyboard Spacebar
#define KEY_RAW_MINUS 0x2d // Keyboard - and _
#define KEY_RAW_EQUAL 0x2e // Keyboard = and +
#define KEY_RAW_LEFTBRACE 0x2f // Keyboard [ and {
#define KEY_RAW_RIGHTBRACE 0x30 // Keyboard ] and }
#define KEY_RAW_BACKSLASH 0x31 // Keyboard \ and |
#define KEY_RAW_HASHTILDE 0x32 // Keyboard Non-US # and ~
#define KEY_RAW_SEMICOLON 0x33 // Keyboard ; and :
#define KEY_RAW_APOSTROPHE 0x34 // Keyboard ' and "
#define KEY_RAW_GRAVE 0x35 // Keyboard ` and ~
#define KEY_RAW_COMMA 0x36 // Keyboard , and <
#define KEY_RAW_DOT 0x37 // Keyboard . and >
#define KEY_RAW_SLASH 0x38 // Keyboard / and ?
#define KEY_RAW_CAPSLOCK 0x39 // Keyboard Caps Lock

#define KEY_RAW_F1 0x3a // Keyboard F1
#define KEY_RAW_F2 0x3b // Keyboard F2
#define KEY_RAW_F3 0x3c // Keyboard F3
#define KEY_RAW_F4 0x3d // Keyboard F4
#define KEY_RAW_F5 0x3e // Keyboard F5
#define KEY_RAW_F6 0x3f // Keyboard F6
#define KEY_RAW_F7 0x40 // Keyboard F7
#define KEY_RAW_F8 0x41 // Keyboard F8
#define KEY_RAW_F9 0x42 // Keyboard F9
#define KEY_RAW_F10 0x43 // Keyboard F10
#define KEY_RAW_F11 0x44 // Keyboard F11
#define KEY_RAW_F12 0x45 // Keyboard F12

#define KEY_RAW_SYSRQ 0x46 // Keyboard Print Screen
#define KEY_RAW_SCROLLLOCK 0x47 // Keyboard Scroll Lock
#define KEY_RAW_PAUSE 0x48 // Keyboard Pause
#define KEY_RAW_INSERT 0x49 // Keyboard Insert
#define KEY_RAW_HOME 0x4a // Keyboard Home
#define KEY_RAW_PAGEUP 0x4b // Keyboard Page Up
#define KEY_RAW_DELETE 0x4c // Keyboard Delete Forward
#define KEY_RAW_END 0x4d // Keyboard End
#define KEY_RAW_PAGEDOWN 0x4e // Keyboard Page Down
#define KEY_RAW_RIGHT 0x4f // Keyboard Right Arrow
#define KEY_RAW_LEFT 0x50 // Keyboard Left Arrow
#define KEY_RAW_DOWN 0x51 // Keyboard Down Arrow
#define KEY_RAW_UP 0x52 // Keyboard Up Arrow

#define KEY_RAW_NUMLOCK 0x53 // Keyboard Num Lock and Clear
#define KEY_RAW_KPSLASH 0x54 // Keypad /
#define KEY_RAW_KPASTERISK 0x55 // Keypad *
#define KEY_RAW_KPMINUS 0x56 // Keypad -
#define KEY_RAW_KPPLUS 0x57 // Keypad +
#define KEY_RAW_KPENTER 0x58 // Keypad ENTER
#define KEY_RAW_KP1 0x59 // Keypad 1 and End
#define KEY_RAW_KP2 0x5a // Keypad 2 and Down Arrow
#define KEY_RAW_KP3 0x5b // Keypad 3 and PageDn
#define KEY_RAW_KP4 0x5c // Keypad 4 and Left Arrow
#define KEY_RAW_KP5 0x5d // Keypad 5
#define KEY_RAW_KP6 0x5e // Keypad 6 and Right Arrow
#define KEY_RAW_KP7 0x5f // Keypad 7 and Home
#define KEY_RAW_KP8 0x60 // Keypad 8 and Up Arrow
#define KEY_RAW_KP9 0x61 // Keypad 9 and Page Up
#define KEY_RAW_KP0 0x62 // Keypad 0 and Insert
#define KEY_RAW_KPDOT 0x63 // Keypad . and Delete

#define KEY_RAW_102ND 0x64 // Keyboard Non-US \ and |
#define KEY_RAW_COMPOSE 0x65 // Keyboard Application
#define KEY_RAW_POWER 0x66 // Keyboard Power
#define KEY_RAW_KPEQUAL 0x67 // Keypad =

#define KEY_RAW_F13 0x68 // Keyboard F13
#define KEY_RAW_F14 0x69 // Keyboard F14
#define KEY_RAW_F15 0x6a // Keyboard F15
#define KEY_RAW_F16 0x6b // Keyboard F16
#define KEY_RAW_F17 0x6c // Keyboard F17
#define KEY_RAW_F18 0x6d // Keyboard F18
#define KEY_RAW_F19 0x6e // Keyboard F19
#define KEY_RAW_F20 0x6f // Keyboard F20
#define KEY_RAW_F21 0x70 // Keyboard F21
#define KEY_RAW_F22 0x71 // Keyboard F22
#define KEY_RAW_F23 0x72 // Keyboard F23
#define KEY_RAW_F24 0x73 // Keyboard F24

#define KEY_RAW_OPEN 0x74 // Keyboard Execute
#define KEY_RAW_HELP 0x75 // Keyboard Help
#define KEY_RAW_PROPS 0x76 // Keyboard Menu
#define KEY_RAW_FRONT 0x77 // Keyboard Select
#define KEY_RAW_STOP 0x78 // Keyboard Stop
#define KEY_RAW_AGAIN 0x79 // Keyboard Again
#define KEY_RAW_UNDO 0x7a // Keyboard Undo
#define KEY_RAW_CUT 0x7b // Keyboard Cut
#define KEY_RAW_COPY 0x7c // Keyboard Copy
#define KEY_RAW_PASTE 0x7d // Keyboard Paste
#define KEY_RAW_FIND 0x7e // Keyboard Find
#define KEY_RAW_MUTE 0x7f // Keyboard Mute
#define KEY_RAW_VOLUMEUP 0x80 // Keyboard Volume Up
#define KEY_RAW_VOLUMEDOWN 0x81 // Keyboard Volume Down
// 0x82  Keyboard Locking Caps Lock
// 0x83  Keyboard Locking Num Lock
// 0x84  Keyboard Locking Scroll Lock
#define KEY_RAW_KPCOMMA 0x85 // Keypad Comma
// 0x86  Keypad Equal Sign
#define KEY_RAW_RO 0x87 // Keyboard International1
#define KEY_RAW_KATAKANAHIRAGANA 0x88 // Keyboard International2
#define KEY_RAW_YEN 0x89 // Keyboard International3
#define KEY_RAW_HENKAN 0x8a // Keyboard International4
#define KEY_RAW_MUHENKAN 0x8b // Keyboard International5
#define KEY_RAW_KPJPCOMMA 0x8c // Keyboard International6
// 0x8d  Keyboard International7
// 0x8e  Keyboard International8
// 0x8f  Keyboard International9
#define KEY_RAW_HANGEUL 0x90 // Keyboard LANG1
#define KEY_RAW_HANJA 0x91 // Keyboard LANG2
#define KEY_RAW_KATAKANA 0x92 // Keyboard LANG3
#define KEY_RAW_HIRAGANA 0x93 // Keyboard LANG4
#define KEY_RAW_ZENKAKUHANKAKU 0x94 // Keyboard LANG5
// 0x95  Keyboard LANG6
// 0x96  Keyboard LANG7
// 0x97  Keyboard LANG8
// 0x98  Keyboard LANG9
// 0x99  Keyboard Alternate Erase
// 0x9a  Keyboard SysReq/Attention
// 0x9b  Keyboard Cancel
// 0x9c  Keyboard Clear
// 0x9d  Keyboard Prior
// 0x9e  Keyboard Return
// 0x9f  Keyboard Separator
// 0xa0  Keyboard Out
// 0xa1  Keyboard Oper
// 0xa2  Keyboard Clear/Again
// 0xa3  Keyboard CrSel/Props
// 0xa4  Keyboard ExSel

// 0xb0  Keypad 00
// 0xb1  Keypad 000
// 0xb2  Thousands Separator
// 0xb3  Decimal Separator
// 0xb4  Currency Unit
// 0xb5  Currency Sub-unit
#define KEY_RAW_KPLEFTPAREN 0xb6 // Keypad (
#define KEY_RAW_KPRIGHTPAREN 0xb7 // Keypad )
// 0xb8  Keypad {
// 0xb9  Keypad }
// 0xba  Keypad Tab
// 0xbb  Keypad Backspace
// 0xbc  Keypad A
// 0xbd  Keypad B
// 0xbe  Keypad C
// 0xbf  Keypad D
// 0xc0  Keypad E
// 0xc1  Keypad F
// 0xc2  Keypad XOR
// 0xc3  Keypad ^
// 0xc4  Keypad %
// 0xc5  Keypad <
// 0xc6  Keypad >
// 0xc7  Keypad &
// 0xc8  Keypad &&
// 0xc9  Keypad |
// 0xca  Keypad ||
// 0xcb  Keypad :
// 0xcc  Keypad #
// 0xcd  Keypad Space
// 0xce  Keypad @
// 0xcf  Keypad !
// 0xd0  Keypad Memory Store
// 0xd1  Keypad Memory Recall
// 0xd2  Keypad Memory Clear
// 0xd3  Keypad Memory Add
// 0xd4  Keypad Memory Subtract
// 0xd5  Keypad Memory Multiply
// 0xd6  Keypad Memory Divide
// 0xd7  Keypad +/-
// 0xd8  Keypad Clear
// 0xd9  Keypad Clear Entry
// 0xda  Keypad Binary
// 0xdb  Keypad Octal
// 0xdc  Keypad Decimal
// 0xdd  Keypad Hexadecimal

#define KEY_RAW_LEFTCTRL 0xe0 // Keyboard Left Control
#define KEY_RAW_LEFTSHIFT 0xe1 // Keyboard Left Shift
#define KEY_RAW_LEFTALT 0xe2 // Keyboard Left Alt
#define KEY_RAW_LEFTMETA 0xe3 // Keyboard Left GUI
#define KEY_RAW_RIGHTCTRL 0xe4 // Keyboard Right Control
#define KEY_RAW_RIGHTSHIFT 0xe5 // Keyboard Right Shift
#define KEY_RAW_RIGHTALT 0xe6 // Keyboard Right Alt
#define KEY_RAW_RIGHTMETA 0xe7 // Keyboard Right GUI

#define KEY_RAW_MEDIA_PLAYPAUSE 0xe8
#define KEY_RAW_MEDIA_STOPCD 0xe9
#define KEY_RAW_MEDIA_PREVIOUSSONG 0xea
#define KEY_RAW_MEDIA_NEXTSONG 0xeb
#define KEY_RAW_MEDIA_EJECTCD 0xec
#define KEY_RAW_MEDIA_VOLUMEUP 0xed
#define KEY_RAW_MEDIA_VOLUMEDOWN 0xee
#define KEY_RAW_MEDIA_MUTE 0xef
#define KEY_RAW_MEDIA_WWW 0xf0
#define KEY_RAW_MEDIA_BACK 0xf1
#define KEY_RAW_MEDIA_FORWARD 0xf2
#define KEY_RAW_MEDIA_STOP 0xf3
#define KEY_RAW_MEDIA_FIND 0xf4
#define KEY_RAW_MEDIA_SCROLLUP 0xf5
#define KEY_RAW_MEDIA_SCROLLDOWN 0xf6
#define KEY_RAW_MEDIA_EDIT 0xf7
#define KEY_RAW_MEDIA_SLEEP 0xf8
#define KEY_RAW_MEDIA_COFFEE 0xf9
#define KEY_RAW_MEDIA_REFRESH 0xfa
#define KEY_RAW_MEDIA_CALC 0xfb


// Arduino compatability keys

#define KEY_LEFT_CTRL       0x80
#define KEY_LEFT_SHIFT      0x81
#define KEY_LEFT_ALT        0x82
#define KEY_LEFT_GUI        0x83
#define KEY_RIGHT_CTRL      0x84
#define KEY_RIGHT_SHIFT     0x85
#define KEY_RIGHT_ALT       0x86
#define KEY_RIGHT_GUI       0x87

#define KEY_UP_ARROW        0xDA
#define KEY_DOWN_ARROW      0xD9
#define KEY_LEFT_ARROW      0xD8
#define KEY_RIGHT_ARROW     0xD7
#define KEY_BACKSPACE       0xB2
#define KEY_TAB             0xB3
#define KEY_RETURN          0xB0
#define KEY_ESC             0xB1
#define KEY_INSERT          0xD1
#define KEY_DELETE          0xD4
#define KEY_PAGE_UP         0xD3
#define KEY_PAGE_DOWN       0xD6
#define KEY_HOME            0xD2
#define KEY_END             0xD5
#define KEY_CAPS_LOCK       0xC1
#define KEY_F1              0xC2
#define KEY_F2              0xC3
#define KEY_F3              0xC4
#define KEY_F4              0xC5
#define KEY_F5              0xC6
#define KEY_F6              0xC7
#define KEY_F7              0xC8
#define KEY_F8              0xC9
#define KEY_F9              0xCA
#define KEY_F10             0xCB
#define KEY_F11             0xCC
#define KEY_F12             0xCD

#define COUNTRY_NOT_SUPPORTED       0
#define COUNTRY_ARABIC              1
#define COUNTRY_BELGIAN             2
#define COUNTRY_CANADIAN_BILINGUAL  3
#define COUNTRY_CANADIAN_FRENCH     4
#define COUNTRY_CZECH_REPUBLIC      5
#define COUNTRY_DANISH              6
#define COUNTRY_FINNISH             7
#define COUNTRY_FRENCH              8
#define COUNTRY_GERMAN              9
#define COUNTRY_GREEK               10
#define COUNTRY_HEBREW              11
#define COUNTRY_HUNGARY             12
#define COUNTRY_INTERNATIONAL       13
#define COUNTRY_ITALIAN             14
#define COUNTRY_JAPAN               15
#define COUNTRY_KOREAN              16
#define COUNTRY_LATIN_AMERICA       17
#define COUNTRY_NETHERLANDS         18
#define COUNTRY_NORWEGIAN           19
#define COUNTRY_PERSION             20
#define COUNTRY_POLAND              21
#define COUNTRY_PORTUGUESE          22
#define COUNTRY_RUSSIA              23
#define COUNTRY_SLOVAKIA            24
#define COUNTRY_SPANISH             25
#define COUNTRY_SWEDISH             26
#define COUNTRY_SWISS_FRENCH        27
#define COUNTRY_SWISS_GERMAN        28
#define COUNTRY_SWIZERLAND          29
#define COUNTRY_TAIWAN              30
#define COUNTRY_TURKISH_Q           31
#define COUNTRY_UK                  32
#define COUNTRY_US                  33
#define COUNTRY_YUGOSLAVIA          34
#define COUNTRY_TURKISH_F           35


struct KeyReport {
    uint8_t modifiers;
    uint8_t reserved;
    uint8_t keys[6];
} __attribute__((packed));

class HID_Keyboard : public USBDevice, public Print {
    private:
        USBManager *_manager;
        uint8_t _ifInt;
        uint8_t _epInt;
        struct KeyReport _keyReport;
        void sendReport(struct KeyReport *keys);
        uint8_t _intA[8];
        uint8_t _intB[8];
        uint8_t _countryCode;
        uint8_t _leds;

    public:
        HID_Keyboard() : _countryCode(0), _leds(0) {}
        HID_Keyboard(uint8_t cc) : _countryCode(cc), _leds(0) {}

        uint16_t getDescriptorLength();
        uint8_t getInterfaceCount();
        uint32_t populateConfigurationDescriptor(uint8_t *buf);
        void initDevice(USBManager *manager);
        bool getDescriptor(uint8_t ep, uint8_t target, uint8_t id, uint8_t maxlen);
        bool getReportDescriptor(uint8_t ep, uint8_t target, uint8_t id, uint8_t maxlen);
        bool getStringDescriptor(uint8_t __attribute__((unused)) idx, uint16_t __attribute__((unused)) maxlen)  { return false; }
        void configureEndpoints();

        bool onSetupPacket(uint8_t ep, uint8_t target, uint8_t *data, uint32_t l);
        bool onInPacket(uint8_t ep, uint8_t target, uint8_t *data, uint32_t l);
        bool onOutPacket(uint8_t ep, uint8_t target, uint8_t *data, uint32_t l);
        void onEnumerated();
        size_t write(uint8_t);

        size_t pressRawModifier(uint8_t key);
        size_t pressRaw(uint8_t key);
        size_t press(uint8_t key);
        size_t releaseRawModifier(uint8_t key);
        size_t releaseRaw(uint8_t key);
        size_t release(uint8_t key);
        void releaseAll();

        uint8_t getLEDs() { return _leds; }

        void begin(void) {};
        void end(void) {};
};

#define SYSTEM_POWERDOWN            0x0001
#define SYSTEM_SLEEP                0x0002
#define SYSTEM_WAKEUP               0x0004
#define SYSTEM_CONTEXT_MENU         0x0008
#define SYSTEM_MAIN_MENU            0x0010
#define SYSTEM_APP_MENU             0x0020
#define SYSTEM_HELP_MENU            0x0040
#define SYSTEM_MENU_EXIT            0x0080
#define SYSTEM_MENU_SELECT          0x0100
#define SYSTEM_MENU_RIGHT           0x0200
#define SYSTEM_MENU_LEFT            0x0400
#define SYSTEM_MENU_UP              0x0800
#define SYSTEM_MENU_DOWN            0x1000

#define CONSUMER_PLAY               0x000001
#define CONSUMER_PAUSE              0x000002
#define CONSUMER_RECORD             0x000004
#define CONSUMER_FASTFORWARD        0x000008
#define CONSUMER_REWIND             0x000010
#define CONSUMER_NEXTTRACK          0x000020
#define CONSUMER_PREVTRACK          0x000040
#define CONSUMER_STOP               0x000080
#define CONSUMER_EJECT              0x000100
#define CONSUMER_MUTE               0x000200
#define CONSUMER_VOLUME_UP          0x000400
#define CONSUMER_VOLUME_DOWN        0x000800
#define CONSUMER_MENU_ESCAPE        0x001000
#define CONSUMER_MENU_RIGHT         0x002000
#define CONSUMER_MENU_LEFT          0x004000
#define CONSUMER_MENU_DOWN          0x008000
#define CONSUMER_MENU_UP            0x010000
#define CONSUMER_MENU_PICK          0x020000
#define CONSUMER_MENU               0x040000

class HID_Media : public USBDevice {
    private:
        USBManager *_manager;
        uint8_t _ifInt;
        uint8_t _epInt;
        void sendReport(uint8_t id, uint16_t data);
        void sendReport(uint8_t id, uint32_t data);
        uint8_t _intA[8];
        uint8_t _intB[8];

        uint16_t _systemKeys;
        uint32_t _consumerKeys;

    public:
        uint16_t getDescriptorLength();
        uint8_t getInterfaceCount();
        uint32_t populateConfigurationDescriptor(uint8_t *buf);
        void initDevice(USBManager *manager);
        bool getDescriptor(uint8_t ep, uint8_t target, uint8_t id, uint8_t maxlen);
        bool getReportDescriptor(uint8_t ep, uint8_t target, uint8_t id, uint8_t maxlen);
        bool getStringDescriptor(uint8_t __attribute__((unused)) idx, uint16_t __attribute__((unused)) maxlen)  { return false; }
        void configureEndpoints();

        bool onSetupPacket(uint8_t ep, uint8_t target, uint8_t *data, uint32_t l);
        bool onInPacket(uint8_t ep, uint8_t target, uint8_t *data, uint32_t l);
        bool onOutPacket(uint8_t ep, uint8_t target, uint8_t *data, uint32_t l);
        void onEnumerated();
        size_t write(uint8_t);

        size_t pressSystem(uint16_t key);
        size_t releaseSystem(uint16_t key);
        size_t pressConsumer(uint32_t key);
        size_t releaseConsumer(uint32_t key);
        void releaseAllSystem();
        void releaseAllConsumer();
        void releaseAll();

        void begin(void) {};
        void end(void) {};
};

#define MOUSE_LEFT 1
#define MOUSE_RIGHT 2
#define MOUSE_MIDDLE 4
#define MOUSE_ALL (MOUSE_LEFT | MOUSE_RIGHT | MOUSE_MIDDLE)


class HID_Mouse : public USBDevice {
    private:
        USBManager *_manager;
        uint8_t _ifInt;
        uint8_t _epInt;
        void sendReport(const uint8_t *b, uint8_t l);
        uint8_t _buttons;
        void buttons(uint8_t b);
        uint8_t _intA[8];
        uint8_t _intB[8];

    public:
        uint16_t getDescriptorLength();
        uint8_t getInterfaceCount();
        uint32_t populateConfigurationDescriptor(uint8_t *buf);
        void initDevice(USBManager *manager);
        bool getDescriptor(uint8_t ep, uint8_t target, uint8_t id, uint8_t maxlen);
        bool getReportDescriptor(uint8_t ep, uint8_t target, uint8_t id, uint8_t maxlen);
        bool getStringDescriptor(uint8_t __attribute__((unused)) idx, uint16_t __attribute__((unused)) maxlen)  { return false; }
        void configureEndpoints();

        bool onSetupPacket(uint8_t ep, uint8_t target, uint8_t *data, uint32_t l);
        bool onInPacket(uint8_t ep, uint8_t target, uint8_t *data, uint32_t l);
        bool onOutPacket(uint8_t ep, uint8_t target, uint8_t *data, uint32_t l);
        void onEnumerated();

        HID_Mouse() : _buttons(0) {}

        void begin(void) {};
        void end(void) {};
        void click(uint8_t b = MOUSE_LEFT);
        void move(signed char x, signed char y, signed char wheel = 0);
        void press(uint8_t b = MOUSE_LEFT);     // press LEFT by default
        void release(uint8_t b = MOUSE_LEFT);   // release LEFT by default
        bool isPressed(uint8_t b = MOUSE_LEFT); // check LEFT by default
};

class HID_Tablet : public USBDevice {
    private:
        USBManager *_manager;
        uint8_t _ifInt;
        uint8_t _epInt;
        void sendReport(const uint8_t *b, uint8_t l);
        void buttons(uint8_t b);
        uint8_t _intA[16];
        uint8_t _intB[16];
        uint16_t _buttons;
        uint16_t _x;
        uint16_t _y;
        uint16_t _w;
        uint16_t _h;

    public:
        uint16_t getDescriptorLength();
        uint8_t getInterfaceCount();
        uint32_t populateConfigurationDescriptor(uint8_t *buf);
        void initDevice(USBManager *manager);
        bool getDescriptor(uint8_t ep, uint8_t target, uint8_t id, uint8_t maxlen);
        bool getReportDescriptor(uint8_t ep, uint8_t target, uint8_t id, uint8_t maxlen);
        bool getStringDescriptor(uint8_t __attribute__((unused)) idx, uint16_t __attribute__((unused)) maxlen) { return false; }
        void configureEndpoints();

        bool onSetupPacket(uint8_t ep, uint8_t target, uint8_t *data, uint32_t l);
        bool onInPacket(uint8_t ep, uint8_t target, uint8_t *data, uint32_t l);
        bool onOutPacket(uint8_t ep, uint8_t target, uint8_t *data, uint32_t l);
        void onEnumerated();

        HID_Tablet(int w, int h) : _buttons(0), _x(0), _y(0), _w(w), _h(h) {}

        void begin(void) {};
        void end(void) {};
        void click(uint8_t b = MOUSE_LEFT);
        void move(uint16_t x, uint16_t y);
        void press(uint8_t b = MOUSE_LEFT);     // press LEFT by default
        void release(uint8_t b = MOUSE_LEFT);   // release LEFT by default
        bool isPressed(uint8_t b = MOUSE_LEFT); // check LEFT by default
        void update();
};


struct JoystickReport {
    struct {
        uint8_t x;
        uint8_t y;
        uint8_t z;
    } position;
    struct {
        uint8_t x;
        uint8_t y;
        uint8_t z;
    } rotation;
    uint8_t hat;
    uint16_t buttons;
} __attribute__((packed));

class HID_Joystick : public USBDevice {
    private:
        USBManager *_manager;
        uint8_t _ifInt;
        uint8_t _epInt;
        void sendReport(const uint8_t *b, uint8_t l);
        struct JoystickReport _rep;
        uint8_t _intA[16];
        uint8_t _intB[16];

    public:
        uint16_t getDescriptorLength();
        uint8_t getInterfaceCount();
        uint32_t populateConfigurationDescriptor(uint8_t *buf);
        void initDevice(USBManager *manager);
        bool getDescriptor(uint8_t ep, uint8_t target, uint8_t id, uint8_t maxlen);
        bool getReportDescriptor(uint8_t ep, uint8_t target, uint8_t id, uint8_t maxlen);
        bool getStringDescriptor(uint8_t __attribute__((unused)) idx, uint16_t __attribute__((unused)) maxlen) { return false; }
        void configureEndpoints();

        bool onSetupPacket(uint8_t ep, uint8_t target, uint8_t *data, uint32_t l);
        bool onInPacket(uint8_t ep, uint8_t target, uint8_t *data, uint32_t l);
        bool onOutPacket(uint8_t ep, uint8_t target, uint8_t *data, uint32_t l);
        void onEnumerated();

        HID_Joystick(void);
        void begin(void) {};
        void end(void) {};
        void setX(uint8_t x);
        void setY(uint8_t y);
        void setZ(uint8_t z);
        void rotateX(uint8_t x);
        void rotateY(uint8_t y);
        void rotateZ(uint8_t z);
        void setPosition(uint8_t x, uint8_t y, uint8_t z);
        void setRotation(uint8_t x, uint8_t y, uint8_t z);
        void press(uint8_t b);
        void release(uint8_t b);
        void setHat(uint8_t d);
};

class HID_Raw : public USBDevice {
    private:
        USBManager *_manager;
        uint8_t _ifInt;
        uint8_t _epInt;
        uint8_t _intRxA[64];
        uint8_t _intRxB[64];
        uint8_t _intTxA[64];
        uint8_t _intTxB[64];
        bool _nextPacketIsMine;
        uint8_t _features[256];

        void (*_outputReportHandler)(uint8_t *data, uint32_t len);

    public:
        void sendReport(uint8_t *b, uint8_t l);
        uint16_t getDescriptorLength();
        uint8_t getInterfaceCount();
        uint32_t populateConfigurationDescriptor(uint8_t *buf);
        void initDevice(USBManager *manager);
        bool getDescriptor(uint8_t ep, uint8_t target, uint8_t id, uint8_t maxlen);
        bool getReportDescriptor(uint8_t ep, uint8_t target, uint8_t id, uint8_t maxlen);
        bool getStringDescriptor(uint8_t __attribute__((unused)) idx, uint16_t __attribute__((unused)) maxlen) { return false; }
        void configureEndpoints();

        bool onSetupPacket(uint8_t ep, uint8_t target, uint8_t *data, uint32_t l);
        bool onInPacket(uint8_t ep, uint8_t target, uint8_t *data, uint32_t l);
        bool onOutPacket(uint8_t ep, uint8_t target, uint8_t *data, uint32_t l);
        void onEnumerated();

        void begin(void) {};
        void end(void) {};

        uint8_t getFeature(uint8_t f) { return _features[f]; }
        void setFeature(uint8_t f, uint8_t v) { _features[f] = v; }

        void onOutputReport(void (*func)(uint8_t *, uint32_t)) { _outputReportHandler = func; }
};

class Audio_MIDI : public USBDevice {
    private:
        USBManager *_manager;
        uint8_t _ifCtl;
        uint8_t _ifBulk;
        uint8_t _epBulk;

#if defined (__PIC32MX__)
        uint8_t _bulkRxA[64];
        uint8_t _bulkRxB[64];
        uint8_t _bulkTxA[64];
        uint8_t _bulkTxB[64];
#elif defined(__PIC32MZ__)
        uint8_t _bulkRxA[512];
        uint8_t _bulkRxB[512];
        uint8_t _bulkTxA[512];
        uint8_t _bulkTxB[512];
#endif

        void (*_onMidiMessage)(uint8_t status, uint8_t d0, uint8_t d1);

    public:
        uint16_t getDescriptorLength();
        uint8_t getInterfaceCount();
        uint32_t populateConfigurationDescriptor(uint8_t *buf);
        void initDevice(USBManager *manager);
        bool getDescriptor(uint8_t ep, uint8_t target, uint8_t id, uint8_t maxlen);
        bool getReportDescriptor(uint8_t ep, uint8_t target, uint8_t id, uint8_t maxlen);
        bool getStringDescriptor(uint8_t __attribute__((unused)) idx, uint16_t __attribute__((unused)) maxlen) { return false; }
        void configureEndpoints();

        bool onSetupPacket(uint8_t ep, uint8_t target, uint8_t *data, uint32_t l);
        bool onInPacket(uint8_t ep, uint8_t target, uint8_t *data, uint32_t l);
        bool onOutPacket(uint8_t ep, uint8_t target, uint8_t *data, uint32_t l);
        void onEnumerated();

        void begin(void) {};
        void end(void) {};

        bool sendMessage(uint8_t cable, uint8_t code, uint8_t b0, uint8_t b1, uint8_t b2);

        bool noteOn(uint8_t channel, uint8_t note, uint8_t velocity);
        bool noteOff(uint8_t channel, uint8_t note);
        void onMidiMessage(void (*func)(uint8_t status, uint8_t d0, uint8_t d1));

};


// Default Combinations

#if defined(__USB_CDCACM__)
    extern CDCACM Serial;
#endif // __USB_CDCACM__

#if defined(__USB_CDCACM_KM__)
    extern CDCACM Serial;
    extern HID_Keyboard Keyboard;
    extern HID_Mouse Mouse;
#endif // __USB_CDCACM_KM__


#endif // _USB
#endif // _USB_H
