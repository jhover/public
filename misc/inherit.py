#!/usr/bin/env python3
#
# 
#
#
#
# Useful:  
#   https://www.thedigitalcatonline.com/blog/2014/05/19/method-overriding-in-python/
#   https://realpython.com/python-super/#super-in-single-inheritance
#
#
#
print("inheritance and plugins...")

import argparse
from configparser import ConfigParser
import logging

class Plugin(object):
    REPR_ATTRS=[]

    def __init__(self, config):
        self.config = config
        self.kname = self.__class__.__name__
        self.log = logging.getLogger(self.kname)      

    def getinfo(self):
        self.log.debug("getinfo called...")
        s = "%s:" % self.kname
        return s

    def __repr__(self):
        s = "%s:" % self.kname
        for atr in self.__class__.REPR_ATTRS:
            s += " %s=%s" % (atr, self.__getattribute__(atr))
        return s 
        

class FooPlugin(Plugin):
    
    def __init__(self, config):
        print("calling super for FooPlugin...")
        super(FooPlugin, self).__init__(config)
        self.log.debug("super called on FooPlugin")
        self.configname = self.__class__.__name__.lower()
        self.log.debug("lookup in config file: %s" % self.configname)
        # can't get self.kname until after init(), but logging gets class name OK. 
        #self.log.debug("%s initialized...") % self.kname

    def execute(self, input):
        self.log.info("Executing on %s" % input)
        output = input
        self.log.debug("Returning output.")
        return output
        

class BarPlugin(Plugin):

    REPR_ATTRS=['extra', 'special']
    
    def __init__(self, config, special="frabozz"):
        super(BarPlugin, self).__init__(config)
        self.configname = self.__class__.__name__.lower()
        self.log.debug("setting special attr")
        self.special = special
        self.extra = self.config.get(self.configname, 'extra')
   
    def execute(self, input):
        self.log.info("Executing on %s" % input)
        output = input + self.special
        self.log.debug("Returning output.")
        return output

def runtest(config):
    cp = config    
    plp = Plugin(cp)
    print("plugin repr is %s " % str(plp))
    foo = FooPlugin(cp)
    print("foo.getinfo() -> %s" % foo.getinfo())
    print("fooinfo repr is %s" % str(foo))
        
    bar = BarPlugin(cp, special='baz')
    print( foo.execute("zazzo"))
    print(bar.execute("wazzo-"))
    print("bar repr is %s" % str(bar))
    


if __name__ == '__main__':

    FORMAT='%(asctime)s (UTC) [ %(levelname)s ] %(filename)s:%(lineno)d %(name)s.%(funcName)s(): %(message)s'
    logging.basicConfig(format=FORMAT)    
    parser = argparse.ArgumentParser()      
    parser.add_argument('-d', '--debug', 
                        action="store_true", 
                        dest='debug', 
                        help='debug logging')
    parser.add_argument('-v', '--verbose', 
                        action="store_true", 
                        dest='verbose', 
                        help='verbose logging')
    parser.add_argument('special', 
                        metavar='special', 
                        type=str,
                        nargs='?', 
                        help='a special arg for BarPlugins')   
    parser.add_argument('-c', '--config', 
                        action="store", 
                        dest='conffile', 
                        default='~/etc/cafa4.conf',
                        help='Config file path [~/etc/cafa4.conf]')
    args= parser.parse_args()
    
    if args.debug:
        logging.getLogger().setLevel(logging.DEBUG)
    if args.verbose:
        logging.getLogger().setLevel(logging.INFO)
    
    cp = ConfigParser()
    cp.read(args.conffile)

    runtest(cp)
    