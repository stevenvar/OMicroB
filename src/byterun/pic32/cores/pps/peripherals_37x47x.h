#ifndef _PERIPHERALS_37X47X_H
#define _PERIPHERALS_37X47X_H

#define NUM_PPS_IN      51          // This must be set to the highest PPS_IN_xxx value
#define NUM_PPS_OUT     0b1111      // This must be set to the highest PPS_OUT_xxx value

typedef enum {
    PPS_OUT_GPIO    = (0 + (_PPS_SET_A|_PPS_SET_B|_PPS_SET_C|_PPS_SET_D)),

    PPS_OUT_U3TX    = (0b0001 + _PPS_SET_A),
    PPS_OUT_U4RTS   = (0b0010 + _PPS_SET_A),
    PPS_OUT_SDO2    = (0b0110 + (_PPS_SET_A | _PPS_SET_B)),
    PPS_OUT_OC3     = (0b1011 + _PPS_SET_A),
    PPS_OUT_C2OUT   = (0b1101 + _PPS_SET_A),

    PPS_OUT_U2TX    = (0b0001 + _PPS_SET_B),
    PPS_OUT_U1TX    = (0b0011 + _PPS_SET_B),
    PPS_OUT_U5RTS   = (0b0100 + _PPS_SET_B),
    PPS_OUT_SDO1    = (0b1000 + (_PPS_SET_B | _PPS_SET_C | _PPS_SET_D)),
    PPS_OUT_OC4     = (0b1011 + _PPS_SET_B),

    PPS_OUT_U3RTS   = (0b0001 + _PPS_SET_C),
    PPS_OUT_U4TX    = (0b0010 + _PPS_SET_C),
    PPS_OUT_REFCLKO = (0b0011 + _PPS_SET_C),
    PPS_OUT_U5TX    = (0b0100 + (_PPS_SET_C | _PPS_SET_D)),
    PPS_OUT_SS1     = (0b0111 + _PPS_SET_C),
    PPS_OUT_OC5     = (0b1011 + _PPS_SET_C),
    PPS_OUT_C1OUT   = (0b1101 + _PPS_SET_C),

    PPS_OUT_U2RTS   = (0b0001 + _PPS_SET_D),
    PPS_OUT_U1RTS   = (0b0011 + _PPS_SET_D),
    PPS_OUT_SS2     = (0b0110 + _PPS_SET_D),
    PPS_OUT_OC2     = (0b1011 + _PPS_SET_D),
    PPS_OUT_OC1     = (0b1100 + _PPS_SET_D),

    PPS_IN_INT1 = (0 + _PPS_SET_D + _PPS_INPUT_BIT),
    PPS_IN_INT2 = (1 + _PPS_SET_C + _PPS_INPUT_BIT),
    PPS_IN_INT3 = (2 + _PPS_SET_A + _PPS_INPUT_BIT),
    PPS_IN_INT4 = (3 + _PPS_SET_B + _PPS_INPUT_BIT),
    PPS_IN_T2CK = (5 + _PPS_SET_A + _PPS_INPUT_BIT),
    PPS_IN_T3CK = (6 + _PPS_SET_D + _PPS_INPUT_BIT),
    PPS_IN_T4CK = (7 + _PPS_SET_C + _PPS_INPUT_BIT),
    PPS_IN_T5CK = (8 + _PPS_SET_B + _PPS_INPUT_BIT),
    PPS_IN_IC1 = (9 + _PPS_SET_D + _PPS_INPUT_BIT),
    PPS_IN_IC2 = (10 + _PPS_SET_C + _PPS_INPUT_BIT),
    PPS_IN_IC3 = (11 + _PPS_SET_A + _PPS_INPUT_BIT),
    PPS_IN_IC4 = (12 + _PPS_SET_B + _PPS_INPUT_BIT),
    PPS_IN_IC5 = (13 + _PPS_SET_C + _PPS_INPUT_BIT),
    PPS_IN_OCFA = (17 + _PPS_SET_D + _PPS_INPUT_BIT),
    PPS_IN_U1RX = (19 + _PPS_SET_A + _PPS_INPUT_BIT),
    PPS_IN_U1CTS = (20 + _PPS_SET_C + _PPS_INPUT_BIT),
    PPS_IN_U2RX = (21 + _PPS_SET_A + _PPS_INPUT_BIT),
    PPS_IN_U2CTS = (22 + _PPS_SET_C + _PPS_INPUT_BIT),
    PPS_IN_U3RX = (23 + _PPS_SET_B + _PPS_INPUT_BIT),
    PPS_IN_U3CTS = (24 + _PPS_SET_D + _PPS_INPUT_BIT),
    PPS_IN_U4RX = (25 + _PPS_SET_D + _PPS_INPUT_BIT),
    PPS_IN_U4CTS = (26 + _PPS_SET_B + _PPS_INPUT_BIT),
    PPS_IN_U5RX = (27 + _PPS_SET_D + _PPS_INPUT_BIT),
    PPS_IN_U5CTS = (28 + _PPS_SET_A + _PPS_INPUT_BIT),
    PPS_IN_SDI1 = (32 + _PPS_SET_B + _PPS_INPUT_BIT),
    PPS_IN_SS1 = (33 + _PPS_SET_C + _PPS_INPUT_BIT),
    PPS_IN_SDI2 = (35 + _PPS_SET_B + _PPS_INPUT_BIT),
    PPS_IN_SS2 = (36 + _PPS_SET_D + _PPS_INPUT_BIT),
    PPS_IN_REFCLKI = (51 + _PPS_SET_A + _PPS_INPUT_BIT),

} ppsFunctionType;

#endif
