/* i2c.c */
/* Copyright (c) 2019 J. M. Spivey */

#include "microbian.h"
#include "hardware.h"
#include <stddef.h>

/* On the V1, there is only one I2C interface, but on the V2 there are
separate interfaces for internal and external devices.  A client
program should call i2c_init passing I2C_INTERNAL or I2C_EXTERNAL (or
once for each) according to its needs.  On the V1 board, these two
constants are equal, and we'll make sure that only one driver process
is started. */

static int I2C_TASK[N_I2C];

/* i2c_pins -- pin assignments for I2C interfaces */
static struct {
    unsigned scl;               /* I2C clock pin */
    unsigned sda;               /* I2C data pin */
    int irq;                    /* Interrupt number */
} i2c_pins[N_I2C] = {
#ifdef UBIT_V1
    { I2C_SCL, I2C_SDA, I2C_IRQ },
#endif
#ifdef UBIT_V2
    { I2C0_SCL, I2C0_SDA, I2C0_IRQ },
    { I2C1_SCL, I2C1_SDA, I2C1_IRQ }
#endif
};

/* i2c_wait -- wait for an expected interrupt event and detect error */
static int i2c_wait(int chan, unsigned volatile *event)
{
    int irq = i2c_pins[chan].irq;

    receive(INTERRUPT, NULL);

    if (I2C[chan]->ERROR) {
        I2C[chan]->ERROR = 0; 
        clear_pending(irq);
        enable_irq(irq);
        return ERR;
    }      

    assert(*event);
    *event = 0;                                 
    clear_pending(irq);
    enable_irq(irq);
    return OK;
}

/* i2c_do_write -- send one or more bytes */
static int i2c_do_write(int chan, char *buf, int n)
{
    int status = OK;

    /* The I2C hardware makes zero-length writes impossible, because
       there is no event generated when the address has been sent. */

    for (int i = 0; i < n; i++) {
        I2C[chan]->TXD = buf[i];
        status = i2c_wait(chan, &I2C[chan]->TXDSENT);
        if (status != OK) return status;
    }

    return OK;
}

/* i2c_stop -- signal stop condition */
static void i2c_stop(int chan)
{
    I2C[chan]->STOP = 1;
    i2c_wait(chan, &I2C[chan]->STOPPED);
}

/* i2c_task -- driver process for I2C hardware */
static void i2c_task(int chan)
{
    message m;
    int client, addr, n1, n2, status, error = 0;
    char *buf1, *buf2;

    /* Configure I2C hardware */
    I2C[chan]->PSELSCL = i2c_pins[chan].scl;
    I2C[chan]->PSELSDA = i2c_pins[chan].sda;
    I2C[chan]->FREQUENCY = I2C_FREQUENCY_100kHz;
    I2C[chan]->ENABLE = I2C_ENABLE_Enabled;

    /* Enable interrupts */
    I2C[chan]->INTEN = BIT(I2C_INT_RXDREADY) | BIT(I2C_INT_TXDSENT)
        | BIT(I2C_INT_STOPPED) | BIT(I2C_INT_ERROR);
    connect(i2c_pins[chan].irq);
    enable_irq(i2c_pins[chan].irq);

    while (1) {
        receive(ANY, &m);
        client = m.sender;
        addr = m.byte1;        /* Address [0..127] without R/W flag */
        n1 = (int) m.byte2;          /* Number of bytes in command */
        n2 = (int) m.byte3;          /* Number of bytes to transfer (R/W) */
        buf1 = (char*) m.ptr2;        /* Buffer for command */
        buf2 = (char*) m.ptr3;        /* Buffer for transfer */

        switch (m.type) {
        case READ:
            I2C[chan]->ADDRESS = addr;
            status = OK;
             
            if (n1 > 0) {
                /* Write followed by read, with repeated start */
                I2C[chan]->STARTTX = 1;
                status = i2c_do_write(chan, buf1, n1);
            }

            /* The hardware reference manual is wrong in several ways,
               but the following code (based on timing diagrams in the
               reference manual) works reliably. */

            if (status == OK) {
                for (int i = 0; i < n2; i++) {
                    /* On all but the last byte, use SUSPEND to send
                       an ACK after receiving the byte.  Use STOP to
                       send a NACK at the end. */
                    if (i < n2-1)
                        I2C[chan]->SHORTS = BIT(I2C_BB_SUSPEND);
                    else
                        I2C[chan]->SHORTS = BIT(I2C_BB_STOP);
        
                    /* Start the first byte with STARTTX, and the rest
                       with RESUME following the SUSPEND. */
                    if (i == 0)
                        I2C[chan]->STARTRX = 1;
                    else
                        I2C[chan]->RESUME = 1;
        
                    status = i2c_wait(chan, &I2C[chan]->RXDREADY);
                    if (status != OK) break;
                    buf2[i] = I2C[chan]->RXD;
                }
            }
            
            if (status == OK)
                i2c_wait(chan, &I2C[chan]->STOPPED);

            if (status != OK) {
                i2c_stop(chan);
                error = I2C[chan]->ERRORSRC;
                I2C[chan]->ERRORSRC = I2C_ERRORSRC_All;
            }

            I2C[chan]->SHORTS = 0;
            m.int1 = status;
            m.int2 = error;
            send(client, REPLY, &m);
            break;

        case WRITE:
            I2C[chan]->ADDRESS = addr;
            status = OK;

            /* A single write transaction */
            I2C[chan]->STARTTX = 1;
            if (n1 > 0)
                status = i2c_do_write(chan, buf1, n1);
            if (status == OK && n2 > 0)
                status = i2c_do_write(chan, buf2, n2);
            i2c_stop(chan);

            if (status != OK) {
                error = I2C[chan]->ERRORSRC;
                I2C[chan]->ERRORSRC = I2C_ERRORSRC_All;
            }
               
            m.int1 = status;
            m.int2 = error;
            send(client, REPLY, &m);
            break;

        default:
            badmesg(m.type);
        }
    }
}

/* i2c_init -- start I2C driver process */
void i2c_init(int chan)
{
    if (I2C_TASK[chan] == 0)
        I2C_TASK[chan] = start("I2C", i2c_task, chan, 256);
}

/* i2c_xfer -- i2c transaction with command write then data read or write */
int i2c_xfer(int chan, int kind, int addr,
             byte *buf1, int n1, byte *buf2, int n2) {
    message m;
    m.byte1 = addr;
    m.byte2 = n1;
    m.byte3 = n2;
    m.ptr2 = buf1;
    m.ptr3 = buf2;
    send(I2C_TASK[chan], kind, &m);
    receive(REPLY, &m);
    return m.int1;
}

/* i2c_probe -- try to access an I2C device */
int i2c_probe(int chan, int addr)
{
    byte buf = 0;
    return i2c_xfer(chan, WRITE, addr, &buf, 1, NULL, 0);
}
     
/* i2c_read_bytes -- send command and read multi-byte result */
void i2c_read_bytes(int chan, int addr, int cmd, byte *buf2, int n2)
{
    byte buf1 = cmd;
    int status = i2c_xfer(chan, READ, addr, &buf1, 1, buf2, n2);
    assert(status == OK);
}

/* i2c_read_reg -- send command and read one byte */
int i2c_read_reg(int chan, int addr, int cmd)
{
    byte buf;
    i2c_read_bytes(chan, addr, cmd, &buf, 1);
    return buf;
}

/* i2c_write_bytes -- send command and write multi-byte data */
void i2c_write_bytes(int chan, int addr, int cmd, byte *buf2, int n2)
{
    byte buf1 = cmd;
    int status = i2c_xfer(chan, WRITE, addr, &buf1, 1, buf2, n2);
    assert(status == OK);
}

/* i2c_write_reg -- send command and write data */
void i2c_write_reg(int chan, int addr, int cmd, int val)
{
    byte buf = val;
    i2c_write_bytes(chan, addr, cmd, &buf, 1);
}
