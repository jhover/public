#!/bin/env python
#
# Simple program to solve NYTimes Spelling Bee Puzzle game. 
# 
#

import argparse
import logging
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
    nlist = []
    for word in wordlist:
        if not len(word) < minlength:
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

def find_valid_words(wordlist, letterlist, minlength):
    wl = read_wordlist(wordlist)   
    sl = remove_short_words(wl, minlength)   
    rl = keep_required_letter(sl, required)    
    dl = remove_digits(rl)   
    nl = remove_proper_nouns(dl)
    final_list = only_selected_letters(nl, letterlist )    
    return final_list


if __name__ == '__main__':
    logging.basicConfig(format='%(asctime)s (UTC) [ %(levelname)s ] %(name)s %(filename)s:%(lineno)d %(funcName)s(): %(message)s')
    
    parser = argparse.ArgumentParser()
    parser.add_argument('-w', '--wordlist', 
                        action="store", 
                           dest='wordlist', 
                        default='/usr/share/dict/words',
                        help='word list text file')

    parser.add_argument('-m', '--minlength', 
                        action="store", 
                           dest='minlength', 
                        default=4,
                        help='minimum valid word length')
       
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
    
    logging.debug("Letters are %s" % args.letters )
    letterlist = flatten(args.letters)
    required = letterlist[0]
    logging.debug("letterarray is %s ; required letter is %s" % (letterlist, required) )
    
    valid_words = find_valid_words(args.wordlist, letterlist, args.minlength)
    for word in valid_words:
        print(word)


