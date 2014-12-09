#!/bin/env python
import os
import sys
import logging
from random import shuffle

from ConfigParser import ConfigParser

class SecretSantaPerson(object):
    
    def __init__(self, name, config):
        self.name = name
        self.sex = config.get(name,'sex')
        self.spouse = config.get(name,'spouse')
        self.lastyear = ",".split(config.get(name,'lastyear'))
        self.receiver = None
        self.giver = None
        log.debug("Created Person: name=%s sex=%s" % (self.name, self.sex))

    def matchok(self, otherperson):
        if self.name == otherperson.name:
            log.debug("%s can't give to his/herself." % self.name)
            return False
        if self.spouse == otherperson.name:
            log.debug("%s rejecting %s because they are spouse." % (self.name, otherperson.name))
            return False
        if otherperson.name in self.lastyear:
            log.debug("%s rejecting %s because already given to last year" % (self.name, otherperson.name))
            return False
        else:
            log.debug("%s is an ok match for %s" % (otherperson.name, self.name))
            return True

    def __repr__(self):
        return "SecretSantaPerson: name=%s sex=%s spouse=%s\n" % (self.name, self.sex, self.spouse)

class SecretSanta(object):
    
    def __init__(self, config):
        log.debug("Constructing SecretSanta main object.")
        self.people = []
        self.givers = []
        self.receivers = []
        self.pcfile = config.get('global','peopleconf')
        log.debug("Peopleconf is %s" % self.pcfile)
        self.pc=ConfigParser()
        self.pc.read(self.pcfile)
        for sect in self.pc.sections():
            p = SecretSantaPerson(sect, self.pc)
            self.people.append(p)
        for p in self.givers:
            self.receivers.append(p)
        
    
    def matchall(self):
        '''
        Perform matching for all people with constraints. 
        '''
        
        rlist = []
        for p in self.people:
            rlist.append(p)
        shuffle(rlist)
        
        log.debug("Performing matching...")
        for p in self.people:
            r = rlist.pop()
            while not p.matchok(r):
                rlist.append(r)
                shuffle(rlist)
                r = rlist.pop()
            p.receiver = r        
            log.debug("%s -> %s\n" % (p.name, p.receiver.name))
    
    def list(self):
        '''
        Return string representation of all people in config.
        '''
        log.debug("List all users...")
        s = ""
        for p in self.people:
            s+= str(p)
        return s    
    
    def giverslist(self):
        '''
        Return string in form of: 
        Joe Bloe -> Mary Margaret
        Mary Margaret -> Susan Strong
        Susan Strong -> Joe Bloe
        
        '''
        s = ""
        for p in self.people:
            s+= "%s -> %s\n" % ( p.name, p.receiver.name)
        return s
        
if __name__ == '__main__':
    
    import sys 
    import os
    import getopt
    import logging
    
    from ConfigParser import ConfigParser
    
    debug = 0
    info = 0
    warn = 0
    list = 0
    config_file = None
    default_configfile = os.path.expanduser("~/.secretsanta/santa.conf")
    
    usage = """Usage: secretsanta.py [OPTIONS]  
    OPTIONS: 
        -h --help                   Print this message
        -l --list                   Print list of people. No effects.
        -d --debug                  Debug messages
        -v --verbose                Verbose information
        -c --config                 Config file [~/.secretsanta/santa.conf
     """

    # Handle command line options
    argv = sys.argv[1:]
    try:
        opts, args = getopt.getopt(argv, 
                                   "c:hldv", 
                                   ["config=",
                                    "help", 
                                    "list", 
                                    "debug", 
                                    "verbose",
                                    ])
    except getopt.GetoptError, error:
        print( str(error))
        print( usage )                          
        sys.exit(1)
    for opt, arg in opts:
        if opt in ("-h", "--help"):
            print(usage)                     
            sys.exit()            
        elif opt in ("-c", "--config"):
            config_file = arg
        elif opt in ("-l", "--list"):
            list = 1
        elif opt in ("-d", "--debug"):
            debug = 1
        elif opt in ("-v", "--verbose"):
            info = 1

    # Read in config file
    cp=ConfigParser()
    if not config_file:
        config_file = default_configfile
    got_config = cp.read(config_file)
    if not got_config:
        print("ERROR: No config file at %s" % config_file)
        sys.exit()
 
    # Set up logging. 
    # Check python version 
    major, minor, release, st, num = sys.version_info
    
    # Set up logging, handle differences between Python versions... 
    # In Python 2.3, logging.basicConfig takes no args
    #
    FORMAT23="[ %(levelname)s ] %(filename)s (Line %(lineno)d): %(message)s"
    FORMAT24=FORMAT23
    FORMAT25="[%(levelname)s] %(module)s.%(funcName)s(): %(message)s"
    
    log = logging.getLogger()
    if major == 2 and minor ==3:
        #logging.basicConfig(format=FORMAT23)
        hdlr = logging.StreamHandler(sys.stdout)
        formatter = logging.Formatter(FORMAT23)
        hdlr.setFormatter(formatter)
        log.addHandler(hdlr) 
    elif major == 2 and minor == 4:
        logging.basicConfig(format=FORMAT24)
    elif major == 2 and minor == 5:
        logging.basicConfig(format=FORMAT25)
    else:
        logging.basicConfig(format=FORMAT25)
    
    
    logLev = cp.get('global','logLevel').lower()
    if logLev == 'debug':
        log.setLevel(logging.DEBUG)
    elif logLev == 'info':
        log.setLevel(logging.INFO)
    elif logLev == 'warn':
        log.setLevel(logging.WARN)
    if debug: 
        log.setLevel(logging.DEBUG) # Override with command line switches
    if info:
        log.setLevel(logging.INFO) # Override with command line switches

    log.info("Secret Santa!")
    log.debug("Creating SecretSanta().")
    santaobj = SecretSanta(cp)
    log.debug("Done creating SecretSanta().")
    if list:
        print santaobj.list()
    else:
        log.debug("Executing SecretSanta.matchall()")
        santaobj.matchall()
        s = santaobj.giverslist()
        print s
    log.debug("Done.")
     
    
    
    
    
    
    




    