/* mbed Microcontroller Library
 * Copyright (c) 2006-2013 ARM Limited
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#ifndef __UUID_H__
#define __UUID_H__

#include <stdint.h>
#include <string.h>
#include <algorithm>

#include "blecommon.h"

/**
 * A trivial converter for single hexadecimal character to unsigned-int.
 * @param  c hexadecimal character.
 * @return   the corresponding value as unsigned int.
 */
static uint8_t char2int(char c) {
    if ((c >= '0') && (c <= '9')) {
        return c - '0';
    } else if ((c >= 'a') && (c <= 'f')) {
        return c - 'a' + 10;
    } else if ((c >= 'A') && (c <= 'F')) {
        return c - 'A' + 10;
    } else {
        return 0;
    }
}

class UUID {
public:
    enum UUID_Type_t {
        UUID_TYPE_SHORT = 0,    // Short BLE UUID.
        UUID_TYPE_LONG  = 1     // Full 128-bit UUID.
    };

    /**
     * An enumeration to specify byte ordering of the long version of the UUID.
     */
    typedef enum {
        MSB, /*!< Most-significant byte first (at the smallest address) */
        LSB  /*!< least-significant byte first (at the smallest address) */
    } ByteOrder_t;

    typedef uint16_t      ShortUUIDBytes_t;

    static const unsigned LENGTH_OF_LONG_UUID = 16;
    typedef uint8_t       LongUUIDBytes_t[LENGTH_OF_LONG_UUID];

    static const unsigned MAX_UUID_STRING_LENGTH = LENGTH_OF_LONG_UUID * 2 + 4;

public:

    /**
     * Creates a new 128-bit UUID.
     *
     * @note   The UUID is a unique 128-bit (16 byte) ID used to identify
     *         different service or characteristics on the BLE device.
     *
     * @param  stringUUID
     *          The 128-bit (16-byte) UUID as a human readable const-string.
     *          Format: XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX
     *          Upper and lower case supported. Hyphens are optional, but only
     *          upto four of them. The UUID is stored internally as a 16 byte
     *          array, LSB (little endian), which is opposite from the string.
     */
    UUID(const char* stringUUID) : type(UUID_TYPE_LONG), baseUUID(), shortUUID(0) {
        bool nibble = false;
        uint8_t byte = 0;
        size_t baseIndex = 0;
        uint8_t tempUUID[LENGTH_OF_LONG_UUID];

        // Iterate through string, abort if NULL is encountered prematurely.
        // Ignore upto four hyphens.
        for (size_t index = 0; (index < MAX_UUID_STRING_LENGTH) && (baseIndex < LENGTH_OF_LONG_UUID); index++) {
            if (stringUUID[index] == '\0') {
                // error abort
                break;
            } else if (stringUUID[index] == '-') {
                // ignore hyphen
                continue;
            } else if (nibble) {
                // got second nibble
                byte |= char2int(stringUUID[index]);
                nibble = false;

                // store copy
                tempUUID[baseIndex++] = byte;
            } else {
                // got first nibble
                byte = char2int(stringUUID[index]) << 4;
                nibble = true;
            }
        }

        // populate internal variables if string was successfully parsed
        if (baseIndex == LENGTH_OF_LONG_UUID) {
            setupLong(tempUUID, UUID::MSB);
        } else {
            const uint8_t sig[] = { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x10, 0x00,
                                    0x80, 0x00, 0x00, 0x80, 0x5F, 0x9B, 0x34, 0xFB };
            setupLong(sig, UUID::MSB);
        }
    }

    /**
     * Creates a new 128-bit UUID.
     *
     * @note   The UUID is a unique 128-bit (16 byte) ID used to identify
     *         different service or characteristics on the BLE device.
     *
     * @param longUUID
     *          The 128-bit (16-byte) UUID value.
     * @param order
     *          The bit order of the UUID, MSB by default.
     */
    UUID(const LongUUIDBytes_t longUUID, ByteOrder_t order = UUID::MSB) : type(UUID_TYPE_LONG), baseUUID(), shortUUID(0) {
        setupLong(longUUID, order);
    }

    /**
     * Creates a new 16-bit UUID.
     *
     * @note The UUID is a unique 16-bit (2 byte) ID used to identify
     *       different service or characteristics on the BLE device.
     *
     * For efficiency, and because 16 bytes would take a large chunk of the
     * 27-byte data payload length of the Link Layer, the BLE specification adds
     * two additional UUID formats: 16-bit and 32-bit UUIDs. These shortened
     * formats can be used only with UUIDs that are defined in the Bluetooth
     * specification (listed by the Bluetooth SIG as standard
     * Bluetooth UUIDs).
     *
     * To reconstruct the full 128-bit UUID from the shortened version, insert
     * the 16-bit short value (indicated by xxxx, including leading zeros) into
     * the Bluetooth Base UUID:
     *
     *  0000xxxx-0000-1000-8000-00805F9B34FB
     *
     * @note Shortening is not available for UUIDs that are not derived from the
     *       Bluetooth Base UUID. Such non-standard UUIDs are commonly called
     *       vendor-specific UUIDs. In these cases, you’ll need to use the full
     *       128-bit UUID value at all times.
     *
     * @note We don't yet support 32-bit shortened UUIDs.
     */
    UUID(ShortUUIDBytes_t _shortUUID) : type(UUID_TYPE_SHORT), baseUUID(), shortUUID(_shortUUID) {
        /* Empty */
    }

    UUID(const UUID &source) {
        type      = source.type;
        shortUUID = source.shortUUID;
        memcpy(baseUUID, source.baseUUID, LENGTH_OF_LONG_UUID);
    }

    UUID(void) : type(UUID_TYPE_SHORT), shortUUID(BLE_UUID_UNKNOWN) {
        /* empty */
    }

    /**
     * Fill in a 128-bit UUID; this is useful when the UUID isn't known at the time of the object construction.
     */
    void setupLong(const LongUUIDBytes_t longUUID, ByteOrder_t order = UUID::MSB) {
        type      = UUID_TYPE_LONG;
        if (order == UUID::MSB) {
            // Switch endian. Input is big-endian, internal representation is little endian.
            std::reverse_copy(longUUID, longUUID + LENGTH_OF_LONG_UUID, baseUUID);
        } else {
            std::copy(longUUID, longUUID + LENGTH_OF_LONG_UUID, baseUUID);
        }
        shortUUID = (uint16_t)((baseUUID[13] << 8) | (baseUUID[12]));
    }

public:
    UUID_Type_t       shortOrLong(void)  const {return type;     }
    const uint8_t    *getBaseUUID(void)  const {
        if (type == UUID_TYPE_SHORT) {
            return (const uint8_t*)&shortUUID;
        } else {
            return baseUUID;
        }
    }

    ShortUUIDBytes_t  getShortUUID(void) const {return shortUUID;}
    uint8_t           getLen(void)       const {
        return ((type == UUID_TYPE_SHORT) ? sizeof(ShortUUIDBytes_t) : LENGTH_OF_LONG_UUID);
    }

    bool operator== (const UUID &other) const {
        if ((this->type == UUID_TYPE_SHORT) && (other.type == UUID_TYPE_SHORT) &&
            (this->shortUUID == other.shortUUID)) {
            return true;
        }

        if ((this->type == UUID_TYPE_LONG) && (other.type == UUID_TYPE_LONG) &&
            (memcmp(this->baseUUID, other.baseUUID, LENGTH_OF_LONG_UUID) == 0)) {
            return true;
        }

        return false;
    }

    bool operator!= (const UUID &other) const {
        return !(*this == other);
    }

private:
    UUID_Type_t      type;      // UUID_TYPE_SHORT or UUID_TYPE_LONG
    LongUUIDBytes_t  baseUUID;  // The long UUID
    ShortUUIDBytes_t shortUUID; // 16 bit UUID
};

#endif // ifndef __UUID_H__
