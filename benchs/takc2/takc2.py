import time
#from microbit import *

def takc(t):
    x,y,z = t
    if (x > y):
        return takc((takc((x-1, y, z)), takc((y-1,z,x)), takc((z-1, x, y))))
    else:
        return z



def test_takc(n):
    r = 0
    i = 0 
    while (i< n):
        r=r+takc((3,2,1))
        i = i + 1
    return r

#display.show(Image.CONFUSED)
test_takc(200000)
#display.show(Image.HAPPY)

