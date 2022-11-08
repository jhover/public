#!/usr/bin/env python
#
#
'''Simple class for ps functionality for Linux systems.
Could someday be portably replicated to Windows and Mac.

A guy at ActiveState named Trent Mick also has a module named 
process.py:
http://starship.python.net/crew/tmick/

That module provides process management (starting, killing, etc.) 
that is an improvement over os.spawn, os.popen, etc. 

This module provides process *information*, without management, 
so it would actually combine nicely with Trent's work. 

Author: John R. Hover
<jhover@bnl.gov>
<john@saros.us>
http://www.saros.us/john

'''
import os, sys , string , getopt
import dircache
import logging
import pwd
import sets

class ProcessInfo(object):
    '''Class represents the proc filesystem information about a single process'''
    
    def __init__(self, process_id):
        #logging.info( "Initializing ProcessInfo object..")
        # gather all information
        self.pid = process_id
        self.cmdline = _parse_cmdline( process_id)
        self.status = _parse_status(process_id)
        self.stat = _parse_stat(process_id)
        
        # move info to convenient location..
        self.name = self.stat['comm']
        if self.cmdline == '?':
            self.name = '[' + self.name + ']'
        self.state = self.stat['state']
        self.uid =  self.status['uid']
        (pw_name,pw_passwd,pw_uid, pw_gid,pw_gecos,pw_dir,pw_shell) = pwd.getpwuid(int(self.uid))
        self.user = pw_name
        self.tty = self.stat['tty_nr']

    def __str__(self):
        s = ""
        s += "pid : %s " % self.pid
        s += "uid : %s " % self.uid
        s += "user : %s " % self.user
        s += "cmdline : %s " %  self.cmdline 
        for k in self.status.keys():
            s += "(status) %s : %s\n" % ( k , self.status[k])
        for k in  self.stat.keys():
            s += "(stat) %s : %s\n" % ( k , self.stat[k])
        s += "\n"
        return s

    def __repr__(self):
        s = "ProcessInfo: "
        s += " pid : %s " % self.pid
        s += " uid : %s " % self.uid
        s += " user : %s " % self.user
        s += " cmdline : %s " %  self.cmdline 
        s += " tty : %s " %  self.tty
        s += "\n"
        return s

    def __cmp__(self, other):
        return cmp(int(self.pid),int(other.pid))


def _find_kernel_version():
    try:
        kv = os.uname()[2].split("-")[0]
    except (IndexError):
        logging.critical("FATAL: kernel version from uname not parsable." )
        sys.exit(1)
    logging.debug( "kernel version is %s" % kv)
    return kv


def _parse_cmdline(pid):
    line = open('%s/%s/cmdline'% (PROCFS_ROOT , pid) ).read().replace('\0', ' ')
    if line == "":
        line = '?'
    return line
#
# Map of status info
#
#Name:   ssh
#State:  S (sleeping)
#SleepAVG:       98%
#Tgid:   30002
#Pid:    30002
#PPid:   11981
#TracerPid:      0
#Uid:    500     500     500     500
#Gid:    500     500     500     500
#FDSize: 256
#Groups: 34315 35298 10 500
#VmSize:     4432 kB
#VmLck:         0 kB
#VmRSS:      2164 kB
#VmData:      648 kB
#VmStk:        84 kB
#VmExe:       268 kB
#VmLib:      3244 kB
#VmPTE:        44 kB
#StaBrk: 00a8d000 kB
#Brk:    09c56000 kB
#StaStk: bfc13270 kB
#Threads:        1
#SigQ:   1/16232
#SigPnd: 0000000000000000
#ShdPnd: 0000000000000000
#SigBlk: 0000000000000000
#SigIgn: 0000000000001000
#SigCgt: 0000000008004007
#CapInh: 0000000000000000
#CapPrm: 0000000000000000
#CapEff: 0000000000000000
#Cpus_allowed:   ffffffff
#Mems_allowed:   1
#
#
def _parse_status(pid):
    status = open('%s/%s/status' % (PROCFS_ROOT, pid ) )
    status_map = {}
    
    line = status.readline()
    while line:
        #logging.debug("line from status: %s" % line)
        tokens = line.split()
        toklen = len(tokens)
        if toklen:
            #logging.debug("key: %s" % tokens[0] )
            keystr = tokens[0].replace(":",'').lower()
            #logging.debug("key string: %s" % keystr)
            valstr = ""
        if toklen > 1:
            #logging.debug ( "val: %s" % tokens[1] )
            valstr = tokens[1]
            #logging.debug("key string: %s" % keystr)
        if toklen:
            status_map[keystr] = valstr
        line = status.readline()
    return status_map


def _parse_stat(pid):
    stat_hash = {}
    stat_keys = [ 'pid', 
                 'comm', 
                 'state', 
                 'ppid', 
                 'pgrp', 
                 'session', 
                 'tty_nr',
                 'tpgid' , 
                 'flags', 
                 'minflt', 
                 'cminflt' , 
                 'majflt' , 
                 'cmajflt', 
                 'utime',
                 'stime', 
                 'cutime', 
                 'cstime', 
                 'priority', 
                 'nice', 
                 'placeholder', 
                 'itrealvalue', 
                 'starttime', 
                 'vsize', 
                 'rss', 
                 'rlim', 
                 'startcode', 
                 'endcode', 
                 'startstack',
                 'kstkesp', 
                 'kstkeip', 
                 'signal', 
                 'blocked', 
                 'sigignore', 
                 'sigcatch', 
                 'wchan',
                 'nswap', 
                 'cnswap', 
                 'exit_signal', 
                 'processor', 
                 ]
    vallist = open('%s/%s/stat'% (PROCFS_ROOT , pid) ).readline().split()
    #logging.debug(" vallist " + str(vallist))
    for i in range(0,len(stat_keys)):
        stat_hash[stat_keys[i]] = vallist[i]
    
    newval = stat_hash['comm'].replace('(','').replace(')','')
    stat_hash['comm'] = newval
    return stat_hash



def _parse_statm():
    pass


def _pid_list():
    plist = []
    dirlisting = dircache.listdir(PROCFS_ROOT)
    logging.debug( "dirlisting is %s" % dirlisting )
    for directory in dirlisting:
        if directory.isdigit():
            plist.append(directory)
    return plist


def process_by_command(command):
    '''convenience method to look up procs by a single command string'''
    return process_list(commandlist = [ command , ])

def process_by_pid(pid):
    '''convenience method to look up proces by a single pid'''
    return process_list(pidlist = [ str(pid) , ])

def process_by_uid(uid):
    '''convenience method to look up procs by a singe uid'''
    return process_list(uidlist = [ str(uid) , ])

def process_list(pidlist=None, uidlist=None, commandlist=None, ttylist=None ):
    '''Returns a list of ProcessInfo objects that match the specified parameters'''
    logging.debug( "process_list() args: pidlist = " + str(pidlist)  + " uidlist = " + str(uidlist) +
                   " commandlist = " + str(commandlist)  + " ttylist = " + str(ttylist) ) 
    
    user_uid = os.getuid()
    user_euid = os.geteuid()
    logging.debug( "uid %s euid %s" % (user_uid, user_euid) )
    
    processes = []
    #logging.debug("gathering all process ids")
    pid_list = _pid_list()
    for pnum in pid_list:
        p = ProcessInfo(pnum)
        #logging.debug("adding process to listing")
        processes.append(p) 
    logging.info(" process_list(): gathered info on %d procs" % len(processes) )
    
    # filter by pid, if specified
    filtered = processes[:]
    if pidlist:
        for p in processes:
            if p.pid not in pidlist:
                filtered.remove(p)

    # filter by uid
    if uidlist:
        for p in processes:
            if p.uid not in uidlist:
                filtered.remove(p)
    
    # filter by command
    if commandlist:
        for p in processes:
            found = 0
            for c in commandlist:
                if p.cmdline.find(c) != -1:
                    found = 1
            if not found:
                filtered.remove(p)
     
    filtered.sort()
    return filtered

PROCFS_ROOT = "/proc"
KVERSION = _find_kernel_version()

def _parse_arglist(argstr):
    '''take in string of form 'blah' or 'blah,blah2,blah3' and return 
    a list of the elements  '''
    tokens = argstr.split(',')
    return tokens

 
if __name__ == "__main__":

    
    usage = '''Usage: process.py [OPTION]... 
process.py -- implementation of UNIX ps on Python 
Gather information on system processes 
   -h | --help      print this message
   -d | --debug     debug logging
   -v | --verbose   verbose logging 
   -e               list all processes
   -a               list all except no terminal
   -p [intlist]     list certain pids
   -C [cmdlist]     list certain commands
   -U [userlist]    list process by a real UID
   -G [grouplist]   list processes by group
   -u [userlist]    list processes by effective UID
   -t [ttylist]     list processes by terminal
Report problems to <jhover@bnl.gov>'''

    # Command line arg defaults   
    listall = 0
    listall_noterm = 0   
    arg_plist = None
    arg_commandlist = None
    arg_ruserlist = None
    arg_euserlist = None
    arg_ttylist = None
    
    
    blah = []
    

    #process command line
    logger = logging.getLogger()    
    argv = sys.argv[1:]
    
    try:
        opts, args = getopt.getopt(argv, "eap:C:U:u:G:t:hdv", ["help", "debug", "verbose"])
    except getopt.GetoptError:
        print ("Unknown option...")
        print (usage)                          
        sys.exit(1)        
    for opt, arg in opts:
        if opt in ("-h", "--help"):
            print( usage )                     
            sys.exit()            
        elif opt in ("-d", "--debug"):
            logger.setLevel(logging.DEBUG)
        elif opt in ("-v", "--verbose"):
            logger.setLevel(logging.INFO)
            logging.info("verbose logging enabled.")
        elif opt in ("-e",):
            logging.debug("listall selected")
            listall = 1
        elif opt in ("-a",):
            listall_noterm = 1
            logging.debug("listall noterm selected")           
        elif opt in ("-p",):
            arg_plist = _parse_arglist(arg)
            logging.debug("pid list: " + str(arg_plist)) 
        elif opt in ("-C",):
            arg_commandlist = _parse_arglist(arg)
            logging.debug("command list: " + str(arg_commandlist))                
        elif opt in ("-U",):
            arg_ruserlist = _parse_arglist(arg)
            logging.debug("ruser list: " + str(arg_ruserlist) )
        elif opt in ("-u",):
            arg_euserlist = _parse_arglist(arg)
            logging.debug("euser list: " + str(arg_euserlist)) 
        elif opt in ("-t",):
            arg_ttylist = _parse_arglist(arg)
            logging.debug("tty list: " + str(arg_ttylist))             

    logging.debug("about to call process_list")
    proclist = process_list(pidlist=arg_plist, 
                            uidlist=arg_euserlist, 
                            commandlist=arg_commandlist, 
                            ttylist=arg_ttylist)
    
    for p in proclist:
        print (p.__repr__(),)
    

    
    