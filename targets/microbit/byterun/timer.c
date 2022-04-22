/* timer.c */
/* Copyright (c) 2018-2020 J. M. Spivey */

#include "microbian.h"
#include "hardware.h"

static int TIMER_TASK;

#ifdef UBIT_V2
#define TICK 1                  /* Interval between updates (ms) */
#endif

#ifndef TICK
#define TICK 5                  /* Sensible default */
#endif

#define MAX_TIMERS 8

/* Millis will overflow in about 46 days, but that's long enough. */

/* millis -- milliseconds since boot */
static unsigned millis = 0;

/* timer -- array of data for pending timer messages */
static struct {
    int client;      /* Process that receives message, or -1 if empty */
    unsigned period; /* Interval between messages, or 0 for one-shot */
    unsigned next;   /* Next time to send a message */
} timer[MAX_TIMERS];

/* check_timers is called by the timer task and sends messages
   directly to clients.  We assume that each client is waiting to
   receive a PING message: otherwise the progress of the entire system
   will be held up, possibly leading to deadlock. */

/* check_timers -- send any messages that are due */
static void check_timers(void)
{
    int i;
    message m;

    for (i = 0; i < MAX_TIMERS; i++) {
        if (timer[i].client >= 0 && millis >= timer[i].next) {
            m.int1 = timer[i].next;
            send(timer[i].client, PING, &m);

            if (timer[i].period > 0)
                timer[i].next += timer[i].period;
            else
                timer[i].client = -1;

        }
    }
}

/* create -- create a new timer */
static void create(int client, int delay, int repeat)
{
    int i = 0;

    while (i < MAX_TIMERS && timer[i].client >= 0)
        i++;

    if (i == MAX_TIMERS)
        panic("Too many timers");

    /* If we are between ticks when the timer is created, then the
       timer will go off up to one tick early.  We could add on a tick
       to compensate for this, but most applications work better
       without it.  Effectively, the delay is counted from the
       previous timer tick, and if it is created as a response to that
       tick, then the effect is what is usually wanted. */

    timer[i].client = client;
    timer[i].next = millis + delay;
    timer[i].period = repeat;
}

/* timer1_handler -- interrupt handler */
void timer1_handler(void)
{
    /* Update the time here so it is accessible to timer_micros */
    if (TIMER1.COMPARE[0]) {
        millis += TICK;
        TIMER1.COMPARE[0] = 0;
        interrupt(TIMER_TASK);
    }
}

static void timer_task(int n)
{
    message m;

    /* We use Timer 1 because its 16-bit mode is adequate for a clock
       with up to 1us resolution and 1ms period, leaving the 32-bit
       Timer 0 for other purposes. */
    TIMER1.STOP = 1;
    TIMER1.MODE = TIMER_MODE_Timer;
    TIMER1.BITMODE = TIMER_BITMODE_16Bit;
    TIMER1.PRESCALER = 4;      /* 1MHz = 16MHz / 2^4 */
    TIMER1.CLEAR = 1;
    TIMER1.CC[0] = 1000 * TICK;
    TIMER1.SHORTS = BIT(TIMER_COMPARE0_CLEAR);
    TIMER1.INTENSET = BIT(TIMER_INT_COMPARE0);
    TIMER1.START = 1;
    enable_irq(TIMER1_IRQ);
    priority(P_HANDLER);

    while (1) {
        receive(ANY, &m);

        switch (m.type) {
        case INTERRUPT:
            check_timers();
            break;

        case REGISTER:
            create(m.sender, m.int1, m.int2);
            break;

        default:
            badmesg(m.type);
        }
    }
}

/* timer_init -- start the timer task */
void timer_init(void)
{
    int i;

    for (i = 0; i < MAX_TIMERS; i++)
        timer[i].client = -1;

    TIMER_TASK = start("Timer", timer_task, 0, 256);
}

/* timer_now -- return current time in milliseconds since startup */
unsigned timer_now(void)
{
    return millis;
}

/* The result of timer_micros will overflow after 71 minutes, but even
if it does overflow, shorter durations can be measured by taking the
difference of two readings with unsigned subtraction. */

/* timer_micros -- return microseconds since startup */
unsigned timer_micros(void)
{
    unsigned my_millis, ticks1, ticks2, extra;
    
    /* We must allow for the possibility the timer has expired but the
       interrupt has not yet been handled. Worse, the timer expiry
       could happen between looking at the timer and looking at the
       interrupt flag.  The approach is to take two readings with
       interrupts disabled, one before and one after checking the
       flag.  If the flag is set, but the value has not gone down
       between the two readings, that indicates the expiry happened
       before the first reading, so an extra tick should be added.*/

    intr_disable();
    TIMER1.CAPTURE[1] = 1;      /* Capture count before testing event */
    extra = TIMER1.COMPARE[0];  /* Inspect the expiry event */
    TIMER1.CAPTURE[2] = 1;      /* Capture count afterwards */
    ticks1 = TIMER1.CC[1];
    ticks2 = TIMER1.CC[2];
    my_millis = millis;
    intr_enable();

    /* Correct my_millis if the timer expired */
    if (extra && ticks1 <= ticks2) my_millis += TICK;

    return 1000 * my_millis + ticks1;
}

/* timer_delay -- one-shot delay */
void timer_delay(int msec)
{
    message m;
    m.int1 = msec;
    m.int2 = 0;                 /* Don't repeat */
    send(TIMER_TASK, REGISTER, &m);
    receive(PING, NULL);
}

/* timer_pulse -- regular pulse */
void timer_pulse(int msec)
{
    message m;
    m.int1 = msec;
    m.int2 = msec;              /* Repetitive */
    send(TIMER_TASK, REGISTER, &m);
}

/* wait -- sleep until next timer pulse */
void timer_wait(void)
{
    receive(PING, NULL);
}
