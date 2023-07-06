# from microbit import *

def fibo(n):
    if n < 2:
        return n
    else:
        return (fibo(n-1)+fibo(n-2))

def test_fibo(n):
    i = 0
    while (i< n):
        fibo(5);
        i = i + 1

# display.show(Image.CONFUSED)
test_fibo(1000000)
# display.show(Image.HAPPY)
