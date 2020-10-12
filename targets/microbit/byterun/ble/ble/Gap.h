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

#ifndef __GAP_H__
#define __GAP_H__

#include "ble/BLEProtocol.h"
#include "GapAdvertisingData.h"
#include "GapAdvertisingParams.h"
#include "GapScanningParams.h"
#include "GapEvents.h"
#include "CallChainOfFunctionPointersWithContext.h"
#include "FunctionPointerWithContext.h"
#include "deprecate.h"

/* Forward declarations for classes that will only be used for pointers or references in the following. */
class GapAdvertisingParams;
class GapScanningParams;
class GapAdvertisingData;

class Gap {
    /*
     * DEPRECATION ALERT: all of the APIs in this `public` block are deprecated.
     * They have been relocated to the class BLEProtocol.
     */
public:
    /**
     * Address-type for BLEProtocol addresses.
     *
     * @note: deprecated. Use BLEProtocol::AddressType_t instead.
     */
    typedef BLEProtocol::AddressType_t AddressType_t;

    /**
     * Address-type for BLEProtocol addresses.
     * @note: deprecated. Use BLEProtocol::AddressType_t instead.
     */
    typedef BLEProtocol::AddressType_t addr_type_t;

    /**
     * Address-type for BLEProtocol addresses.
     * \deprecated: Use BLEProtocol::AddressType_t instead.
     *
     * DEPRECATION ALERT: The following constants have been left in their
     * deprecated state to transparenly support existing applications which may
     * have used Gap::ADDR_TYPE_*.
     */
    enum DeprecatedAddressType_t {
        ADDR_TYPE_PUBLIC                        = BLEProtocol::AddressType::PUBLIC,
        ADDR_TYPE_RANDOM_STATIC                 = BLEProtocol::AddressType::RANDOM_STATIC,
        ADDR_TYPE_RANDOM_PRIVATE_RESOLVABLE     = BLEProtocol::AddressType::RANDOM_PRIVATE_RESOLVABLE,
        ADDR_TYPE_RANDOM_PRIVATE_NON_RESOLVABLE = BLEProtocol::AddressType::RANDOM_PRIVATE_NON_RESOLVABLE
    };

    static const unsigned ADDR_LEN = BLEProtocol::ADDR_LEN; /**< Length (in octets) of the BLE MAC address. */
    typedef BLEProtocol::AddressBytes_t Address_t; /**< 48-bit address, LSB format. @Note: Deprecated. Use BLEProtocol::AddressBytes_t instead. */
    typedef BLEProtocol::AddressBytes_t address_t; /**< 48-bit address, LSB format. @Note: Deprecated. Use BLEProtocol::AddressBytes_t instead. */

public:
    enum TimeoutSource_t {
        TIMEOUT_SRC_ADVERTISING      = 0x00, /**< Advertising timeout. */
        TIMEOUT_SRC_SECURITY_REQUEST = 0x01, /**< Security request timeout. */
        TIMEOUT_SRC_SCAN             = 0x02, /**< Scanning timeout. */
        TIMEOUT_SRC_CONN             = 0x03, /**< Connection timeout. */
    };

    /**
     * Enumeration for disconnection reasons. The values for these reasons are
     * derived from Nordic's implementation, but the reasons are meant to be
     * independent of the transport. If you are returned a reason that is not
     * covered by this enumeration, please refer to the underlying
     * transport library.
     */
    enum DisconnectionReason_t {
        CONNECTION_TIMEOUT                          = 0x08,
        REMOTE_USER_TERMINATED_CONNECTION           = 0x13,
        REMOTE_DEV_TERMINATION_DUE_TO_LOW_RESOURCES = 0x14,  /**< Remote device terminated connection due to low resources.*/
        REMOTE_DEV_TERMINATION_DUE_TO_POWER_OFF     = 0x15,  /**< Remote device terminated connection due to power off. */
        LOCAL_HOST_TERMINATED_CONNECTION            = 0x16,
        CONN_INTERVAL_UNACCEPTABLE                  = 0x3B,
    };

    /**
     * Enumeration for whitelist advertising policy filter modes. The possible
     * filter modes were obtained from the Bluetooth Core Specification
     * 4.2 (Vol. 6), Part B, Section 4.3.2.
     *
     * @experimental
     */
    enum AdvertisingPolicyMode_t {
        ADV_POLICY_IGNORE_WHITELIST = 0,
        ADV_POLICY_FILTER_SCAN_REQS = 1,
        ADV_POLICY_FILTER_CONN_REQS = 2,
        ADV_POLICY_FILTER_ALL_REQS  = 3,
    };

    /**
     * Enumeration for whitelist scanning policy filter modes. The possible
     * filter modes were obtained from the Bluetooth Core Specification
     * 4.2 (Vol. 6), Part B, Section 4.3.3.
     *
     * @experimental
     */
    enum ScanningPolicyMode_t {
        SCAN_POLICY_IGNORE_WHITELIST = 0,
        SCAN_POLICY_FILTER_ALL_ADV   = 1,
    };

    /**
     * Enumeration for the whitelist initiator policy fiter modes. The possible
     * filter modes were obtained from the Bluetooth Core Specification
     * 4.2 (vol. 6), Part B, Section 4.4.4.
     *
     * @experimental
     */
    enum InitiatorPolicyMode_t {
        INIT_POLICY_IGNORE_WHITELIST = 0,
        INIT_POLICY_FILTER_ALL_ADV   = 1,
    };

    /**
     * Representation of a Bluetooth Low Enery Whitelist containing addresses.
     *
     * @experimental
     */
    struct Whitelist_t {
        BLEProtocol::Address_t *addresses;
        uint8_t                 size;
        uint8_t                 capacity;
        uint8_t                 bonds;
    };


    /* Describes the current state of the device (more than one bit can be set). */
    struct GapState_t {
        unsigned advertising : 1; /**< Peripheral is currently advertising. */
        unsigned connected   : 1; /**< Peripheral is connected to a central. */
    };

    typedef uint16_t Handle_t; /* Type for connection handle. */

    typedef struct {
        uint16_t minConnectionInterval;        /**< Minimum Connection Interval in 1.25 ms units, see @ref BLE_GAP_CP_LIMITS.*/
        uint16_t maxConnectionInterval;        /**< Maximum Connection Interval in 1.25 ms units, see @ref BLE_GAP_CP_LIMITS.*/
        uint16_t slaveLatency;                 /**< Slave Latency in number of connection events, see @ref BLE_GAP_CP_LIMITS.*/
        uint16_t connectionSupervisionTimeout; /**< Connection Supervision Timeout in 10 ms units, see @ref BLE_GAP_CP_LIMITS.*/
    } ConnectionParams_t;

    enum Role_t {
        PERIPHERAL  = 0x1, /**< Peripheral Role. */
        CENTRAL     = 0x2, /**< Central Role.    */
    };

    struct AdvertisementCallbackParams_t {
        BLEProtocol::AddressBytes_t              peerAddr;
        int8_t                                   rssi;
        bool                                     isScanResponse;
        GapAdvertisingParams::AdvertisingType_t  type;
        uint8_t                                  advertisingDataLen;
        const uint8_t                           *advertisingData;
    };
    typedef FunctionPointerWithContext<const AdvertisementCallbackParams_t *> AdvertisementReportCallback_t;

    struct ConnectionCallbackParams_t {
        Handle_t                    handle;
        Role_t                      role;
        BLEProtocol::AddressType_t  peerAddrType;
        BLEProtocol::AddressBytes_t peerAddr;
        BLEProtocol::AddressType_t  ownAddrType;
        BLEProtocol::AddressBytes_t ownAddr;
        const ConnectionParams_t   *connectionParams;

        ConnectionCallbackParams_t(Handle_t                    handleIn,
                                   Role_t                      roleIn,
                                   BLEProtocol::AddressType_t  peerAddrTypeIn,
                                   const uint8_t              *peerAddrIn,
                                   BLEProtocol::AddressType_t  ownAddrTypeIn,
                                   const uint8_t              *ownAddrIn,
                                   const ConnectionParams_t   *connectionParamsIn) :
            handle(handleIn),
            role(roleIn),
            peerAddrType(peerAddrTypeIn),
            peerAddr(),
            ownAddrType(ownAddrTypeIn),
            ownAddr(),
            connectionParams(connectionParamsIn) {
            memcpy(peerAddr, peerAddrIn, ADDR_LEN);
            memcpy(ownAddr, ownAddrIn, ADDR_LEN);
        }
    };

    struct DisconnectionCallbackParams_t {
        Handle_t              handle;
        DisconnectionReason_t reason;

        DisconnectionCallbackParams_t(Handle_t              handleIn,
                                      DisconnectionReason_t reasonIn) :
            handle(handleIn),
            reason(reasonIn)
        {}
    };

    static const uint16_t UNIT_1_25_MS  = 1250; /**< Number of microseconds in 1.25 milliseconds. */
    static uint16_t MSEC_TO_GAP_DURATION_UNITS(uint32_t durationInMillis) {
        return (durationInMillis * 1000) / UNIT_1_25_MS;
    }

    typedef FunctionPointerWithContext<TimeoutSource_t> TimeoutEventCallback_t;
    typedef CallChainOfFunctionPointersWithContext<TimeoutSource_t> TimeoutEventCallbackChain_t;

    typedef FunctionPointerWithContext<const ConnectionCallbackParams_t *> ConnectionEventCallback_t;
    typedef CallChainOfFunctionPointersWithContext<const ConnectionCallbackParams_t *> ConnectionEventCallbackChain_t;

    typedef FunctionPointerWithContext<const DisconnectionCallbackParams_t*> DisconnectionEventCallback_t;
    typedef CallChainOfFunctionPointersWithContext<const DisconnectionCallbackParams_t*> DisconnectionEventCallbackChain_t;

    typedef FunctionPointerWithContext<bool> RadioNotificationEventCallback_t;

    typedef FunctionPointerWithContext<const Gap *> GapShutdownCallback_t;
    typedef CallChainOfFunctionPointersWithContext<const Gap *> GapShutdownCallbackChain_t;

    /*
     * The following functions are meant to be overridden in the platform-specific sub-class.
     */
public:
    /**
     * Set the BTLE MAC address and type. Please note that the address format is
     * least significant byte first (LSB). Please refer to BLEProtocol::AddressBytes_t.
     *
     * @return BLE_ERROR_NONE on success.
     */
    virtual ble_error_t setAddress(BLEProtocol::AddressType_t type, const BLEProtocol::AddressBytes_t address) {
        /* avoid compiler warnings about unused variables */
        (void)type;
        (void)address;

        return BLE_ERROR_NOT_IMPLEMENTED; /* Requesting action from porter(s): override this API if this capability is supported. */
    }

    /**
     * Fetch the BTLE MAC address and type.
     *
     * @return BLE_ERROR_NONE on success.
     */
    virtual ble_error_t getAddress(BLEProtocol::AddressType_t *typeP, BLEProtocol::AddressBytes_t address) {
        /* Avoid compiler warnings about unused variables. */
        (void)typeP;
        (void)address;

        return BLE_ERROR_NOT_IMPLEMENTED; /* Requesting action from porter(s): override this API if this capability is supported. */
    }

    /**
     * @return Minimum Advertising interval in milliseconds for connectable
     *      undirected and connectable directed event types.
     */
    virtual uint16_t getMinAdvertisingInterval(void) const {
        return 0; /* Requesting action from porter(s): override this API if this capability is supported. */
    }

    /**
     * @return Minimum Advertising interval in milliseconds for scannable
     *      undirected and non-connectable undirected event types.
     */
    virtual uint16_t getMinNonConnectableAdvertisingInterval(void) const {
        return 0; /* Requesting action from porter(s): override this API if this capability is supported. */
    }

    /**
     * @return Maximum Advertising interval in milliseconds.
     */
    virtual uint16_t getMaxAdvertisingInterval(void) const {
        return 0xFFFF; /* Requesting action from porter(s): override this API if this capability is supported. */
    }

    virtual ble_error_t stopAdvertising(void) {
        return BLE_ERROR_NOT_IMPLEMENTED; /* Requesting action from porter(s): override this API if this capability is supported. */
    }

    /**
     * Stop scanning. The current scanning parameters remain in effect.
     *
     * @retval BLE_ERROR_NONE if successfully stopped scanning procedure.
     */
    virtual ble_error_t stopScan() {
        return BLE_ERROR_NOT_IMPLEMENTED; /* Requesting action from porter(s): override this API if this capability is supported. */
    }

    /**
     * Create a connection (GAP Link Establishment).
     *
     * @param peerAddr
     *          48-bit address, LSB format.
     * @param peerAddrType
     *          Address type of the peer.
     * @param connectionParams
     *         Connection parameters.
     * @param scanParams
     *          Paramters to be used while scanning for the peer.
     * @return  BLE_ERROR_NONE if connection establishment procedure is started
     *     successfully. The connectionCallChain (if set) will be invoked upon
     *     a connection event.
     */
    virtual ble_error_t connect(const BLEProtocol::AddressBytes_t  peerAddr,
                                BLEProtocol::AddressType_t         peerAddrType,
                                const ConnectionParams_t          *connectionParams,
                                const GapScanningParams           *scanParams) {
        /* Avoid compiler warnings about unused variables. */
        (void)peerAddr;
        (void)peerAddrType;
        (void)connectionParams;
        (void)scanParams;

        return BLE_ERROR_NOT_IMPLEMENTED; /* Requesting action from porter(s): override this API if this capability is supported. */
    }

    /**
     * Create a connection (GAP Link Establishment).
     *
     * \deprecated: This funtion overloads Gap::connect(const BLEProtocol::Address_t  peerAddr,
                                                        BLEProtocol::AddressType_t    peerAddrType,
                                                        const ConnectionParams_t     *connectionParams,
                                                        const GapScanningParams      *scanParams)
     *      to maintain backward compatibility for change from Gap::AddressType_t to BLEProtocol::AddressType_t
     */
    ble_error_t connect(const BLEProtocol::AddressBytes_t  peerAddr,
                        DeprecatedAddressType_t            peerAddrType,
                        const ConnectionParams_t          *connectionParams,
                        const GapScanningParams           *scanParams)
    __deprecated_message("Gap::DeprecatedAddressType_t is deprecated, use BLEProtocol::AddressType_t instead") {
        return connect(peerAddr, (BLEProtocol::AddressType_t) peerAddrType, connectionParams, scanParams);
    }

    /**
     * This call initiates the disconnection procedure, and its completion will
     * be communicated to the application with an invocation of the
     * disconnectionCallback.
     *
     * @param  reason
     *           The reason for disconnection; to be sent back to the peer.
     */
    virtual ble_error_t disconnect(Handle_t connectionHandle, DisconnectionReason_t reason) {
        /* avoid compiler warnings about unused variables */
        (void)connectionHandle;
        (void)reason;

        return BLE_ERROR_NOT_IMPLEMENTED; /* Requesting action from porter(s): override this API if this capability is supported. */
    }

    /**
     * This call initiates the disconnection procedure, and its completion will
     * be communicated to the application with an invocation of the
     * disconnectionCallback.
     *
     * @param  reason
     *           The reason for disconnection; to be sent back to the peer.
     *
     * @note: This version of disconnect() doesn't take a connection handle. It
     * works reliably only for stacks that are limited to a single
     * connection. This API should be considered *deprecated* in favour of the
     * alternative, which takes a connection handle. It will be dropped in the future.
     */
    virtual ble_error_t disconnect(DisconnectionReason_t reason) {
        /* Avoid compiler warnings about unused variables. */
        (void)reason;

        return BLE_ERROR_NOT_IMPLEMENTED; /* Requesting action from porter(s): override this API if this capability is supported. */
    }

    /**
     * Get the GAP peripheral preferred connection parameters. These are the
     * defaults that the peripheral would like to have in a connection. The
     * choice of the connection parameters is eventually up to the central.
     *
     * @param[out] params
     *               The structure where the parameters will be stored. Memory
     *               for this is owned by the caller.
     *
     * @return BLE_ERROR_NONE if the parameters were successfully filled into
     * the given structure pointed to by params.
     */
    virtual ble_error_t getPreferredConnectionParams(ConnectionParams_t *params) {
        /* Avoid compiler warnings about unused variables. */
        (void)params;

        return BLE_ERROR_NOT_IMPLEMENTED; /* Requesting action from porter(s): override this API if this capability is supported. */
    }

    /**
     * Set the GAP peripheral preferred connection parameters. These are the
     * defaults that the peripheral would like to have in a connection. The
     * choice of the connection parameters is eventually up to the central.
     *
     * @param[in] params
     *               The structure containing the desired parameters.
     */
    virtual ble_error_t setPreferredConnectionParams(const ConnectionParams_t *params) {
        /* Avoid compiler warnings about unused variables. */
        (void)params;

        return BLE_ERROR_NOT_IMPLEMENTED; /* Requesting action from porter(s): override this API if this capability is supported. */
    }

    /**
     * Update connection parameters.
     * In the central role this will initiate a Link Layer connection parameter update procedure.
     * In the peripheral role, this will send the corresponding L2CAP request and wait for
     * the central to perform the procedure.
     *
     * @param[in] handle
     *              Connection Handle.
     * @param[in] params
     *              Pointer to desired connection parameters. If NULL is provided on a peripheral role,
     *              the parameters in the PPCP characteristic of the GAP service will be used instead.
     */
    virtual ble_error_t updateConnectionParams(Handle_t handle, const ConnectionParams_t *params) {
        /* avoid compiler warnings about unused variables */
        (void)handle;
        (void)params;

        return BLE_ERROR_NOT_IMPLEMENTED; /* Requesting action from porter(s): override this API if this capability is supported. */
    }

    /**
     * Set the device name characteristic in the GAP service.
     * @param[in] deviceName
     *              The new value for the device-name. This is a UTF-8 encoded, <b>NULL-terminated</b> string.
     */
    virtual ble_error_t setDeviceName(const uint8_t *deviceName) {
        /* Avoid compiler warnings about unused variables. */
        (void)deviceName;

        return BLE_ERROR_NOT_IMPLEMENTED; /* Requesting action from porter(s): override this API if this capability is supported. */
    }

    /**
     * Get the value of the device name characteristic in the GAP service.
     * @param[out]    deviceName
     *                  Pointer to an empty buffer where the UTF-8 *non NULL-
     *                  terminated* string will be placed. Set this
     *                  value to NULL in order to obtain the deviceName-length
     *                  from the 'length' parameter.
     *
     * @param[in/out] lengthP
     *                  (on input) Length of the buffer pointed to by deviceName;
     *                  (on output) the complete device name length (without the
     *                     null terminator).
     *
     * @note If the device name is longer than the size of the supplied buffer,
     *     length will return the complete device name length, and not the
     *     number of bytes actually returned in deviceName. The application may
     *     use this information to retry with a suitable buffer size.
     */
    virtual ble_error_t getDeviceName(uint8_t *deviceName, unsigned *lengthP) {
        /* avoid compiler warnings about unused variables */
        (void)deviceName;
        (void)lengthP;

        return BLE_ERROR_NOT_IMPLEMENTED; /* Requesting action from porter(s): override this API if this capability is supported. */
    }

    /**
     * Set the appearance characteristic in the GAP service.
     * @param[in] appearance
     *              The new value for the device-appearance.
     */
    virtual ble_error_t setAppearance(GapAdvertisingData::Appearance appearance) {
        /* Avoid compiler warnings about unused variables. */
        (void)appearance;

        return BLE_ERROR_NOT_IMPLEMENTED; /* Requesting action from porter(s): override this API if this capability is supported. */
    }

    /**
     * Get the appearance characteristic in the GAP service.
     * @param[out] appearance
     *               The new value for the device-appearance.
     */
    virtual ble_error_t getAppearance(GapAdvertisingData::Appearance *appearanceP) {
        /* Avoid compiler warnings about unused variables. */
        (void)appearanceP;

        return BLE_ERROR_NOT_IMPLEMENTED; /* Requesting action from porter(s): override this API if this capability is supported. */
    }

    /**
     * Set the radio's transmit power.
     * @param[in] txPower Radio transmit power in dBm.
     */
    virtual ble_error_t setTxPower(int8_t txPower) {
        /* Avoid compiler warnings about unused variables. */
        (void)txPower;

        return BLE_ERROR_NOT_IMPLEMENTED; /* Requesting action from porter(s): override this API if this capability is supported. */
    }

    /**
     * Query the underlying stack for permitted arguments for setTxPower().
     *
     * @param[out] valueArrayPP
     *                 Out parameter to receive the immutable array of Tx values.
     * @param[out] countP
     *                 Out parameter to receive the array's size.
     */
    virtual void getPermittedTxPowerValues(const int8_t **valueArrayPP, size_t *countP) {
        /* Avoid compiler warnings about unused variables. */
        (void)valueArrayPP;
        (void)countP;

        *countP = 0; /* Requesting action from porter(s): override this API if this capability is supported. */
    }

    /**
     * @return Maximum size of the whitelist.
     *
     * @experimental
     */
    virtual uint8_t getMaxWhitelistSize(void) const
    {
        return 0;
    }

    /**
     * Get the internal whitelist to be used by the Link Layer when scanning,
     * advertising or initiating a connection depending on the filter policies.
     *
     * @param[in/out]   whitelist
     *                  (on input) whitelist.capacity contains the maximum number
     *                  of addresses to be returned.
     *                  (on output) The populated whitelist with copies of the
     *                  addresses in the implementation's whitelist.
     *
     * @return BLE_ERROR_NONE if the implementation's whitelist was successfully
     *         copied into the supplied reference.
     *
     * @experimental
     */
    virtual ble_error_t getWhitelist(Whitelist_t &whitelist) const
    {
        (void) whitelist;
        return BLE_ERROR_NOT_IMPLEMENTED;
    }

    /**
     * Set the internal whitelist to be used by the Link Layer when scanning,
     * advertising or initiating a connection depending on the filter policies.
     *
     * @param[in]     whitelist
     *                  A reference to a whitelist containing the addresses to
     *                  be added to the internal whitelist.
     *
     * @return BLE_ERROR_NONE if the implementation's whitelist was successfully
     *         populated with the addresses in the given whitelist.
     *
     * @note The whitelist must not contain addresses of type @ref
     *       BLEProtocol::AddressType_t::RANDOM_PRIVATE_NON_RESOLVABLE, this
     *       this will result in a @ref BLE_ERROR_INVALID_PARAM since the
     *       remote peer might change its private address at any time and it
     *       is not possible to resolve it.
     * @note If the input whitelist is larger than @ref getMaxWhitelistSize()
     *       the @ref BLE_ERROR_PARAM_OUT_OF_RANGE is returned.
     *
     * @experimental
     */
    virtual ble_error_t setWhitelist(const Whitelist_t &whitelist)
    {
        (void) whitelist;
        return BLE_ERROR_NOT_IMPLEMENTED;
    }

    /**
     * Set the advertising policy filter mode to be used in the next call
     * to startAdvertising().
     *
     * @param[in] mode
     *              The new advertising policy filter mode.
     *
     * @return BLE_ERROR_NONE if the specified policy filter mode was set
     *         successfully.
     *
     * @experimental
     */
    virtual ble_error_t setAdvertisingPolicyMode(AdvertisingPolicyMode_t mode)
    {
        (void) mode;
        return BLE_ERROR_NOT_IMPLEMENTED;
    }

    /**
     * Set the scan policy filter mode to be used in the next call
     * to startScan().
     *
     * @param[in] mode
     *              The new scan policy filter mode.
     *
     * @return BLE_ERROR_NONE if the specified policy filter mode was set
     *         successfully.
     *
     * @experimental
     */
    virtual ble_error_t setScanningPolicyMode(ScanningPolicyMode_t mode)
    {
        (void) mode;
        return BLE_ERROR_NOT_IMPLEMENTED;
    }

    /**
     * Set the initiator policy filter mode to be used.
     *
     * @param[in] mode
     *              The new initiator policy filter mode.
     *
     * @return BLE_ERROR_NONE if the specified policy filter mode was set
     *         successfully.
     *
     * @experimental
     */
    virtual ble_error_t setInitiatorPolicyMode(InitiatorPolicyMode_t mode)
    {
        (void) mode;
        return BLE_ERROR_NOT_IMPLEMENTED;
    }

    /**
     * Get the advertising policy filter mode that will be used in the next
     * call to startAdvertising().
     *
     * @return The set advertising policy filter mode.
     *
     * @experimental
     */
    virtual AdvertisingPolicyMode_t getAdvertisingPolicyMode(void) const
    {
        return ADV_POLICY_IGNORE_WHITELIST;
    }

    /**
     * Get the scan policy filter mode that will be used in the next
     * call to startScan().
     *
     * @return The set scan policy filter mode.
     *
     * @experimental
     */
    virtual ScanningPolicyMode_t getScanningPolicyMode(void) const
    {
        return SCAN_POLICY_IGNORE_WHITELIST;
    }

    /**
     * Get the initiator policy filter mode that will be used.
     *
     * @return The set scan policy filter mode.
     *
     * @experimental
     */
    virtual InitiatorPolicyMode_t getInitiatorPolicyMode(void) const
    {
        return INIT_POLICY_IGNORE_WHITELIST;
    }


protected:
    /* Override the following in the underlying adaptation layer to provide the functionality of scanning. */
    virtual ble_error_t startRadioScan(const GapScanningParams &scanningParams) {
        (void)scanningParams;
        return BLE_ERROR_NOT_IMPLEMENTED; /* Requesting action from porter(s): override this API if this capability is supported. */
    }

    /*
     * APIs with non-virtual implementations.
     */
public:
    /**
     * Returns the current GAP state of the device using a bitmask that
     * describes whether the device is advertising or connected.
     */
    GapState_t getState(void) const {
        return state;
    }

    /**
     * Set the GAP advertising mode to use for this device.
     */
    void setAdvertisingType(GapAdvertisingParams::AdvertisingType_t advType) {
        _advParams.setAdvertisingType(advType);
    }

    /**
     * @param[in] interval
     *              Advertising interval in units of milliseconds. Advertising
     *              is disabled if interval is 0. If interval is smaller than
     *              the minimum supported value, then the minimum supported
     *              value is used instead. This minimum value can be discovered
     *              using getMinAdvertisingInterval().
     *
     *              This field must be set to 0 if connectionMode is equal
     *              to ADV_CONNECTABLE_DIRECTED.
     *
     * @note: Decreasing this value will allow central devices to detect a
     * peripheral faster, at the expense of more power being used by the radio
     * due to the higher data transmit rate.
     *
     * @Note: [WARNING] This API previously used 0.625ms as the unit for its
     * 'interval' argument. That required an explicit conversion from
     * milliseconds using Gap::MSEC_TO_GAP_DURATION_UNITS(). This conversion is
     * no longer required as the new units are milliseconds. Any application
     * code depending on the old semantics needs to be updated accordingly.
     */
    void setAdvertisingInterval(uint16_t interval) {
        if (interval == 0) {
            stopAdvertising();
        } else if (interval < getMinAdvertisingInterval()) {
            interval = getMinAdvertisingInterval();
        }
        _advParams.setInterval(interval);
    }

    /**
     * @param[in] timeout
     *              Advertising timeout (in seconds) between 0x1 and 0x3FFF (1
     *              and 16383). Use 0 to disable the advertising timeout.
     */
    void setAdvertisingTimeout(uint16_t timeout) {
        _advParams.setTimeout(timeout);
    }

    /**
     * Start advertising.
     */
    ble_error_t startAdvertising(void) {
        setAdvertisingData(); /* Update the underlying stack. */
        return startAdvertising(_advParams);
    }

    /**
     * Reset any advertising payload prepared from prior calls to
     * accumulateAdvertisingPayload(). This automatically propagates the re-
     * initialized advertising payload to the underlying stack.
     */
    void clearAdvertisingPayload(void) {
        _advPayload.clear();
        setAdvertisingData();
    }

    /**
     * Accumulate an AD structure in the advertising payload. Please note that
     * the payload is limited to 31 bytes. The SCAN_RESPONSE message may be used
     * as an additional 31 bytes if the advertising payload is too
     * small.
     *
     * @param[in] flags
     *              The flags to be added. Please refer to
     *              GapAdvertisingData::Flags for valid flags. Multiple
     *              flags may be specified in combination.
     */
    ble_error_t accumulateAdvertisingPayload(uint8_t flags) {
        ble_error_t rc;
        if ((rc = _advPayload.addFlags(flags)) != BLE_ERROR_NONE) {
            return rc;
        }

        return setAdvertisingData();
    }

    /**
     * Accumulate an AD structure in the advertising payload. Please note that
     * the payload is limited to 31 bytes. The SCAN_RESPONSE message may be used
     * as an additional 31 bytes if the advertising payload is too
     * small.
     *
     * @param  app
     *         The appearance of the peripheral.
     */
    ble_error_t accumulateAdvertisingPayload(GapAdvertisingData::Appearance app) {
        setAppearance(app);

        ble_error_t rc;
        if ((rc = _advPayload.addAppearance(app)) != BLE_ERROR_NONE) {
            return rc;
        }

        return setAdvertisingData();
    }

    /**
     * Accumulate an AD structure in the advertising payload. Please note that
     * the payload is limited to 31 bytes. The SCAN_RESPONSE message may be used
     * as an additional 31 bytes if the advertising payload is too
     * small.
     *
     * @param  power
     *         The max transmit power to be used by the controller (in dBm).
     */
    ble_error_t accumulateAdvertisingPayloadTxPower(int8_t power) {
        ble_error_t rc;
        if ((rc = _advPayload.addTxPower(power)) != BLE_ERROR_NONE) {
            return rc;
        }

        return setAdvertisingData();
    }

    /**
     * Accumulate a variable length byte-stream as an AD structure in the
     * advertising payload. Please note that the payload is limited to 31 bytes.
     * The SCAN_RESPONSE message may be used as an additional 31 bytes if the
     * advertising payload is too small.
     *
     * @param  type The type describing the variable length data.
     * @param  data Data bytes.
     * @param  len  Length of data.
     *
     * @return BLE_ERROR_NONE if the advertisement payload was updated based on
     *         matching AD type; otherwise, an appropriate error.
     *
     * @note When the specified AD type is INCOMPLETE_LIST_16BIT_SERVICE_IDS,
     *       COMPLETE_LIST_16BIT_SERVICE_IDS, INCOMPLETE_LIST_32BIT_SERVICE_IDS,
     *       COMPLETE_LIST_32BIT_SERVICE_IDS, INCOMPLETE_LIST_128BIT_SERVICE_IDS,
     *       COMPLETE_LIST_128BIT_SERVICE_IDS or LIST_128BIT_SOLICITATION_IDS the
     *       supplied value is appended to the values previously added to the
     *       payload.
     */
    ble_error_t accumulateAdvertisingPayload(GapAdvertisingData::DataType type, const uint8_t *data, uint8_t len) {
        if (type == GapAdvertisingData::COMPLETE_LOCAL_NAME) {
            setDeviceName(data);
        }

        ble_error_t rc;
        if ((rc = _advPayload.addData(type, data, len)) != BLE_ERROR_NONE) {
            return rc;
        }

        return setAdvertisingData();
    }

    /**
     * Update a particular ADV field in the advertising payload (based on
     * matching type).
     *
     * @param[in] type  The ADV type field describing the variable length data.
     * @param[in] data  Data bytes.
     * @param[in] len   Length of data.
     *
     * @note: If advertisements are enabled, then the update will take effect immediately.
     *
     * @return BLE_ERROR_NONE if the advertisement payload was updated based on
     *         matching AD type; otherwise, an appropriate error.
     */
    ble_error_t updateAdvertisingPayload(GapAdvertisingData::DataType type, const uint8_t *data, uint8_t len) {
        if (type == GapAdvertisingData::COMPLETE_LOCAL_NAME) {
            setDeviceName(data);
        }

        ble_error_t rc;
        if ((rc = _advPayload.updateData(type, data, len)) != BLE_ERROR_NONE) {
            return rc;
        }

        return setAdvertisingData();
    }

    /**
     * Set up a particular, user-constructed advertisement payload for the
     * underlying stack. It would be uncommon for this API to be used directly;
     * there are other APIs to build an advertisement payload (see above).
     */
    ble_error_t setAdvertisingPayload(const GapAdvertisingData &payload) {
        _advPayload = payload;
        return setAdvertisingData();
    }

    /**
     * @return  Read back advertising data. Useful for storing and
     *          restoring payload.
     */
    const GapAdvertisingData &getAdvertisingPayload(void) const {
        return _advPayload;
    }

    /**
     * Accumulate a variable length byte-stream as an AD structure in the
     * scanResponse payload.
     *
     * @param[in] type The type describing the variable length data.
     * @param[in] data Data bytes.
     * @param[in] len  Length of data.
     */
    ble_error_t accumulateScanResponse(GapAdvertisingData::DataType type, const uint8_t *data, uint8_t len) {
        ble_error_t rc;
        if ((rc = _scanResponse.addData(type, data, len)) != BLE_ERROR_NONE) {
            return rc;
        }

        return setAdvertisingData();
    }

    /**
     * Reset any scan response prepared from prior calls to
     * accumulateScanResponse().
     *
     * Note: This should be followed by a call to setAdvertisingPayload() or
     * startAdvertising() before the update takes effect.
     */
    void clearScanResponse(void) {
        _scanResponse.clear();
        setAdvertisingData();
    }

    /**
     * Set up parameters for GAP scanning (observer mode).
     * @param[in] interval
     *              Scan interval (in milliseconds) [valid values lie between 2.5ms and 10.24s].
     * @param[in] window
     *              Scan Window (in milliseconds) [valid values lie between 2.5ms and 10.24s].
     * @param[in] timeout
     *              Scan timeout (in seconds) between 0x0001 and 0xFFFF; 0x0000 disables the timeout.
     * @param[in] activeScanning
     *              Set to True if active-scanning is required. This is used to fetch the
     *              scan response from a peer if possible.
     *
     * The scanning window divided by the interval determines the duty cycle for
     * scanning. For example, if the interval is 100ms and the window is 10ms,
     * then the controller will scan for 10 percent of the time. It is possible
     * to have the interval and window set to the same value. In this case,
     * scanning is continuous, with a change of scanning frequency once every
     * interval.
     *
     * Once the scanning parameters have been configured, scanning can be
     * enabled by using startScan().
     *
     * @Note: The scan interval and window are recommendations to the BLE stack.
     */
    ble_error_t setScanParams(uint16_t interval       = GapScanningParams::SCAN_INTERVAL_MAX,
                              uint16_t window         = GapScanningParams::SCAN_WINDOW_MAX,
                              uint16_t timeout        = 0,
                              bool     activeScanning = false) {
        ble_error_t rc;
        if (((rc = _scanningParams.setInterval(interval)) == BLE_ERROR_NONE) &&
            ((rc = _scanningParams.setWindow(window))     == BLE_ERROR_NONE) &&
            ((rc = _scanningParams.setTimeout(timeout))   == BLE_ERROR_NONE)) {
            _scanningParams.setActiveScanning(activeScanning);
            return BLE_ERROR_NONE;
        }

        return rc;
    }

    /**
     * Set up the scanInterval parameter for GAP scanning (observer mode).
     * @param[in] interval
     *              Scan interval (in milliseconds) [valid values lie between 2.5ms and 10.24s].
     *
     * The scanning window divided by the interval determines the duty cycle for
     * scanning. For example, if the interval is 100ms and the window is 10ms,
     * then the controller will scan for 10 percent of the time. It is possible
     * to have the interval and window set to the same value. In this case,
     * scanning is continuous, with a change of scanning frequency once every
     * interval.
     *
     * Once the scanning parameters have been configured, scanning can be
     * enabled by using startScan().
     */
    ble_error_t setScanInterval(uint16_t interval) {
        return _scanningParams.setInterval(interval);
    }

    /**
     * Set up the scanWindow parameter for GAP scanning (observer mode).
     * @param[in] window
     *              Scan Window (in milliseconds) [valid values lie between 2.5ms and 10.24s].
     *
     * The scanning window divided by the interval determines the duty cycle for
     * scanning. For example, if the interval is 100ms and the window is 10ms,
     * then the controller will scan for 10 percent of the time. It is possible
     * to have the interval and window set to the same value. In this case,
     * scanning is continuous, with a change of scanning frequency once every
     * interval.
     *
     * Once the scanning parameters have been configured, scanning can be
     * enabled by using startScan().
     *
     * If scanning is already active, the updated value of scanWindow will be
     * propagated to the underlying BLE stack.
     */
    ble_error_t setScanWindow(uint16_t window) {
        ble_error_t rc;
        if ((rc = _scanningParams.setWindow(window)) != BLE_ERROR_NONE) {
            return rc;
        }

        /* If scanning is already active, propagate the new setting to the stack. */
        if (scanningActive) {
            return startRadioScan(_scanningParams);
        }

        return BLE_ERROR_NONE;
    }

    /**
     * Set up parameters for GAP scanning (observer mode).
     * @param[in] timeout
     *              Scan timeout (in seconds) between 0x0001 and 0xFFFF; 0x0000 disables the timeout.
     *
     * Once the scanning parameters have been configured, scanning can be
     * enabled by using startScan().
     *
     * If scanning is already active, the updated value of scanTimeout will be
     * propagated to the underlying BLE stack.
     */
    ble_error_t setScanTimeout(uint16_t timeout) {
        ble_error_t rc;
        if ((rc = _scanningParams.setTimeout(timeout)) != BLE_ERROR_NONE) {
            return rc;
        }

        /* If scanning is already active, propagate the new settings to the stack. */
        if (scanningActive) {
            return startRadioScan(_scanningParams);
        }

        return BLE_ERROR_NONE;
    }

    /**
     * Set up parameters for GAP scanning (observer mode).
     * @param[in] activeScanning
     *              Set to True if active-scanning is required. This is used to fetch the
     *              scan response from a peer if possible.
     *
     * Once the scanning parameters have been configured, scanning can be
     * enabled by using startScan().
     *
     * If scanning is already in progress, then active-scanning will be enabled
     * for the underlying BLE stack.
     */
    ble_error_t setActiveScanning(bool activeScanning) {
        _scanningParams.setActiveScanning(activeScanning);

        /* If scanning is already active, propagate the new settings to the stack. */
        if (scanningActive) {
            return startRadioScan(_scanningParams);
        }

        return BLE_ERROR_NONE;
    }

    /**
     * Start scanning (Observer Procedure) based on the parameters currently in
     * effect.
     *
     * @param[in] callback
     *              The application-specific callback to be invoked upon
     *              receiving every advertisement report. This can be passed in
     *              as NULL, in which case scanning may not be enabled at all.
     */
    ble_error_t startScan(void (*callback)(const AdvertisementCallbackParams_t *params)) {
        ble_error_t err = BLE_ERROR_NONE;
        if (callback) {
            if ((err = startRadioScan(_scanningParams)) == BLE_ERROR_NONE) {
                scanningActive = true;
                onAdvertisementReport.attach(callback);
            }
        }

        return err;
    }

    /**
     * Same as above, but this takes an (object, method) pair for a callback.
     */
    template<typename T>
    ble_error_t startScan(T *object, void (T::*callbackMember)(const AdvertisementCallbackParams_t *params)) {
        ble_error_t err = BLE_ERROR_NONE;
        if (object && callbackMember) {
            if ((err = startRadioScan(_scanningParams)) == BLE_ERROR_NONE) {
                scanningActive = true;
                onAdvertisementReport.attach(object, callbackMember);
            }
        }

        return err;
    }

    /**
     * Initialize radio-notification events to be generated from the stack.
     * This API doesn't need to be called directly.
     *
     * Radio Notification is a feature that enables ACTIVE and INACTIVE
     * (nACTIVE) signals from the stack that notify the application when the
     * radio is in use.
     *
     * The ACTIVE signal is sent before the radio event starts. The nACTIVE
     * signal is sent at the end of the radio event. These signals can be used
     * by the application programmer to synchronize application logic with radio
     * activity. For example, the ACTIVE signal can be used to shut off external
     * devices, to manage peak current drawn during periods when the radio is on,
     * or to trigger sensor data collection for transmission in the Radio Event.
     *
     * @return BLE_ERROR_NONE on successful initialization, otherwise an error code.
     */
    virtual ble_error_t initRadioNotification(void) {
        return BLE_ERROR_NOT_IMPLEMENTED; /* Requesting action from porter(s): override this API if this capability is supported. */
    }

private:
    ble_error_t setAdvertisingData(void) {
        return setAdvertisingData(_advPayload, _scanResponse);
    }

private:
    virtual ble_error_t setAdvertisingData(const GapAdvertisingData &advData, const GapAdvertisingData &scanResponse) = 0;
    virtual ble_error_t startAdvertising(const GapAdvertisingParams &) = 0;

public:
    /**
     * Accessors to read back currently active advertising params.
     */
    GapAdvertisingParams &getAdvertisingParams(void) {
        return _advParams;
    }
    const GapAdvertisingParams &getAdvertisingParams(void) const {
        return _advParams;
    }

    /**
     * Set up a particular, user-constructed set of advertisement parameters for
     * the underlying stack. It would be uncommon for this API to be used
     * directly; there are other APIs to tweak advertisement parameters
     * individually.
     */
    void setAdvertisingParams(const GapAdvertisingParams &newParams) {
        _advParams = newParams;
    }

    /* Event callback handlers. */
public:
    /**
     * Set up a callback for timeout events. Refer to TimeoutSource_t for
     * possible event types.
     * @note It is possible to unregister callbacks using onTimeout().detach(callback)
     */
    void onTimeout(TimeoutEventCallback_t callback) {
        timeoutCallbackChain.add(callback);
    }

    /**
     * @brief provide access to the callchain of timeout event callbacks
     * It is possible to register callbacks using onTimeout().add(callback);
     * It is possible to unregister callbacks using onTimeout().detach(callback)
     * @return The timeout event callbacks chain
     */
    TimeoutEventCallbackChain_t& onTimeout() {
        return timeoutCallbackChain;
    }

    /**
     * Append to a chain of callbacks to be invoked upon GAP connection.
     * @note It is possible to unregister callbacks using onConnection().detach(callback)
     */
    void onConnection(ConnectionEventCallback_t callback) {connectionCallChain.add(callback);}

    template<typename T>
    void onConnection(T *tptr, void (T::*mptr)(const ConnectionCallbackParams_t*)) {connectionCallChain.add(tptr, mptr);}

    /**
     * @brief provide access to the callchain of connection event callbacks
     * It is possible to register callbacks using onConnection().add(callback);
     * It is possible to unregister callbacks using onConnection().detach(callback)
     * @return The connection event callbacks chain
     */
    ConnectionEventCallbackChain_t& onConnection() {
        return connectionCallChain;
    }

    /**
     * Append to a chain of callbacks to be invoked upon GAP disconnection.
     * @note It is possible to unregister callbacks using onDisconnection().detach(callback)
     */
    void onDisconnection(DisconnectionEventCallback_t callback) {disconnectionCallChain.add(callback);}

    template<typename T>
    void onDisconnection(T *tptr, void (T::*mptr)(const DisconnectionCallbackParams_t*)) {disconnectionCallChain.add(tptr, mptr);}

    /**
     * @brief provide access to the callchain of disconnection event callbacks
     * It is possible to register callbacks using onDisconnection().add(callback);
     * It is possible to unregister callbacks using onDisconnection().detach(callback)
     * @return The disconnection event callbacks chain
     */
    DisconnectionEventCallbackChain_t& onDisconnection() {
        return disconnectionCallChain;
    }

    /**
     * Set the application callback for radio-notification events.
     *
     * Radio Notification is a feature that enables ACTIVE and INACTIVE
     * (nACTIVE) signals from the stack that notify the application when the
     * radio is in use.
     *
     * The ACTIVE signal is sent before the radio event starts. The nACTIVE
     * signal is sent at the end of the radio event. These signals can be used
     * by the application programmer to synchronize application logic with radio
     * activity. For example, the ACTIVE signal can be used to shut off external
     * devices, to manage peak current drawn during periods when the radio is on,
     * or to trigger sensor data collection for transmission in the Radio Event.
     *
     * @param callback
     *          The application handler to be invoked in response to a radio
     *          ACTIVE/INACTIVE event.
     *
     * Or in the other version:
     *
     * @param tptr
     *          Pointer to the object of a class defining the member callback
     *          function (mptr).
     * @param mptr
     *          The member callback (within the context of an object) to be
     *          invoked in response to a radio ACTIVE/INACTIVE event.
     */
    void onRadioNotification(void (*callback)(bool param)) {
        radioNotificationCallback.attach(callback);
    }
    template <typename T>
    void onRadioNotification(T *tptr, void (T::*mptr)(bool)) {
        radioNotificationCallback.attach(tptr, mptr);
    }

    /**
     * Setup a callback to be invoked to notify the user application that the
     * Gap instance is about to shutdown (possibly as a result of a call
     * to BLE::shutdown()).
     *
     * @Note: It is possible to chain together multiple onShutdown callbacks
     * (potentially from different modules of an application) to be notified
     * before the Gap instance is shutdown.
     *
     * @Note: It is also possible to set up a callback into a member function of
     * some object.
     *
     * @Note It is possible to unregister a callback using onShutdown().detach(callback)
     */
    void onShutdown(const GapShutdownCallback_t& callback) {
        shutdownCallChain.add(callback);
    }
    template <typename T>
    void onShutdown(T *objPtr, void (T::*memberPtr)(void)) {
        shutdownCallChain.add(objPtr, memberPtr);
    }

    /**
     * @brief provide access to the callchain of shutdown event callbacks
     * It is possible to register callbacks using onShutdown().add(callback);
     * It is possible to unregister callbacks using onShutdown().detach(callback)
     * @return The shutdown event callbacks chain
     */
    GapShutdownCallbackChain_t& onShutdown() {
        return shutdownCallChain;
    }

public:
    /**
     * Notify all registered onShutdown callbacks that the Gap instance is
     * about to be shutdown and clear all Gap state of the
     * associated object.
     *
     * This function is meant to be overridden in the platform-specific
     * sub-class. Nevertheless, the sub-class is only expected to reset its
     * state and not the data held in Gap members. This shall be achieved by a
     * call to Gap::reset() from the sub-class' reset() implementation.
     *
     * @return BLE_ERROR_NONE on success.
     *
     * @note: Currently a call to reset() does not reset the advertising and
     * scan parameters to default values.
     */
    virtual ble_error_t reset(void) {
        /* Notify that the instance is about to shutdown */
        shutdownCallChain.call(this);
        shutdownCallChain.clear();

        /* Clear Gap state */
        state.advertising = 0;
        state.connected   = 0;

        /* Clear scanning state */
        scanningActive = false;

        /* Clear advertising and scanning data */
        _advPayload.clear();
        _scanResponse.clear();

        /* Clear callbacks */
        timeoutCallbackChain.clear();
        connectionCallChain.clear();
        disconnectionCallChain.clear();
        radioNotificationCallback = NULL;
        onAdvertisementReport     = NULL;

        return BLE_ERROR_NONE;
    }

protected:
    Gap() :
        _advParams(),
        _advPayload(),
        _scanningParams(),
        _scanResponse(),
        state(),
        scanningActive(false),
        timeoutCallbackChain(),
        radioNotificationCallback(),
        onAdvertisementReport(),
        connectionCallChain(),
        disconnectionCallChain() {
        _advPayload.clear();
        _scanResponse.clear();
    }

    /* Entry points for the underlying stack to report events back to the user. */
public:
    void processConnectionEvent(Handle_t                           handle,
                                Role_t                             role,
                                BLEProtocol::AddressType_t         peerAddrType,
                                const BLEProtocol::AddressBytes_t  peerAddr,
                                BLEProtocol::AddressType_t         ownAddrType,
                                const BLEProtocol::AddressBytes_t  ownAddr,
                                const ConnectionParams_t          *connectionParams) {
        state.connected = 1;
        ConnectionCallbackParams_t callbackParams(handle, role, peerAddrType, peerAddr, ownAddrType, ownAddr, connectionParams);
        connectionCallChain.call(&callbackParams);
    }

    void processDisconnectionEvent(Handle_t handle, DisconnectionReason_t reason) {
        state.connected = 0;
        DisconnectionCallbackParams_t callbackParams(handle, reason);
        disconnectionCallChain.call(&callbackParams);
    }

    void processAdvertisementReport(const BLEProtocol::AddressBytes_t        peerAddr,
                                    int8_t                                   rssi,
                                    bool                                     isScanResponse,
                                    GapAdvertisingParams::AdvertisingType_t  type,
                                    uint8_t                                  advertisingDataLen,
                                    const uint8_t                           *advertisingData) {
        AdvertisementCallbackParams_t params;
        memcpy(params.peerAddr, peerAddr, ADDR_LEN);
        params.rssi               = rssi;
        params.isScanResponse     = isScanResponse;
        params.type               = type;
        params.advertisingDataLen = advertisingDataLen;
        params.advertisingData    = advertisingData;
        onAdvertisementReport.call(&params);
    }

    void processTimeoutEvent(TimeoutSource_t source) {
        if (timeoutCallbackChain) {
            timeoutCallbackChain(source);
        }
    }

protected:
    GapAdvertisingParams             _advParams;
    GapAdvertisingData               _advPayload;
    GapScanningParams                _scanningParams;
    GapAdvertisingData               _scanResponse;

    GapState_t                       state;
    bool                             scanningActive;

protected:
    TimeoutEventCallbackChain_t       timeoutCallbackChain;
    RadioNotificationEventCallback_t  radioNotificationCallback;
    AdvertisementReportCallback_t     onAdvertisementReport;
    ConnectionEventCallbackChain_t    connectionCallChain;
    DisconnectionEventCallbackChain_t disconnectionCallChain;

private:
    GapShutdownCallbackChain_t shutdownCallChain;

private:
    /* Disallow copy and assignment. */
    Gap(const Gap &);
    Gap& operator=(const Gap &);
};

#endif // ifndef __GAP_H__
