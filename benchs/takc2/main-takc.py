import pyb
import time

def takc(triplet):
    x, y, z = triplet
    if (x > y):
	a1 = takc((x-1, y, z))
        a2 = takc((y-1, z, x))
        a3 = takc((z-1, x, y))
        a = (a1, a2, a3)
        return takc(a)
    else:
        return z



def test_takc(n):
    r = 0
    i = 0
    while (i< n):
        r=r+takc((18,12,6))
        i = i + 1
    return r

def go(n):
    debut = time.ticks_ms()
    r = test_takc(n)
    fin = time.ticks_ms()
    duree = time.ticks_diff(fin, debut)
    if  ((duree > 14000) and (duree < 15000)): 
        pyb.LED(2).on()
        print ([r,debut,fin,duree])

pyb.LED(1).on()
go(1)
pyb.LED(3).on()



