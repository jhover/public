#!/bin/env python
# 
# 
#
#
#
#
#
#
#

from suffix import SuffixTree, SuffixNode
        
        
if __name__ == '__main__':
    print("Weeder!")
    usage = '''Usage: weeder [OPTIONS] -s <INFILE>
    -l <INT>     motif length
    -d <INT>     max mismatch"
    -q <INT>     minimum distinct sources"
    -s <INFILE>  input file (FASTA)"
    [-D]         debug" 
    [-v]         verbose" 
    [-R]         exclude reverse complement"
    [-S <INT> ]  randomly choose from samples
Report bugs to <john@saros.us>'''
    print(usage)            