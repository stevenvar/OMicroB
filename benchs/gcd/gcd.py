from microbit import *

def gcd(m,n):
    while (m !=  n): 
        if (m < n):
            n = n-m
        else:
            m =  m-n 
    return m

def repeat(n):
    r = 0
    i = 0 
    while (i< n):
        r=r+gcd(500001,500003)
        i = i + 1
    return r

def go(n):
    repeat(n)

display.show(Image.CONFUSED)
go(10)
display.show(Image.HAPPY)
