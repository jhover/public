#!/bin/env python
# Command-line tool to work with ical files. 
# Can remove items with matching SUMMARY strings from command line. 

import sys
import logging
from optparse import OptionParser
from types import *
import string

class CalObject(object):
       
    def __init__(self):
        self.attributes = {}  
        self.events = []
        
    def __str__(self):
        pass

    def loadFile(self,file=sys.stdin): 
        if type(file) is FileType:
            f = file
        else:
            f = open(file)     
        ob = None
        ellist = None
        lineno = 0
            
        curevent = None
        attlist = None
        inevent = False
        for line in f.readlines():
            lineno += 1
            try:
                (k,v) = string.split(line,':',1)
            except:
                print("ERROR: (%d) problem with line: %s" % (lineno, line))
                sys.exit()
            
            k = k.strip()
            v = v.strip()

            if k == "BEGIN" and v == "VCALENDAR":
                #print("Detected calendar beginning.")
                pass
            elif k == "END" and v == "VCALENDAR":
                #print("Detected calendar end.")
                pass
            elif k == "BEGIN" and v == "VEVENT":
                #print("Detected event beginning.")
                curevent = CalEvent()
                inevent = True
            elif k == "END" and v == "VEVENT":
                #print("Detected event end.")
                self.events.append(curevent)
                inevent = False
            else:
                #print("Found %s = %s" % (k,v))
                if inevent:
                    setattr(curevent,k,v)
                else:
                    self.attributes[k] = v
                           
    def removeEvents(self,matchstring):
        
        # Cannot remove from list in-place, must match in *COPY* and remove
        # from *ORIGINAL* argh. 
        for ev in self.events[:]:
            if ev.SUMMARY.find(matchstring) > -1:
                #print("FOUND THE SEARCH STRING %s in object %s" % (matchstring, ev))
                self.events.remove(ev)
        
    def __str__(self):  
        s = "BEGIN:VCALENDAR\n"
        for ak in self.attributes.keys():
            s += "%s:%s\n" % (ak,self.attributes[ak])
        for ev in self.events:
            s += str(ev) 
        s += "END:VCALENDAR"
        return s        
    


class CalEvent(object):
    
    def __init__(self):
        pass
    
    def __str__(self):
        s = "BEGIN:VEVENT\n"
        #s += "SUMMARY:%s\n" % self.SUMMARY
        for ak in self.__dict__.keys():
            s += "%s:%s\n" % (ak,self.__dict__[ak]) 
        s += "END:VEVENT\n"
        return s
        
        
if __name__ == '__main__':
    parser = OptionParser(usage='''%prog [OPTIONS]''', 
                           version="1.0")
    parser.add_option("--verbose", "--debug", dest="logLevel", default=logging.INFO,
                      action="store_const", const=logging.DEBUG, help="Set logging level to DEBUG [default INFO]")
    parser.add_option("--infile", dest="infile", default=sys.stdin,
                      action="store", metavar="FILE1", help="Load info from file")
    parser.add_option("--remove", dest="remove", default=None,
                      action="store", metavar="STRING", help="Remove matching events. Simple string match.")
    (options, args) = parser.parse_args()

    c = CalObject()
    c.loadFile(file=options.infile)
    #print("Selected remove string is %s" % options.remove)
    if options.remove:
        c.removeEvents(options.remove)    
    print(c)
