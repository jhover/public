#!/bin/env python
#
# Module implementing suffix trees
#
#

import logging

NODEIDX=0

class SuffixTree(object):
    '''
    Object representation of a full Suffix Tree. 
    '''

    def __init__(self, instring=None):
        self.text = instring
        self.rootnode = SuffixNode()
        if instring is not None:
            self.addString(instring)


 
    def addString(self, st):
        for p in SuffixTree._prefixes(st):
            self._addSubstring(p)
            
    def _addSubstring(self,st):
        print("Adding substring %s" % st)
        
    def dotOut(self):
        ''' Create a .dot file for input into GraphViz/Dot to make diagram of the suffix tree
        Returns string of DOT language describing this tree. 
        
        digraph G {
            0 -> 1 [ label="X"] ;
            0 -> 2 [ label = "XY" ]; 
        }        
        '''
        s = "digraph G {\n"
        
        
        s += "}"
        

    def _prefixes(cls, st):
        '''
        Generator that produces all prefixes of a string. 
        
        '''
        for i in range(0, len(st)+1):
            yield st[0:i]
    _prefixes = classmethod(_prefixes)


class SuffixString(object):
    '''
    Input string wrapper to store extra information. 
    
    '''
    def __init__(self, instring=None, name=None, meta=None):
        self.instring = instring
        self.name = name
        self.meta = None


class SuffixNode(object):
    '''
    
    '''
    def __init__(self, parent=None, childedge=None):
        self.name = NODEIDX
        NODEIDX = NODEIDX + 1
        if parent is None:
            self.parentedge = self
        self.childedges = []
        if childedge is not None:
            self.childedges.append(childedge)

    def addEdge(self, childedge):
        self.childedges.append(childedge)
        

class SuffixEdge(object): 

    def __init__(self, firstcharidx, lastcharidx, parent):
        self.first_char_index = firstcharidx
        self.last_char_index = lastcharidx
        self.parent = parent
        self.end_node = None
        self.start_node = None

    def insert():
        pass

    def remove():
        pass
 
    def splitEdge(self, suffix):
        pass

    def findEdge(node, char):
        pass
    findEdge=classmethod(findEdge)

    def hashEdge(node, char):
        pass
    hashEdge=classmethod(hashEdge)


        
    def pathString(self):
        pass
        
        
        

if __name__ == "__main__":
    print("SuffixTree tests...")
    txt = "abracadabracacao"
    st = SuffixTree(txt)
    
    
    