#!/usr/bin/env python
#
# Simple program to solve NYTimes Spelling Bee Puzzle game. 
# 
#

import argparse
import logging
import os
import string

def read_wordlist(path):
    f = open(path)
    wordlist = f.readlines()
    f.close()
    logging.debug("Read %d lines" % len(wordlist))
    nlist = []
    for item in wordlist:
        item = item.strip()
        nlist.append(item)
    logging.debug("After reading: %s " % nlist[0:5])
    return nlist

def remove_proper_nouns(wordlist):
    nlist = []
    for word in wordlist:
        if not word[0] in string.ascii_uppercase:
            nlist.append(word)
    logging.debug("Non-proper noun list is %d" % len(nlist))
    logging.debug("After remove_proper_nouns: %s " % nlist[0:5])
    return nlist

def remove_digits(wordlist):
    nlist = []
    for word in wordlist:
        anypresent = False
        for let in word: 
            if let in string.digits:
                anypresent = True
        if anypresent is False:
            nlist.append(word)
    logging.debug("Non-digit word list is %d" % len(nlist))
    logging.debug("After remove_digits: %s " % nlist[0:5])
    return nlist
    
def remove_short_words(wordlist, minlength):
    logging.debug("Removing words shorter than %d" % minlength)
    nlist = []
    for word in wordlist:
        if len(word) < minlength:
            pass
        else:
            nlist.append(word)
    logging.debug("Shortened list length is %d" % len(nlist))
    logging.debug("After remove_short_words: %s " % nlist[0:5])
    return nlist   
    
def keep_required_letter(wordlist, rletter):
    nlist = []
    for word in wordlist:
        if rletter in word:
            nlist.append(word)
    logging.debug("Required letter list is %d" % len(nlist))
    logging.debug("After keep_required_letter: %s " % nlist[0:5])
    return nlist

def flatten( flist):
    flat_list = []
    for sublist in flist:
        for item in sublist:
            flat_list.append(item)
    return flat_list

def get_missing_letters(letterlist):
    alphabet = list("abcdefghijklmnopqrstuvwxyz-.'")
    for let in letterlist:
        alphabet.remove(let)
    logging.debug("Alphabet is now %d letters: %s " % (len(alphabet), alphabet))
    return alphabet


def only_selected_letters(wordlist, letterlist):
    invertletters = get_missing_letters(letterlist)
    logging.debug("invertletters is %s" % invertletters)
    nlist = []
    for word in wordlist:
        anypresent = False
        for let in invertletters:
            if let in word:
                anypresent = True
        if anypresent is False:
            nlist.append(word)
    logging.debug("Selected letter list length is %d" % len(nlist))
    logging.debug("After only_selected_letters: %s " % nlist[0:5])
    return nlist

def find_valid_words(wordfile, letterlist, minlength, testword):

    wordlist = read_wordlist(wordfile)   
    if testword is not None:
        if testword in wordlist:
            logging.debug(f"testword {testword} is in wordlist.")
        else:
            logging.debug(f"testword {testword} is NOT in wordlist.")
    
    # apply filters...
    wordlist = remove_short_words(wordlist, minlength) 
    if testword is not None:
        if testword in wordlist:
            logging.debug(f"testword {testword} is in wordlist.")
        else:
            logging.debug(f"testword {testword} is NOT in wordlist.")  
    
    wordlist = keep_required_letter(wordlist, required)    
    if testword is not None:
        if testword in wordlist:
            logging.debug(f"testword {testword} is in wordlist.")
        else:
            logging.debug(f"testword {testword} is NOT in wordlist.")
    
    wordlist = remove_digits(wordlist)   
    if testword is not None:
        if testword in wordlist:
            logging.debug(f"testword {testword} is in wordlist.")
        else:
            logging.debug(f"testword {testword} is NOT in wordlist.")
    
    wordlist = remove_proper_nouns(wordlist)
    if testword is not None:
        if testword in wordlist:
            logging.debug(f"testword {testword} is in wordlist.")
        else:
            logging.debug(f"testword {testword} is NOT in wordlist.")
    wordlist = only_selected_letters(wordlist, letterlist )
    if testword is not None:
        if testword in wordlist:
            logging.debug(f"testword {testword} is in wordlist.")
        else:
            logging.debug(f"testword {testword} is NOT in wordlist.") 

    logging.debug(f"Returning wordlist, length {len(wordlist)}")
    return wordlist


if __name__ == '__main__':
    logging.basicConfig(format='%(asctime)s (UTC) [ %(levelname)s ] %(name)s %(filename)s:%(lineno)d %(funcName)s(): %(message)s')
    #logging.getLogger().setLevel(logging.DEBUG)
    
    #logging.debug(f"cwd = {os.getcwd()} __file__ =  {__file__}")
    

    parser = argparse.ArgumentParser()
    parser.add_argument('-w', '--wordlist', 
                        action="store", 
                        dest='wordlist', 
                        default=None,
                        help='words in same dir as exec, or [/usr/share/dict/words]')

    parser.add_argument('-m', '--minlength', 
                        action="store", 
                        dest='minlength', 
                        default=4,
                        help='minimum valid word length [4]')

    parser.add_argument('-t', '--testword', 
                        action="store", 
                        dest='testword', 
                        default=None,
                        help='word to use during debug testing.')
       
    parser.add_argument('-d', '--debug', 
                        action="store_true", 
                        dest='debug', 
                        help='debug logging')

    parser.add_argument('-v', '--verbose', 
                        action="store_true", 
                        dest='verbose', 
                        help='verbose logging')

    parser.add_argument('letters', 
                        metavar='letters', 
                        type=str, 
                        nargs='+',
                        help='a list of letters in word. First letter will be *required*.')
    
    args= parser.parse_args()
    
    if args.debug:
        logging.getLogger().setLevel(logging.DEBUG)
    if args.verbose:
        logging.getLogger().setLevel(logging.INFO)
    
    letterlist = [ l.lower() for l in args.letters]
    letterlist = flatten(letterlist)
    required = letterlist[0]
    letterlist = list(set(letterlist))  # remove redundant. 
    logging.debug("letterarray is %s ; required letter is %s" % (letterlist, required) )
    
    minlength = int(args.minlength)
    
    if args.wordlist is None:
        logging.debug('No wordlist specified on command line.')
        listpath = f'{os.path.dirname(__file__)}/words'
        if os.path.exists(listpath):
            logging.debug(f"Found file 'words' in exec dir, using...")
        else:
            logging.debug(f"No file 'words' in exec dir, using default.")
            listpath = '/usr/share/dict/words'
    else:
        listpath = args.wordlist
        logging.debug("Word list specified on command line...")
    
    valid_words = find_valid_words(listpath, letterlist, minlength, args.testword)
    for word in valid_words:
        print(word)


