#ifndef _PERIPHERALS_1XX2XX_H
#define _PERIPHERALS_1XX2XX_H

#define NUM_PPS_IN      45          // This must be set to the highest PPS_IN_xxx value
#define NUM_PPS_OUT     7           // This must be set to the highest PPS_OUT_xxx value

typedef enum {
    PPS_OUT_GPIO    = (0 + (_PPS_SET_A|_PPS_SET_B|_PPS_SET_C|_PPS_SET_D)),

    PPS_OUT_U1TX    = (1 + _PPS_SET_A),
    PPS_OUT_U2RTS   = (2 + _PPS_SET_A),
    PPS_OUT_SS1     = (3 + _PPS_SET_A),
    PPS_OUT_OC1     = (5 + _PPS_SET_A),
    PPS_OUT_C2OUT   = (7 + _PPS_SET_A),

    PPS_OUT_SDO1    = (3 + (_PPS_SET_B | _PPS_SET_C)),
    PPS_OUT_SDO2    = (4 + (_PPS_SET_B | _PPS_SET_C)),
    PPS_OUT_OC2     = (5 + _PPS_SET_B),

    PPS_OUT_OC4     = (5 + _PPS_SET_C),
    PPS_OUT_OC5     = (6 + _PPS_SET_C),
    PPS_OUT_REFCLKO = (7 + _PPS_SET_C),

    PPS_OUT_U1RTS   = (1 + _PPS_SET_D),
    PPS_OUT_U2TX    = (2 + _PPS_SET_D),
    PPS_OUT_SS2     = (4 + _PPS_SET_D),
    PPS_OUT_OC3     = (5 + _PPS_SET_D),
    PPS_OUT_C1OUT   = (7 + _PPS_SET_D),

    PPS_IN_INT1     = (0  + _PPS_SET_D + _PPS_INPUT_BIT),
    PPS_IN_INT2     = (1  + _PPS_SET_C + _PPS_INPUT_BIT),
    PPS_IN_INT3     = (2  + _PPS_SET_B + _PPS_INPUT_BIT),
    PPS_IN_INT4     = (3  + _PPS_SET_A + _PPS_INPUT_BIT),
    PPS_IN_T2CK     = (5  + _PPS_SET_A + _PPS_INPUT_BIT),
    PPS_IN_T3CK     = (6  + _PPS_SET_B + _PPS_INPUT_BIT),
    PPS_IN_T4CK     = (7  + _PPS_SET_C + _PPS_INPUT_BIT),
    PPS_IN_T5CK     = (8  + _PPS_SET_D + _PPS_INPUT_BIT),
    PPS_IN_IC1      = (9  + _PPS_SET_C + _PPS_INPUT_BIT),
    PPS_IN_IC2      = (10 + _PPS_SET_D + _PPS_INPUT_BIT),
    PPS_IN_IC3      = (11 + _PPS_SET_B + _PPS_INPUT_BIT),
    PPS_IN_IC4      = (12 + _PPS_SET_A + _PPS_INPUT_BIT),
    PPS_IN_IC5      = (13 + _PPS_SET_C + _PPS_INPUT_BIT),
    PPS_IN_OCFA     = (17 + _PPS_SET_D + _PPS_INPUT_BIT),
    PPS_IN_OCFB     = (18 + _PPS_SET_C + _PPS_INPUT_BIT),
    PPS_IN_U1RX     = (19 + _PPS_SET_C + _PPS_INPUT_BIT),
    PPS_IN_U1CTS    = (20 + _PPS_SET_B + _PPS_INPUT_BIT),
    PPS_IN_U2RX     = (21 + _PPS_SET_B + _PPS_INPUT_BIT),
    PPS_IN_U2CTS    = (22 + _PPS_SET_C + _PPS_INPUT_BIT),
    PPS_IN_SDI1     = (32 + _PPS_SET_B + _PPS_INPUT_BIT),
    PPS_IN_SS1      = (33 + _PPS_SET_A + _PPS_INPUT_BIT),
    PPS_IN_SDI2     = (35 + _PPS_SET_C + _PPS_INPUT_BIT),
    PPS_IN_SS2      = (36 + _PPS_SET_D + _PPS_INPUT_BIT),
    PPS_IN_REFCLKI  = (45 + _PPS_SET_A + _PPS_INPUT_BIT),

} ppsFunctionType;


#endif
