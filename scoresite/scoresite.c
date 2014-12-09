/* Program:        scoresite                                                 */
/*                                                                           */
/* Programmers:    Sean R. McCorkle,                                         */
/*                 Biology Dept., Brookhaven National Laboratory             */
/*                 (adapted from Jizu Zhi's scoreRE1 perl script)            */
/*                                                                           */
/*                 John R. Hover, Gail Mandel Lab, Howard Hughes Medical     */
/*                 Inst. (rewrite for GNU argp, additional modularity,       */
/*                 IUPAC-IUB/GCG  ambiguity codes, configuration file, and   */
/*                 user-selectable matrices, min score, mismatches, and      */
/*                 output file,GFF output format, rewrite for argtable,      */
/*                 config-file finding)                                      */
/*                                                                           */
/*                 Chaolin Zhang, Cold Spring Harbor Laboratory              */
/*                 (user-selectable config file)                             */
/*                                                                           */
/* Language:       C                                                         */
/*                                                                           */
/* Description:    Search DNA sequence files (FASTA format) for candidate    */
/*                 promoter/repressor sequences.                             */
/*                                                                           */
/* Depends:        argtable   http://argtable.sourceforge.net/               */
/*                                                                           */
/*****************************************************************************/

#include "scoresite.h"


        /* CONSTANTS/DEFAULTS  */

const char *progname   = "scoresite";
const char *bugaddress = "john@saros.us";
const char *version    = "1.2";


/* Note: this 10  kind of bugs me */

int matches[MAX_NT_INDEX_VALUE][MAX_NT_INDEX_VALUE] = {
            /* Regulator descriptions: w/ IUAPC Ambiguity codes  */
/*              A  C  G  T  N  a  c  g  t  X  M  R  W  S  Y  K  V  H  D  B   */
                  /* Capital bases in sequence match codes */
/* A */        {1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1, 0},
/* C */        {0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 1, 1, 0, 1, 1, 0, 1},
/* G */        {0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 1, 1, 0, 1, 1},
/* T */        {0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 0, 1, 1, 1}, 
                 /* N Doesn't match anything. ??maybe N  */
/* N */        {0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
                 /*  Lowercases and X don't match anything (repeatmasked) */
/* a */        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
/* c */        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
/* g */        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
/* t */        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},   

/* X */        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
};


                             /* GLOBAL  VARIABLES  */

/* general utility vars  */
char         bases[] = "ACGT";    
int          buff_len;
int          nt_index[MAX_NT_INDEX];  /* nucleotide index, for matching */
static char  fbuff[MAX_BUFF_LEN+1];   /* forward buffer */
static char  rbuff[MAX_BUFF_LEN+1];   /* reverse buffer */
int          neighbor_len = 0;        /* number of bases to either side of test */
int          buff_len;              


                             /*  PROCEDURES  */


/****************************************************************************/
/*  Initializes the nucleotide index allowing efficient use of int arrays   */
/*  for matches.                                                            */
/*                                                                          */
/*   Note: nt_index[] and matches[][] are interdependent. Any changes in    */
/*         one must be dealt with in the other.                             */
/*                                                                          */
/*  Note Also:  nt_index[] and regulator->matrix[][] are also interdependent*/
/*         so make sure max value is < MAX_NT_INDEX_VALUE                   */ 
/****************************************************************************/

void  init_nt_index( void ) {
    if ( debug ) printf("scoresite: initializing nucleotide index...\n");
    int i;

    for ( i = 0; i < MAX_NT_INDEX; i++ )
        nt_index[i] = -1;
        
    nt_index['A'] = 0;
    nt_index['C'] = 1;
    nt_index['G'] = 2;
    nt_index['T'] = 3;
    nt_index['N'] = nt_index['n'] = 4;
    if ( ignore_case )
       {
        nt_index['a'] = 0;
        nt_index['c'] = 1;
        nt_index['g'] = 2;
        nt_index['t'] = 3;
       }
    else
       {
        nt_index['a'] = 5;
        nt_index['c'] = 6;
        nt_index['g'] = 7;
        nt_index['t'] = 8;
       }

    nt_index['X'] = 9;
    nt_index['M'] = nt_index['m'] = 10;
    nt_index['R'] = nt_index['r'] = 11;
    nt_index['W'] = nt_index['w'] = 12;
    nt_index['S'] = nt_index['s'] = 13;
    nt_index['Y'] = nt_index['y'] = 14;
    nt_index['K'] = nt_index['k'] = 15;
    nt_index['V'] = nt_index['v'] = 16;
    nt_index['H'] = nt_index['h'] = 17;
    nt_index['D'] = nt_index['d'] = 18;
    nt_index['B'] = nt_index['b'] = 19;   /* MAX_NT_INDEX_VALUE is currently */
                                          /* 20, so WATCH IT!                */
}




                       /**********************/
                       /* comparision buffer */
                       /**********************/

/* this preps fbuff[] and rbuff[], and sets the global buff_len */

void  init_buff( regulator_t *r )
   {
    size_t i;
    int    t_len;  /* current template length, set from regulator struct */
                   /* set by -N */

    t_len = r->templ_len;

    buff_len = neighbor_len + t_len + neighbor_len;
    if ( buff_len > MAX_BUFF_LEN )
           {
            fprintf( stderr, 
                  "scoresite: init_buff(): buffer length %d exceeds max %d\n",
                   buff_len, MAX_BUFF_LEN );
         exit( 1 );
           }
    
    for ( i = 0; i < buff_len; i++ )
       {
    fbuff[i] = 'X';
        rbuff[i] = 'X';
       }
    fbuff[buff_len] = '\0';
    rbuff[buff_len] = '\0';

    if ( debug )
        printf( "scoresite: init_buff(): buffer initialized: %d + %d + %d = %d reg: %s\n",
                     neighbor_len, t_len, neighbor_len, buff_len, r->name );
   }

/* put the base c into the forward and reverse buffers */

void  enter_base( int c )
   {
    memmove( fbuff, fbuff+1, buff_len-1 ); /* left shift forward buffer */
    fbuff[buff_len-1] = c;                 /* new character on the end */

    memmove( rbuff+1, rbuff, buff_len-1 ); /* right shift reverse buffer */
    rbuff[0] = comp_char[c];               /* comp. character at the front */
   }


void  neighbor_output( char *desc, int pos, char *filename )
   {
#ifdef NO
    static char pbuff[MAX_BUFF_LEN+1];
    static char left[MAX_NEIGHBOR_LEN+1];
    static char mat[MAX_PAT_LEN+1];
    static char fmt[MAX_STR_LEN+1];
    char        dir;
    int         n_mis;

    /* printf( "neigh %d [%s] [%s]\n", pos, buff, desc );  return; */

    sscanf( desc, "%c %d", &dir, &n_mis );
    /* if ( desc[0] == 'r' ) */
    if ( dir == 'r' )
        rc( pbuff, buff );
    else
        strncpy( pbuff, buff, buff_len );
     
    strncpy( left, pbuff, neighbor_len );
    strncpy( mat,  pbuff + neighbor_len, templ_len );
    sprintf( fmt, "%%10d  %%c  %%s %%-%d.%ds %%-10s %%2d %%s", 
                             templ_len, templ_len );
    printf( fmt,
             pos, dir, left, mat, pbuff+neighbor_len+templ_len, n_mis,
             filename );
#endif
   }

/* Calculates number of mismatches between given string and sequence  */
/* in r... template */

int  mismatches( char *s, regulator_t *r )
   {
    char *t;
    int   m = 0;

    for ( t = r->templ; *t != '\0' && *s != '\0';  t++, s++ )
        if ( ! matches[ nt_index[(int) *s] ][ nt_index[(int) *t] ] )
            m++; 
    return( m );
   }



/* Calculates additive score of string S with respect to case matrix */ 
/* of regulator R                                                    */

double calc_add_score( char *s, regulator_t *r )
   {
    double sc = 0.0;
    int  i, len;
    len = r->templ_len;

    for ( i = 0; i < len; i++ )
       if ( nt_index[(int) s[i]] >= 0 )
           sc += r->matrix[i][(int) nt_index[(int) s[i]]];
    return( sc / len );
   }

/* Calculates log-additive score of string S with respect to case matrix */ 
/* of regulator R                                                        */

double calc_log_score( char *s, regulator_t *r )
   {
    double lsum = 0.0;
    int  i, len;
    len = r->templ_len;

    for ( i = 0; i < len; i++ )
       /*if ( nt_index[s[i]] >= 0  ) */
       if ( nt_index[(int) s[i]] >= 0  && r->templ[(int) i] != 'N' )
           /* lsum += log10( (r->matrix[i][nt_index[s[i]]] / 0.25) + LOG_EPSILON); */
           lsum += r->log_matrix[i][(int) nt_index[(int) s[i]]]; 
   /*  return( pow( 10.0, lsum ) ); */
    return( lsum );
   }


double (*calc_score)( char *s, regulator_t *r );


/* returns 1 if score/mis pass the threshold cut in r */

int  pass( regulator_t *reg, double score, int mis )
   {
    if ( reg->logic_and ) 
        return( score >= reg->min_score && mis <= reg->max_mismatch );
    else
        return( score >= reg->min_score || mis <= reg->max_mismatch );
   }

/* writes one line of output for a hit */
 
void  output_line( char *seqid, int offset, double score, int mis, 
                   char *matseq, regulator_t *reg, char dir )   
   {
    if ( score_method == LOG1_SCORE )
        score = pow( 10.0, score );
    if ( gff )   /* print GFF format */
        fprintf( outstream, 
                 "%s\tscoresite\t%s\t%d\t%d\t%0.3lf\t%c\t.\tInstance %s\n",
                 seqid, reg->name, offset, offset + reg->templ_len, score,
                 ( dir == 'f' ? '+' : '-' ), matseq); 
    else        /* print native scoresite format */
        fprintf(outstream,  "%-30.30s\t%d\t%c\t%0.3lg\t%d\t%-25s\t%s\n", 
                 seqid, offset, dir, score, mis, matseq, reg->name );  
   }

/*****************************************************/
/* scan_file() - open file and process its sequences */
/*****************************************************/

void  scan_file( FILE  *f , regulator_t *reg )
   {
    int          c, last;
    static char  hdr[MAX_HDR_LEN+1];
    int          pos;   /* position within string */
    double       sc;
    int          mis;    

    if ( verbose ) printf(  "scoresite: scan_file(): scanning file with "
                            "regulator %s\n", reg->name );
    last = '\n';
    while ( (c = fgetc( f ) ) != EOF )
       {
        if ( last == '\n' && c == '>' ) 
           {
            fgets( hdr, MAX_HDR_LEN, f );
            if ( verbose )
                printf( "scoresite: scan_file(): sequence header: %s", hdr );
            if ( strlen( hdr ) > 0 )
                hdr[strlen(hdr)-1] = '\0';
            init_buff( reg );
            pos = 1 - (reg->templ_len + neighbor_len);  /* counting from one */
            last = '\n';
           }
        else if ( isalpha( c ) ) 
           {
            enter_base( c );
            ++pos;

             /* check forward buffer... */

            sc = (*calc_score)( fbuff, reg );
            mis = mismatches( fbuff, reg );
            if ( pass( reg, sc, mis ) )
                output_line( hdr, pos-1, sc, mis, fbuff, reg, 'f' ); 

             /* check reverse buffer... */

            sc = (*calc_score)( rbuff, reg );
            mis = mismatches( rbuff, reg );
            if ( pass( reg, sc, mis ) )
                output_line( hdr, pos-1, sc, mis, rbuff, reg, 'r' );
             
            last = c;
           }
        else
            last = c;
      }
}



        /* MAIN PROCEDURE */
int main (int argc, char *argv[])
{    
    int i,j, retval;
    FILE *f;

    /* parse command line arguments via argtable */
    parse_arguments( argc, argv );

    /* Where do we send output? */
    if (outfile) {
         if (verbose) printf("scoresite: main(): opening outfile %s\n", outfile);
        outstream = fopen (outfile, "w");
        if ( outstream == NULL ) {
            printf("scoresite: main(): FAILED to open file \'%s\': %s\n", outfile, strerror(errno) );
            return 1;
        }    
      }
        
    /* What configuration file to use? If not specified in args, look on system.. */
    if ( conf_filename == NULL ) {  // file not specified in args
        retval = choose_config_file();
        if (debug) 
            printf("scoresite: main(): retval from choose_config_file was %d\n", retval);
        if (retval) {
            printf("scoresite: main(): no configuration file found, and none specified. exitting.\n");
            exit(0);
        }
    }
    else {
        if (verbose)
            printf("scoresite: main(): config specified, no need to search system.\n");    
    }
    
        
    /* Zero out regulator arrays, just to be careful */
        clear_regulators();

        clear_regexps();

    /*  score_method MUST be set before parse_config_file is invoked! */
    /* But: this needs to be put somewhere else */

    if ( score_method == ADD_SCORE )
        calc_score = calc_add_score;
    else if ( score_method == LOG1_SCORE )
        calc_score = calc_log_score;
    else
       {
        fprintf( stderr, 
                 "scoresite: internal erro - score method is %d\n", 
                 score_method );
        exit( 1 );
       }

    /* Parse config file so we can print list if requested...  */
    retval = parse_config_file();
    if ( retval ){
        printf("scoresite: main(): ERROR parsing config file %s\n", conf_filename);
        exit(1);     
    }

    /* Just print regulator list?... */
    if ( list ) 
       {
        print_reglist();
        exit( 0 );
       }
      
    /* Initialize nucleotide index */
    init_nt_index();

      /* Print argument values */
      if (verbose) {
          printf (     "scoresite: main(): using regulators = %s\n"
                        "scoresite: main(): mismatch = %d\n"
                      "scoresite: main(): min_score = %2.3f\n"
                      "scoresite: main(): gff flag = %d\n"
                      "scoresite: main(): logic_and flag = %d\n"
                      ,
                      reglist, 
                       mismatch, 
                       score,
                       gff,
                       logic_and
           );
           if ( outfile != NULL ) printf("scoresite: main(): output filename = %s\n", outfile);
      } // end verbose
      
 
      /* If we have one, parse regulator list and set regulators,  */
      if ( strcmp(reglist , "ALL") != 0 ) {
          if ( verbose ) printf("scoresite: main(): specified regulators, parsing...\n"); 
        parse_reglist(reglist);
      }
      else {
          if ( verbose) printf("scoresite: main(): regulators not specified, using all..\n");
          for ( i = 0; regulators[i] != NULL ; i++) {
              regs_to_use[i] = regulators[i];    
          }
          if ( verbose ) 
              print_regs_to_use();
      }
      
      /* Apply user-supplied vals for mismatch, if given   */
      if ( mismatch > -1 ){
          i = 0;
          while ( regs_to_use[i] != NULL ) {
              regs_to_use[i]->max_mismatch = mismatch;    
              i++;
          }    
      }
  
  /* Apply user-supplied vals for score, if given   */
      if ( score > -1.0 ) {
          i = 0;
          while ( regs_to_use[i] != NULL ) {
              set_reg_score( regs_to_use[i], (double) score );
              i++;
          }    
      }

    /* Apply user-supplied vals for hit logic, if given   */
    if ( logic_and > -1 ){
        i = 0;
          while ( regs_to_use[i] != NULL ) {
              regs_to_use[i]->logic_and = logic_and;    
              i++;
          }    
    }      



      /* Finally, scan all input files with selected regulators... */
      if ( num_infiles > 0 ) // read from all specified input files
      {
          if (verbose)
              printf ("scoresite: main(): %d infiles specified.\n", num_infiles);
          for ( i = 0; (( i < num_infiles)  && (i < MAX_ARGS) ) ; i++ ){
               for ( j = 0; (( regs_to_use[j] != NULL ) && ( j < MAX_REGULATORS ) ); j++) {
                   if (verbose)
                      printf("scoresite: main(): opening file %s for scan.\n", infiles[i]);
                   f = open_file(infiles[i]);
                   scan_file( f, regs_to_use[j] );
                   close_file(f);         
               }
          }
        return 0;
      }
      return 0;
      
} // end main()

