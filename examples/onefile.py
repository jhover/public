#!/bin/env python3
#
# Pretty standard template for code to be used 
# from CLI, from Jupyter/iPython, or as a library
#
#  cat ~/etc/myconfig.conf
#  [DEFAULTS]
#  loglevel=debug
#
#  [mydatastructure]
#   myattribute1=spearman   # spearman|pearson
#

import argparse
import os
from configparser import ConfigParser
import pandas as pd

################### Library/iPython/Jupyter ###########################

class MyDataStructure(object):
    '''
    Classes can be used directly from ipython/Jupyter, or built in library code. 
    Demonstrates pulling function/class-specific config from general congfig. 
    
    '''
    def __init__(self, config, dataframe):
        self.config = config
        self.myattribute = config.get('mydatastructure', 'myattribute')
        self.df = dataframe
        
    def do_stuff(self):
        pass
        
    def __repr__(self):
        ''' Provide some printable/loggable representation. 
        '''
        return f"MyDataStructure: shape={self.df.shape}"
        

def get_default_config():
    '''
    For use from iPython/Jupyter
    '''
    cp = ConfigParser()
    cp.read(os.path.expanduser("~/etc/myconfig.conf"))
    return cp

def my_generic_function(config, dataframe):
    '''
    For use from iPython/Jupyter or as library code.
     
    '''
    myds = MyDataStructure(config, dataframe )
    myds.do_stuff()


######### Used from CLI ( or from iPython/Jupyter) ############

def my_run_function(config, 
                    infile='/path/to/default/infile', 
                    outfile='/path/to/default/outfile'):
    '''
    CLI/OS-level API and interactions. File I/O. 
    '''
    indf = pd.read_csv(infile, index_col=0)


if __name__ == '__main__':
    '''
    Main function handles CL interface. 
    
    '''
    
    parser = argparse.ArgumentParser()
    parser.add_argument('-c', '--config', 
                        action="store", 
                        dest='conffile', 
                        default='~/etc/cafa4.conf',
                        help='Config file path [~/etc/myconfig.conf]')
    parser.add_argument('-i','--infile', 
                               metavar='infile',
                               default='/path/to/default', 
                               type=str, 
                               help='a .fasta sequence files')
    parser.add_argument('-o','--outfile', 
                               metavar='outfile', 
                               default='/path/to/default', 
                               type=str, 
                               help='a processed DF .csv file')
    args= parser.parse_args()
    cp = ConfigParser()
    cp.read(os.path.expanduser(args.conffile))
    
    my_run_function(cp, 
                args.infile,   #  list of infiles
                args.outfile,   #  plot is <outfile>.png 
                )