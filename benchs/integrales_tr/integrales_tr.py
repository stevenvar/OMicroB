import time
# from microbit import *

def integrale(f, a, b, n):
    accu = 0.0
    x = a
    h = (b - a) / n
    while (x< b):
        accu = accu + f(x) ;
        x = x+ h
    return accu
  
def poly(x):
    return x * x + 2 * x + 1

def test_integrales(n):
    t = 2.333583335
    eps = 0.001
    r = 0.0
    i = 0
    while (i< n):
        r= r + integrale(poly,0.0,1.0,10000)
        i = i + 1
    return r



# display.show(Image.CONFUSED)
test_integrales(4000)
# display.show(Image.HAPPY)
