#!/usr/bin/env python3
from __future__ import print_function
import serial, sys
from time import sleep

# based on https://gist.github.com/calvinli/520373545ea83105a527
# by Calvin Li, 2015-04-03

# command-line argument is the port the Arduino is on
serialPort = sys.argv[1]
print("Resetting the Arduino at {}... ".format(serialPort), end="")

# First we open and close the port at some normal baudrate.
ser = serial.Serial(port=serialPort, baudrate=115200)
ser.close()

# Now, we open the port at the magic 1200 baud.
ser.baudrate = 1200
ser.open()

# Tricky, completely undocumented bit: RTS must be HIGH and DTR LOW.
# Otherwise absolutely nothing happens!
ser.setRTS(True)
ser.setDTR(False)

# Close the 1200 baud connection, triggering a reset of the Arduino.
ser.close()

print("done.")

sleep(3)
