#!/usr/bin/env python
#
#

'''Simple interface to ps functionality for Linux systems.
Could someday be portably replicated to Windows and Mac.
'''
import os, sys , string
import dircache
import logging

logging.basicConfig(level=logging.INFO)


class ProcessInfo(object):
    def __init__(self, pid):
        logging.debug( "initializing ProcessInfo object..")
        self.cmdline = open('/proc/%s/cmdline'% pid).read().replace('\0', ' ')
        self.status_map = {}
        status = open('/proc/%s/status' % pid)
        line = status.readline()
        while line:
            logging.debug("line from status: %s" % line)
            tokens = line.split()
            toklen = len(tokens)
            if toklen:
                logging.debug("key: %s" % tokens[0] )
                keystr = tokens[0].replace(":",'').lower()
                logging.debug("key string: %s" % keystr)
                valstr = ""
            if toklen > 1:
                logging.debug ( "val: %s" % tokens[1] )
                valstr = tokens[1].lower()
                logging.debug("key string: %s" % keystr)
            if toklen:
                self.status_map[keystr] = valstr
            line = status.readline()
        

    def __str__(self):
        s = ""
        s += "pid : %s\n" % self.status_map['pid']
        s += "cmdline : %s\n" % self.cmdline
        for k in self.status_map.keys():
            s += "%s : %s\n" % ( k , self.status_map[k])
        return s

    def __repr__(self):
        s = ""
        s += "pid : %s\n" % self.status_map['pid']
        s += "cmdline : %s\n" % self.cmdline
        for k in self.status_map.keys():
            s += "%s : %s\n" % ( k , self.status_map[k])
        return s


#def parse_status():



def process_list():
    all_processes = []
    dirlisting = dircache.listdir('/proc')
    logging.debug( "dirlisting is %s" % dirlisting )
    for directory in dirlisting:
        if directory.isdigit():
            p = ProcessInfo(directory)
            logging.debug("adding process to listing")
            all_processes.append(p) 
    return all_processes
    
if __name__ == "__main__":
    pl = process_list()
    for p in pl:
        print p
    
    