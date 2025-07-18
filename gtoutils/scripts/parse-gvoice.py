#!/usr/bin/env python
#
# parse HTML google voice records.  
# Types:   Placed  Text  Received Voicemail
#  
# 
#
#
#
#
#
#
#
#
#
#
#
#
import argparse
import logging
import os
import sys
import traceback

gitpath=os.path.expanduser("~/git/public/gtoutils")
sys.path.append(gitpath)

from gtoutils.utils import * 

 
if __name__ == '__main__':
    FORMAT='%(asctime)s (UTC) [ %(levelname)s ] %(filename)s:%(lineno)d %(name)s.%(funcName)s(): %(message)s'
    logging.basicConfig(format=FORMAT)
    logging.getLogger().setLevel(logging.WARN)
    
    parser = argparse.ArgumentParser()
      
    parser.add_argument('-d', '--debug', 
                        action="store_true", 
                        dest='debug', 
                        help='debug logging')

    parser.add_argument('-v', '--verbose', 
                        action="store_true", 
                        dest='verbose', 
                        help='verbose logging')
       
    parser.add_argument('-o','--outfile', 
                    metavar='outfile',
                    required=True,
                    type=str, 
                    help='Merged Calls TSV file.')  

    parser.add_argument('infiles' ,
                        metavar='infiles', 
                        type=str,
                        nargs='+',
                        default=None, 
                        help="One or more Google takeout Calls files. (html, mp3)")
       
    args= parser.parse_args()
    
    if args.debug:
        logging.getLogger().setLevel(logging.DEBUG)
    if args.verbose:
        logging.getLogger().setLevel(logging.INFO)   

    logging.debug(f'infile={args.infiles} outfile={args.outfile}')

    outfile = os.path.abspath(args.outfile)
    filepath = os.path.abspath(outfile)    
    dirname = os.path.dirname(filepath)
    filename = os.path.basename(filepath)
    (base, ext) = os.path.splitext(filename)   
    head = base.split('.')[0]
    outdir = dirname
    logging.debug(f'outdir set to {outdir}')
       
    outdir = os.path.abspath(outdir)    
    os.makedirs(outdir, exist_ok=True)
        
    parse_calls( args.infiles, 
                 outfile=outfile)
    