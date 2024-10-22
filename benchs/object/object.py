import time
import random
class Point:
    def __init__(self, x,y):
        self.x = x
        self.y = y
    
    def sym(self):
        return (Point(-self.x,-self.y))

def main():
    start = time.ticks_ms()
    for i in range(0,10):
        for j in range(0,10):
            o = Point(random.randint(0,100),random.randint(0,100))
            for k in range (0,10):
                o.sym()
    stop=time.ticks_ms()
    print(time.ticks_diff(stop,start))

if __name__ == "__main__":
    main()
