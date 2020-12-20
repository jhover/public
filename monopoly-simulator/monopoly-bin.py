#!/usr/bin/env python
#
print("Monopoly!")

from configparser import ConfigParser
import logging
import os
import random
import sys
import getopt

DEFAULT_CONFIG='/home/jhover/devel/monopoly-simulator/config/monopoly.conf'

from monopoly import *

cmdloglevel=None

usage = """Usage: monopoly-simulator.py [OPTIONS]

OPTIONS: 
    -h --help                    print(this message
    -d --debug                   Debug messages
    -v --verbose                 Verbose information
    -c --config                  Config file [~/etc/monopoly.conf]
 
""" 

configfile = DEFAULT_CONFIG


# Handle command line options
argv = sys.argv[1:]
try:
    opts, args = getopt.getopt(argv, 
                               "hdvc:s:f:t:lTC", 
                               ["help", 
                                "debug", 
                                "verbose", 
                                "config=",
                                ])
except getopt.GetoptError:
    print("Unknown option...")
    print(usage)                          
    sys.exit(1) 
           
for opt, arg in opts:
    if opt in ("-h", "--help"):
        print(usage)                     
        sys.exit()            
    elif opt in ("-d", "--debug"):
        cmdloglevel="debug"
    elif opt in ("-v", "--verbose"):
        cmdloglevel="info"
    elif opt in ("-c","--config"):
        configfile = arg

# Read in config file
configfile = os.path.expanduser(configfile)

config=ConfigParser()
config.read([configfile])

# Check python version 
major, minor, release, st, num = sys.version_info

# Set up logging, handle differences between Python versions... 
# In Python 2.3, logging.basicConfig takes no args
#
FORMAT="%(asctime)s [ %(levelname)s ] %(message)s"
if major == 2 and minor ==3:
    logging.basicConfig()
else:
    logging.basicConfig(format=FORMAT)


log = logging.getLogger()
loglev = config.get('global','loglevel').lower()

# override config file loglevel if given on cmdline
if cmdloglevel:
    loglev = cmdloglevel

if loglev == 'debug':
    log.setLevel(logging.DEBUG)
elif loglev == 'info':
    log.setLevel(logging.INFO)
elif loglev == 'warn':
    log.setLevel(logging.WARN)
  
log.debug("Monopoly!")

g = Game(config)
try:
    g.play()
except (KeyboardInterrupt): 
    log.info("Shutdown via Ctrl-C or -INT signal.")
    print(g)
    