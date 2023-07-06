import time
import random

class Node:

    def __init__(self, data):
        self.left = None
        self.right = None
        self.data = data

    def insert(self,item):
        if (item < self.data):
            if (self.left != None):
                self.left.insert(item)
            else:
                self.left = Node(item)
        else:
            if (self.right != None):
                self.right.insert(item)
            else:
                self.right = Node(item)

    def length(self):
        if self.data:
            if self.left is None:
                    ll = 0
            else:
                    ll = self.left.length()
            if self.right is None:
                    rr = 0
            else:
                    rr = self.right.length()
            return ll + rr + 1
        else:
            return 0

    def to_list(self):
        if self.data is None :
            return []
        else:
            if self.left is None:
                l = []
            else :
                l = self.left.to_list()
            if self.right is None:
                r = []
            else:
                r = self.right.to_list()
            l.append(self.data)
            l.extend(r)
            return l

    def display(self):
        if self.data is None :
            print (".")
        else :
            print(self.data)
            if self.left is not None :
                self.left.display()
            if self.right is not None :
                self.right.display()

def init(n,f):
    acc = []
    for i in range(0, n):
            acc.append(f(i))
    return acc

def tree_sort(l):
    i = l.pop(0)
    t = Node(i)
    for x in l:
        t.insert(x)
    t.display()
    return t.to_list()

def random_int(x):
    return random.randint(0,x)

def main():
    # start = time.ticks_ms()
    for i in range(0,10000):
        l = init(100,random_int)
    # stop=time.ticks_ms()
    # print(time.ticks_diff(stop,start))

if __name__ == "__main__":
    main()
