#!/bin/env python
#
# module to expore gold coin problem. 
#
#
#

# Input should be a set consisting of an array of values of 0,1, or 2. All values but one should be 1. 
#
#   i.e.    X = [1,1,1,1,2,1,1,1,1,1,1]  is a set of 11 coins, with coin #5 heavy. 
#
#



class Coin:
    
    HEAVY = 2
    LIGHT = 0
    OK = 1
    
    
    def __init__(self):
        self.weight = None