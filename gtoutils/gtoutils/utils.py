
import logging
import os

import pandas as pd


from bs4 import BeautifulSoup

 

def split_path(filepath):
    '''
    dir, base, ext = split_path(filepath)
    '''
    filepath = os.path.abspath(filepath)
    dirpath = os.path.dirname(filepath)
    filename = os.path.basename(filepath)
    base, ext = os.path.splitext(filename)
    ext = ext[1:]
    return (dirpath, base, ext)

def parse_tel(tstring):
    '''
    assumes tel:+13477315893
    returns  +13477315893
    '''
    if len(tstring) == 16:
        return tstring[4:]
    else:
        return 'unknown'

def parse_dt(dt):
    '''
    Assumes 2025-02-10T16:56:13.735-05:00
    Returns 2025-02-10 16:56:13
    '''
    date, rem = dt.split('T')
    time = rem[:8]
    return date, time


def parse_calls( infiles, outfile):
    '''
    
    Placed
    Missed
    Received
    Voicemail
    Text
    '''
    
    logging.debug(f'handling infiles={infiles}')
    calls_lol = []
    text_lol = []
    
    for fpath in infiles:
        dir, base, ext = split_path(fpath)
        logging.debug(f'handling {base} with {ext}...')
        if ext == 'html':
            logging.info(f'handling file={fpath}')
            tag = 'None'
            
            with open(fpath) as fh:
                s = fh.read()
                soup = BeautifulSoup(s, "html.parser")
                logging.debug(f'created soup object {soup.prettify()}')

                tags_list = []
                tags_elem = soup.find('div', class_='tags')
                a_elems = tags_elem.find_all('a', rel='tag')
                for a_elem in a_elems:
                    t = a_elem.text.strip()
                    tags_list.append(t)
                tag = tags_list[0]
                
                # Handle Text   "message" files
                hfeed = soup.find("div", class_='hChatLog hfeed')
                if hfeed is not None:
                    messages = hfeed.find_all("div", class_='message')
                    for message in messages:
                        dt_elem = message.find( 'abbr', class_='dt') 
                        dt = dt_elem['title']
                        date, time = parse_dt(dt)
                                           
                        cite_elem = message.find('cite', class_='sender vcard')
                        tel_elem = cite_elem.find('a', class_='tel')
                        tel = tel_elem['href']
                        tel = parse_tel(tel)
    
                        q_elem = message.find('q')
                        q = q_elem.text.strip()
                        logging.info(f'message: tag={tag} dt={dt} tel={tel} text={q} ')
                        text_lol.append( [ 'text', tag.lower(), date, time, tel, q]   )
                        
                # Handle Placed  "haudio" files
                haudios = soup.find_all("div", class_='haudio')
                for haudio in haudios:
                    tags_list = []
                    tags_elem = haudio.find('div', class_='tags')
                    #logging.info(f'tags_elem={tags_elem}')
                    a_elems = tags_elem.find_all('a', rel='tag')
                    for a_elem in a_elems:
                        t = a_elem.text.strip()
                        tags_list.append(t)
                                     
                    div_elem = haudio.find('div', class_='contributor vcard')
                    tel_elem = div_elem.find('a', class_='tel')
                    tel = tel_elem['href']
                    tel = parse_tel(tel)
                    
                    abbr_elem = haudio.find('abbr', class_='published')
                    dt = abbr_elem['title']
                    date, time  = parse_dt(dt)

                    abbr_elem = haudio.find('abbr', class_='duration')
                    if abbr_elem is not None:
                        dur = abbr_elem.text.strip()
                    else:
                        dur = '(00:00:00)'
                    
                    logging.info(f'haudio: tag={tag} dt={dt} tel={tel} duration={dur} ')
                    calls_lol.append( [ 'call', tag.lower() , date, time, tel, dur]   )  
    logging.debug(f'read {len(infiles)} files.')
    logging.debug(f'calls_lol = {calls_lol}')
    logging.debug(f'text_lol = {text_lol}')
    textdf = pd.DataFrame(text_lol, columns=['type','tag','date','time','tel','text'])
    callsdf = pd.DataFrame(calls_lol, columns=['type','tag','date','time','tel','duration'])
    logging.info(textdf)
    logging.info(callsdf) 
        
        
        
        