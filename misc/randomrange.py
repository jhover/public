#!/bin/env python
import random

def onefive():
    return random.randint(1,5)

def oneseven():
    randsum = 0
    modeight = 0
    while modeight == 0:
        for i in range(1,3):
            randsum += onefive()
            #print("ransum is %d" % randsum)
        modeight = randsum % 8
        #print("modeight is %s" % modeight)
    return modeight

for i in range(0,10000):
    print(oneseven())
    #print(onefive())