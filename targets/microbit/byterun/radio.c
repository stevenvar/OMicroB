/* microbian/radio.c */
/* Copyright (c) 2020 J. M. Spivey */

#include "microbian.h"
#include "hardware.h"
#include <string.h>

/* RADIO_TASK -- process id for device driver */
static int RADIO_TASK;

/* Operating modes */
#define ASLEEP 0                /* Doing nothing */
#define AWAKE 1                 /* Initialised for reception */
#define LISTENING 2             /* Waiting for a packet, DMA set up */

#define FREQ 7                  /* Frequency 2407 MHz */

/* We use a packet format that agrees with the standard micro:bit
runtime.  That means prefixing the packet with three bytes (version,
group, protocol) and counting these three in the length: the STATLEN
feature of the radio is not used. */

static struct {
    byte length;                /* Packet length, including 3-byte prefix */
    byte version;               /* Version: always 1 */
    byte group;                 /* Radio group */
    byte protocol;              /* Protocol identifier: always 1 */
    byte data[RADIO_PACKET];    /* Payload */
} packet_buffer;

/* group -- group id for radio messages */
static volatile int group = 0;

/* init_radio -- initialise radio hardware */
static void init_radio()
{
    RADIO.TXPOWER = 0;          /* Default transmit power */
    RADIO.FREQUENCY = FREQ;     /* Transmission frequency */
    RADIO.MODE = RADIO_MODE_NRF_1Mbit; /* 1Mbit/sec data rate */
    RADIO.BASE0 = 0x75626974;   /* That spells 'ubit' */
    RADIO.TXADDRESS = 0;        /* Use address 0 for transmit */
    RADIO.RXADDRESSES = BIT(0); /*   and also (just one) for receive. */

    /* Basic configuration */
    RADIO.PCNF0 = FIELD(RADIO_PCNF0_LFLEN, 8); /* One 8-bit length field */
    RADIO.PCNF1 = BIT(RADIO_PCNF1_WHITEEN) /* Whitening enabled */
        | FIELD(RADIO_PCNF1_BALEN, 4) /* Base address is 4 bytes */
        | FIELD(RADIO_PCNF1_MAXLEN, RADIO_PACKET+3)
                                /* Max packet length allows for 3 byte prefix */
        | FIELD(RADIO_PCNF1_ENDIAN, RADIO_ENDIAN_Little);
                                /* Fields transmitted LSB first */

    /* CRC and whitening settings -- match micro_bit runtime */
    RADIO.CRCCNF = 2;           /* CRC is 2 bytes */
    RADIO.CRCINIT = 0xffff;
    RADIO.CRCPOLY = 0x11021;
    RADIO.DATAWHITEIV = 0x18;
}

/* radio_await -- wait for expected interrupt */
static void radio_await(unsigned volatile *event)
{
    receive(INTERRUPT, NULL);
    assert(*event);
    *event = 0;
    clear_pending(RADIO_IRQ);
    enable_irq(RADIO_IRQ);
}

/* radio_task -- device driver for radio */
static void radio_task(int dummy)
{
    int mode = ASLEEP;
    int listener = 0;
    int n;
    void *buffer = NULL;
    message m;

    init_radio();

    /* Configure interrupts */
    RADIO.INTENSET =
        BIT(RADIO_INT_READY) | BIT(RADIO_INT_END) | BIT(RADIO_INT_DISABLED);
    connect(RADIO_IRQ);
    enable_irq(RADIO_IRQ);

    /* Set packet buffer */
    RADIO.PACKETPTR = &packet_buffer;

    while (1) {
        receive(ANY, &m);
        switch (m.type) {
        case INTERRUPT:
            /* A packet has been received */
            if (!RADIO.END || mode != LISTENING)
                panic("unexpected radio interrrupt");
            RADIO.END = 0;
            clear_pending(RADIO_IRQ);
            enable_irq(RADIO_IRQ);

            if (RADIO.CRCSTATUS == 0 || packet_buffer.group != group) {
                /* Ignore the packet and listen again */
                RADIO.START = 1;
                break;
            }

            n = packet_buffer.length-3;
            memcpy(buffer, packet_buffer.data, n);

            m.int1 = n;
            send(listener, REPLY, &m);
            mode = AWAKE;
            break;

        case RECEIVE:
            if (mode == LISTENING)
                panic("radio supports only one listener at a time");
            listener = m.sender;
            buffer = m.ptr1;

            if (mode == ASLEEP) {
                RADIO.RXEN = 1;
                radio_await(&RADIO.READY);
            }

            RADIO.PREFIX0 = group;
            RADIO.START = 1;
            mode = LISTENING;
            break;

        case SEND:
            if (mode != ASLEEP) {
                /* The radio was set up for receiving: disable it */
                RADIO.DISABLE = 1;
                radio_await(&RADIO.DISABLED);
            }

            /* Assemble the packet */
            n = m.int2;
            packet_buffer.length = n+3;
            packet_buffer.version = 1;
            packet_buffer.group = group;
            packet_buffer.protocol = 1;
            memcpy(packet_buffer.data, m.ptr1, n);

            /* Enable for sending and transmit the packet */
            RADIO.TXEN = 1;
            radio_await(&RADIO.READY);
            RADIO.PREFIX0 = group;
            RADIO.START = 1;
            radio_await(&RADIO.END);

            /* Disable the transmitter -- otherwise it jams the airwaves */
            RADIO.DISABLE = 1;
            radio_await(&RADIO.DISABLED);

            if (mode != LISTENING)
                mode = ASLEEP;
            else {
                /* Go back to listening */
                RADIO.RXEN = 1;
                radio_await(&RADIO.READY);
                RADIO.START = 1;
            }

            send(m.sender, REPLY, NULL);
            break;

        default:
            badmesg(m.type);
        }
    }
}

/* radio_group -- set group id for radio messages */
void radio_group(int grp)
{
    group = grp;
}

/* radio_send -- send radio packet */
void radio_send(void *buf, int n)
{
    message m;
    m.ptr1 = buf;
    m.int2 = n;
    sendrec(RADIO_TASK, SEND, &m);
}

/* radio_receive -- receive radio packet and return length */
int radio_receive(void *buf)
{
    /* buf must have space for RADIO_PACKET bytes */
    message m;
    m.ptr1 = buf;
    sendrec(RADIO_TASK, RECEIVE, &m);
    return m.int1;
}
    
/* radio_init -- start device driver */
void radio_init(void)
{
    RADIO_TASK = start("Radio", radio_task, 0, 256);
}
