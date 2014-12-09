#
# makefile for scoresite
#
CC=gcc
CFLAGS = -I/usr/local/include -Wall 
#CFLAGS = -I/usr/local/include  
#CFLAGS= -Iargtable2/src -O
BINS=scoresite 
CONFIGS=scoresite.conf defunct.conf regood.conf bad.conf
PREFIX=/usr/local/seq
BINDIR=$(PREFIX)/bin
CONFDIR=$(PREFIX)/etc/scoresite

#LDFLAGS = -L/usr/local/lib
LDFLAGS = -Largtable2/src

# -lm needed for Linux/gcc
LDLIBS = -largtable2 -lm

OBJS = scoresite.o freq_norm.o regulators.o parse_args.o conf_file.o utils.o

all: $(BINS)

argtable2:   argtable-2.4.tar.gz
	tar xvzf argtable-2.4.tar.gz
	cd argtable2 ; ./configure ; make

argtable2-install: argtable2
	cd argtable2 ; make install

scoresite: $(OBJS)
	$(CC) $(CFLAGS) $(LDLIBS) -o scoresite $(OBJS) 

scoresite.o:  scoresite.c scoresite.h
freq_norm.o:  freq_norm.c scoresite.h
regulators.o: regulators.c  scoresite.h
parse_args.o: parse_args.c  scoresite.h
conf_file.o:  conf_file.c  scoresite.h
utils.o:      utils.c  scoresite.h

.c.o:   
	cc $(CFLAGS) -c  $*.c

install: $(BINS)
	mkdir -p $(BINDIR) ; cp $(BINS) $(BINDIR) 
	mkdir -p $(CONFDIR) ; cp $(CONFIGS) $(CONFDIR)

uninstall:
	cd $(BINDIR); rm -rf $(BINS)
	cd $(CONFDIR) ; rm -rf $(CONFIGS)

clean:
	rm -rf *.o $(BINS)
	rm -rf argtable2
	rm -rf Debug

dist:
	make clean
	cd .. ; tar -cvzf ./scoresite.tgz --exclude CVS --exclude .svn --exclude .cdtproject \
	--exclude .project scoresite 


