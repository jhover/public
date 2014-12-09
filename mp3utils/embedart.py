#!/bin/env python
#
# Simple script to embed folder/album art into mp3 files.
# 
# Requires: id3-python
#
#
#

import logging
import getopt
import sys
import os

# Regular expression globs
# Filetypes MP3, M4A, GIF, JPG,  
#
#



MP3GLOB='.*.wmv$'
JPGGLOB='.*.avi$'

FILENAMERES = { 'mp3' : re.compile(MP3GLOB, re.IGNORECASE),
                'jpg' : re.compile(JPGGLOB, re.IGNORECASE),
              }





def handleDir(arg, dirname, names):
    log=logging.getLogger()
    log.debug("Handling directory %s" % dirname)
    mp3s = []
    images = []
    
    for name in names:
        
        log.debug("       Handling file %s" % name)


def main():
    usage='''Usage: embedart.py [OPTIONS] [DIRECTORY]
        Takes any art in music folder and embeds in MP3 files within folder. 
        Pictures with 'front','cover', or single images are embedded as cover. 
        
        OPTIONS: 
            -h --help                    Print this message
            -d --debug                   Log very verbosely. 
            -v --verbose                 Log verbosely. 
            -r --recursive               Process all subdirectories. 
    
        DIRECTORY:
            Directory to process. Defaults to current directory. 
    '''
    
    #Defaults
    loglev="warn"
    recurse=False
    workdirs = list( os.path.normpath(os.path.join(os.getcwd())))
    
    # Handle command line options
    argv = sys.argv[1:]
    try:
        opts, args = getopt.getopt(argv, 
                                   "hdvr", 
                                   ["help",
                                    "debug",
                                    "verbose",
                                    "recursive",   
                                    ])
    except getopt.GetoptError:
        debug( "Unknown option..." )
        print usage                          
        sys.exit(1) 
       
    # Handle command line arguments, overriding invocation           
    for opt, arg in opts:
        if opt in ("-h", "--help"):
            print usage                     
            sys.exit()
        elif opt in ("-d","--debug"):
            loglev='debug'            
        
        elif opt in ("-v", "--verbose"):
            loglev='info'
        
        elif opt in ("-r", "--recursive"):
            recurse=True
    
    if args:
        workdirs = []
        for arg in args:
            wd = os.path.normpath(os.path.join(os.getcwd(),arg)) 
            workdirs.append(wd)
    
    # Set up logging. 
    FORMAT="%(asctime)s [ %(levelname)s ] %(message)s"
    logging.basicConfig(format=FORMAT)
    log = logging.getLogger()
    
    if loglev == 'debug':
        log.setLevel(logging.DEBUG)
    elif loglev == 'info':
        log.setLevel(logging.INFO)
    elif loglev == 'warn':
        log.setLevel(logging.WARN)
    
    log=logging.getLogger()
    log.info("Embedding Album Art...")
    
    
    
    
    
    log.debug("Working directory(s) is/are %s" % workdirs)
    for workdir in workdirs:
        os.path.walk(workdir,handleDir,None)
#        for root, dirs, files in os.walk(workdir):
#            for dir in dirs:
#                log.debug("Handling directory %s" % dir )
    
# End main()


if __name__ == '__main__':
    try:
        main()
    # Gracefully exit on Ctrl-C
    except (KeyboardInterrupt):
        print("\nCaught Ctrl-C. Bye.")
        sys.exit(0)

