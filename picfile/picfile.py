#!/bin/env python
#
#

DIR="/run/media/jhover/Data/"
STARTTIME=1608221488


import logging
from os import listdir, rename, utime
from os.path import isfile, join
import pathlib

def main():

    #fixnames()
    setdate()

def setdate():

    filelist = [f for f in listdir(DIR) if isfile(join(DIR, f))]
    logging.info(f"processing {len(filelist)} files...")
    filelist.sort()     
    
    newtime = STARTTIME
    for f in filelist:
        #print(len(f))    
        fpath=f"{DIR}{f}"
        #print(fpath)
        pf = pathlib.Path(fpath)
        osr = pf.stat()
        #print(osr)
        #print(osr.st_mtime)
        print(f"{fpath} -> {newtime}")
        utime(fpath, (newtime, newtime))
        newtime += 2
        
    
def fixnames():
    #filelist=os.listdir(DIR)
    filelist = [f for f in listdir(DIR) if isfile(join(DIR, f))]
    logging.info(f"processing {len(filelist)} files...")
    filelist.sort()
    for f in filelist:
        #print(len(f))
        if len(f) < 18:
            #print(f)
            prefix=f[:10]
            postfix=f[10:]
            #print(f"'{prefix}'  '{postfix}' ")
            newname = prefix + "0" + postfix
            #print(newname)
            oldpath=f"{DIR}{f}"
            newpath=f"{DIR}{newname}"
            print(f"{oldpath} -> {newpath}")
            rename(oldpath, newpath)


if __name__ == '__main__':
    FORMAT='%(asctime)s (UTC) [ %(levelname)s ] %(filename)s:%(lineno)d %(name)s.%(funcName)s(): %(message)s'
    logging.basicConfig(format=FORMAT)
    logging.getLogger().setLevel(logging.DEBUG)
    logging.info(f"Readingdir: {DIR}")
    
    main()
    
    