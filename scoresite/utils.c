#include "scoresite.h"

/* 
 * comp_char[c] contains the complementary nucleotide character for c 
 * Includes IUPAC-IUB ambiguity codes...
 * Also used by is_valid_base() to tell if c is OK.
 * Comment notation is in octal 000 - 177 = 0 - 127 decimal
 * 
 * */
char comp_char[] = {
            /*          0     1     2     3     4     5     6     7   */
            /* 000 */  'X',  'X',  'X',  'X',  'X',  'X',  'X',  'X',
            /* 010 */  'X',  'X',  'X',  'X',  'X',  'X',  'X',  'X',
            /* 020 */  'X',  'X',  'X',  'X',  'X',  'X',  'X',  'X',
            /* 030 */  'X',  'X',  'X',  'X',  'X',  'X',  'X',  'X',
            /* 040 */  'X',  'X',  'X',  'X',  'X',  'X',  'X',  'X',
            /* 050 */  'X',  'X',  'X',  'X',  'X',  'X',  'X',  'X',
            /* 060 */  'X',  'X',  'X',  'X',  'X',  'X',  'X',  'X',
            /* 070 */  'X',  'X',  'X',  'X',  'X',  'X',  'X',  'X',
            /* 100 */  'X',  'T',  'V',  'G',  'H',  'X',  'X',  'C',
            /* 110 */  'D',  'X',  'X',  'M',  'X',  'K',  'N',  'X',
            /* 120 */  'X',  'X',  'Y',  'S',  'A',  'X',  'B',  'W',
            /* 130 */  'X',  'R',  'X',  'X',  'X',  'X',  'X',  'X',
            /* 140 */  'X',  't',  'v',  'g',  'h',  'X',  'X',  'c',
            /* 150 */  'd',  'X',  'X',  'm',  'X',  'k',  'n',  'X',
            /* 160 */  'X',  'X',  'y',  's',  'a',  'X',  'b',  'w',
            /* 170 */  'X',  'r',  'X',  'X',  'X',  'X',  'X',  'X',
};

/* Fills the string r with the reverse complement of s */

void  rev_comp( char *r, char *s )
   {
    char *p;
    p = s + strlen( s );
    while ( p > s )
       *r++ = comp_char[(int) *(--p)];
    *r = '\0';
   }

int is_valid_base( char c ) 
   {
    return( comp_char[ (int) c ] != 'X' );
   }


/*
 *  Trims whitespace (and newlines) from beginning and end of S 
 */
void trim( char *s )
   {
    int i=0,j, slen;

    /* Trim spaces and tabs from beginning: */

    slen = strlen(s);
    while ( (s[i]==' ') || (s[i]=='\t') )
        i++;
		
    if ( i > 0 )
       {
	for ( j = 0; j < slen; j++ )
	    s[j] = s[j+i];
	s[j] = '\0';
       }

    /* Trim spaces and tabs from end: */
    i = strlen(s) - 1;
    while (  s[i] == ' ' || s[i] == '\t' || s[i] == '\n' )
	i--;
    if ( i < (strlen(s)-1) )
        s[i+1] = '\0';
   }



/*  Unconditionally removes last character from null-terminated string.. */

void chomp( char * s ) 
   {
    int i = 0;

    /* find \0  */ 
    while ( s[i] != '\0' ) 
	i++;
    if ( i > 0 )	
        s[i-1] = '\0';
   }

/* open_file() opens a file or returns stdin if name is "-", or does */
/* error exit if file can't be opened                                */

FILE *open_file( char *name )
   {
    FILE *f;

    if ( strcmp( name, "-" ) == 0 )
        return( stdin );
    else
        if ( (f = fopen( name, "r" ) ) )
            return( f );
        else
           {
            perror( name );
            exit( errno );
           }
   }


/* close_file() closes the file unless its stdin */

void  close_file( FILE *f )
   {
    if ( f != stdin )
        fclose( f );
   }

