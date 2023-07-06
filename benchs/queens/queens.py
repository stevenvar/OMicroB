import time
#from microbit import *

# pour destructurer une liste non vide
def accessList(l):
#    print("accessList<--",l)
    if (len(l) == 1):
#        print("accessList-->",[l[0],[]])
        return [l[0],[]]
    else:
#        print("accessList-->",l)
        return [l[0],l[1::]]

# val interval : int -> int -> int list
def interval(n,m):
#    return range(n,m+1)
     acc = []
     i = n
     while (i<=m):
         acc.append(i)
         i = i + 1
     return acc

#val concmap : ('a -> 'b list) -> 'a list -> 'b list
def concmap(f,l):
#    print ("concmap<--",l)
    acc = []
    for i in l:
        acc = acc + f(i)
#    print("concmap-->",acc)
    return acc

# val safe : int -> int -> int list -> bool
def safe(d,x,l):
#    print("safe:",l)
    if (l == []):
        return True
    else:
        tete,queue = accessList(l)
        if ((not(x == tete)) and ((not(x == tete+d)) and (not(x == tete-d)))):
            return safe(d+1,x,queue)
        else:
            return False

# val ok : int list -> bool
def ok(l):
    if (l == []):
        return Tru
    else:
        tete,queue = accessList(l)
        return (safe(1,tete,queue))

# val filter : ('a -> bool) -> 'a list -> 'a list
def filter(p,l):
    acc = []
    for e in l:
        if (p(e)):
            acc.append(e)
    return acc


def map(f,l):
    acc = []
    for e in l:
        acc.append(f(e))
    return acc




def queens(n):
    qs = interval(1,n)
    testcol = lambda b : filter(ok, map (lambda q : [q] + b,qs))
    gen = lambda n : [[]] if (n == 0) else concmap(testcol,gen(n-1))
    l = gen(n)
    print(l)
    return(len(l))

def main():
    i = 0
    while (i < 10000):
        j = 0
        while (j <= 6):
            queens(j)
            j = j + 1
        i = i + 1

#display.show(Image.CONFUSED)
main()
#display.show(Image.HAPPY)
