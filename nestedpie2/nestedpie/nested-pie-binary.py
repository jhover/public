import os
import sys
import tempfile
import getopt

from ConfigParser import ConfigParser

try:
    from pyscript import *
except ImportError:
    print "This program requires the pyscript Python package. Please install."
    sys.exit(0)




if __name__== '__main__':
    print "nested-pie"
    tf = tempfile.mktemp()
    defaults.units=UNITS['inch']
    c=Circle(r=.5,bg=Color('white'))
    g=Group()
    for ii in range(0,360,30):
        g.append(Circle(r=.2,bg=Color('white')).locus(180+ii,c.locus(ii)))
    render(c,g,file=tf)
    print("tempfile is %s" % tf)
    os.system("ghostscript %s" % tf)
