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

    def __init__(self, config):
        self.config = config
        self.kname = self.__class__.__name__
        self.log = logging.getLogger(self.kname)

    def getinfo(self):
        self.log.debug("getinfo called...")
        s = "%s:" % self.kname
        return s

        

class FooPlugin(Plugin):
    
    def __init__(self, config):
        print("calling super for FooPlugin...")
        super(FooPlugin, self).__init__(config)
        self.log.debug("super called on FooPlugin")
        # can't get self.kname until after init(), but logging gets class name OK. 
        #self.log.debug("%s initialized...") % self.kname


    def execute(self, input):
        self.log.info("Executing on %s" % input)
        output = input
        self.log.debug("Returning output.")
        return output
        

class BarPlugin(Plugin):
    
    def __init__(self, config, special=5):
        super(BarPlugin, self).__init__(config)
        self.log.debug("setting special attr")
        self.special = special
        #print(self.kname)    

    def getinfo(self):
        pass

    def execute(self, input):
        self.log.info("Executing on %s" % input)
        output = input + self.special
        self.log.debug("Returning output.")
        return output


if __name__ == '__main__':
    
    #FORMAT='%(asctime)s (UTC) [ %(levelname)s ] %(name)s %(filename)s:%(lineno)d %(funcName)s(): %(message)s'
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
    c = ConfigParser()
    
    plp = Plugin(c)
    foo = FooPlugin(c)
    print("foo.getinfo() -> %s" % foo.getinfo())
    bar = BarPlugin(c, special='baz')
    print( foo.execute("zazzo"))
    print(bar.execute("wazzo-"))
    
    