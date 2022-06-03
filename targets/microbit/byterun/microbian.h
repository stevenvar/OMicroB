/* microbian.h */
/* Copyright (c) 2018 J. M. Spivey */

#include <stddef.h>

typedef unsigned char byte;

/* Standard pids */
#define HARDWARE -1
#define IDLE 0

/* Common message types */
#define INTERRUPT 1
#define REPLY 2
#define TIMEOUT 3
#define REGISTER 4
#define PING 5
#define REQUEST 6
#define READ 7
#define WRITE 8
#define OK 9
#define ERR 10
#define SEND 11
#define RECEIVE 12
#define ANY -1

/* Possible priorities */
#define P_HANDLER 0             /* Interrupt handler */
#define P_HIGH 1                /* Responsive */
#define P_LOW 2                 /* Normal */
#define P_IDLE 3                /* The idle process */
#define NPRIO 3                 /* Number of non-idle priorities */

typedef struct {                /* 16 bytes */
    unsigned short type;        /* Type of message */
    short sender;               /* PID of sender */
    union {                     /* An integer, a pointer, or four bytes */
        int int1; void *ptr1;
        struct { byte byte1, byte2, byte3, byte4; };
    };
    union { int int2; void *ptr2; }; /* Another integer or pointer */
    union { int int3; void *ptr3; }; /* A third integer or pointer */
} message;


/* microbian.c */

/* start -- create process that will run when init returns; return PID */
int start(char *name, void (*body)(int), int arg, int stksize);

#define STACK 1024              /* Default stack size */

/* SYSTEM CALLS */

/* yield -- voluntarily allow other processes to run */
void yield(void);

/* send -- send a message */
void send(int dst, int type, message *msg);

/* receive -- receive a message */
void receive(int type, message *msg);

/* sendrec -- send followed by receive */
void sendrec(int dst, int type, message *msg);

/* connect -- register to receive interrupt messages */
void connect(int irq);

/* priority -- set process priority */
void priority(int p);

/* exit -- terminate current process */
void exit1(void);

/* dump -- print table of process states (called from serial) */
void dump(void);

/* interrupt -- send interrupt message from handler */
void interrupt(int pid);

/* kprintf -- print message on console without using serial task */
void kprintf(char *fmt, ...);

/* panic -- crash with message and show seven stars */
void panic(char *fmt, ...);

/* badmesg -- panic after receiving unexpected message */
void badmesg(int type);

/* assert -- check assertion and panic if false */
#define assert(p) \
    if (!(p)) panic("File %s, line %d: assertion %s failed", \
                    __FILE__, __LINE__, #p)

/* spin -- flash the seven stars of death forever */
void spin(void);

/* serial.c */
void serial_putc(char ch);
char serial_getc(void);
void serial_init(void);

#define microbit_serial_write serial_putc
#define microbit_serial_read serial_getc

/* timer.c */
void timer_delay(int msec);
void timer_pulse(int msec);
void timer_wait(void);
unsigned timer_now(void);
unsigned timer_micros(void);
void timer_init(void);
int millis(void);


#define delay timer_delay

/* i2c.c */
int i2c_probe(int chan, int addr);
int i2c_read_reg(int chan, int addr, int cmd);
void i2c_write_reg(int chan, int addr, int cmd, int val);
void i2c_read_bytes(int chan, int addr, int cmd, byte *buf, int n);
void i2c_write_bytes(int chan, int addr, int cmd, byte *buf, int n);
int i2c_xfer(int chan, int kind, int addr,
             byte *buf1, int n1, byte *buf2, int n2);
void i2c_init(int chan);

/* radio.c */
#define RADIO_PACKET 128
void radio_group(int group);
void radio_send(void *buf, int n);
int radio_receive(void *buf);
void radio_init(void);

/* display.c */
void display_show(const unsigned *img);
void display_init(void);
extern const unsigned blank[];
void image_clear(unsigned *img);
void image_set(int x, int y, int l, unsigned *img);

void microbit_write_pixel(int x, int y, int l);
void microbit_clear_screen();
void microbit_print_string(const char *buf);

/* gpio.c */
int pad_of_pin(int pin);
int microbit_button_is_pressed(int b);
void microbit_pin_mode(int pin, int mode);
void microbit_digital_write(int pin, int level);
int microbit_digital_read(int pin);

/* adc.c */
int adc_reading(int pin);
void adc_init(void);

/* pwm.c */
void pwm_init(void);
void microbit_analog_write(int pin, int l);

/* accel.c */

int microbit_accelerometer_x();
int microbit_accelerometer_y();
int microbit_accelerometer_z();
