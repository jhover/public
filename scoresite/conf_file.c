/* File:   conf_file.c */


#include "scoresite.h"
#include "regex.h" 	      /* Provides regular expression matching */


    /* STUFF FOR REGULAR EXPRESSIONS FOR CONFIG PARSING  */

char   line[MAX_LINE_LEN];        // general use buffer
char *conf_filename = NULL;
char  conf_filepaths[NUMCONFPATHS][MAX_LINE_LEN] = 
   { 
    "to be filled by homedir path", 
    "to be filled by envvar path",
    "/usr/local/etc/scoresite/scoresite.conf",
    "/usr/etc/scoresite/scoresite.conf",
    "/usr/local/seq/etc/scoresite/scoresite.conf"
    };
    
/* Arrays for regular expression patterns and compiled objects */
char    *regexp[MAX_REGEX];
regex_t *regexp_comp[MAX_REGEX];

/* Indices for different regexps */
/* perhaps enum is better?  more modern? */
#define COMMENT      0 /* was int COMMENT = 0; */
#define BLANK        1 /*     int BLANK = 1; */
#define REG_NAME     2 /*     int REG_NAME = 2; */
#define DESC         3 /*     int DESC = 3; */
#define MINSCORE     4 /*     int MINSCORE = 4; */
#define MAXMIS       5 /*     int MAXMIS = 5; */
#define MATRIX_BEGIN 6 /*     int MATRIX_BEGIN = 6; */
#define LOGIC_AND    7 /*     int LOGIC_AND = 7; */

void  initialize_regexps( void );

/* init_freq_norm_array() must be invoked before load_log_matrix() */

void  load_log_matrix( regulator_t *r, int len )
   {
    int  i, k;

    for ( k = 0; k < 4 ; k++)    /* MAX_NT instead of 4? */
        for ( i = 0; i < len ; i++) 
            //r->log_matrix[i][k] = log10( (prob / 0.25) + 0.0000001);
            r->log_matrix[i][k] = log10( (r->matrix[i][k] / r->freq_norm[i][k]) 
                                         + LOG_EPSILON );
   }

/******************************************************************/
/*  Sets templ, templ_len and fills matrix for current regulator  */ 
/*  return value 0 for successful load, 1 for error               */
/******************************************************************/

int load_matrix( FILE *f, int reg_idx )
   {
    char         c;
    int          i, k;
    regulator_t *r;  
    
    r = regulators[reg_idx];  

    /* First handle template line... */

    fgets( line, MAX_LINE_LEN, f );
    int templ_len = 0;
    for ( i = 0 ;  line[i] != '\n'; i++ ) 
       {
        c = line[i];
        if ( (c == ' ') || ( c == '\t' ) ) 
           {
            /*if ( debug) printf("found space or tab in template line\n"); */
            /* do nothing, just increment i */
           }
        else if ( is_valid_base(c) )
           {
            if (debug) 
                printf( "scoresite: load_matrix(): valid base %c in template, index is %d \n", c, templ_len);
            r->templ[templ_len] = c;
            templ_len++;
           }
        else 
           {
            fprintf( stderr, 
                     "scoresite: load_matrix(): bad character \"%c\" in %s\n", 
                          c, conf_filename );
            return( 1 ); /* bad load */
           }
       }
    regulators[reg_idx]->templ[templ_len] = '\0';
    regulators[reg_idx]->templ_len = templ_len;
    if ( verbose )
        printf( "scoresite: load_matrix(): regulator: %s %dbp [%s]\n", 
                 (char *) &(r->name), templ_len, (char *) &(r->templ) );

    int scanno = 0;
    float prob = 0.0;

    for ( k = 0; k < 4 ; k++) 
       {
        fscanf( f, "%s ", line );
        if (debug) 
           printf("scoresite: load_matrix(): line header is %c\n", line[0] );
        /* int rowidx = nt_index[line[0]]; */
        scanno++;
        for ( i = 0; i < templ_len ; i++) 
           {
            fscanf( f, "%s " , line );
            sscanf( line , "%f", &prob );
            if (debug) printf( "scoresite: load_matrix(): value %d is %2.3f \n",scanno, prob );
            if (debug) printf( "scoresite: load_matrix(): set matrix[%d][%d] = %f\n", i, k, prob ); 
            r->matrix[i][k] = prob;
            scanno++;
           }
       }
    if ( score_method == LOG1_SCORE )
       {
        init_freq_norm_array( r, templ_len ); 
        load_log_matrix( r, templ_len );
       }

    return( 0 ); /* successful load */ 
   } 


/****************************************************************/
/* Goes through alternate locations for config file and sets    */
/* conf_filename to the correct value. Only a filename given    */
/* on the command line can override this choice.                */
/*                                                              */
/* Returns 0 for success, 1 for failure.                        */
/****************************************************************/

int choose_config_file( void )
   {
    FILE * f;
    int i;

    if (verbose)
        printf ("scoresite: choose_config_file(): ...\n");
    
    /* get homedir conf path */
    char *homedir = (char *) getenv("HOME");
    int hdlen = strlen(homedir);
    strcpy( line, homedir);
    if (verbose) 
        printf( "scoresite: choose_config_file(): homedir is %s\n" , line );
    strcpy ( line + hdlen , "/.scoresite/scoresite.conf");
    if (verbose)
        printf( "scoresite: choose_config_file(): homedir conf path is %s\n", 
                line);
    strcpy( conf_filepaths[0], line );    
    
    /* get environement var */
    char *envdir = (char *) getenv( "SCORESITE_DIR" );
    if (verbose ) 
       {
        if ( envdir == 0 )
            printf("scoresite: choose_config_file(): SCORESITE_DIR not set\n");
        else
            printf ("scoresite: choose_config_file(): SCORESITE_DIR = %s\n" , envdir );
       }
    if ( envdir )
        strncpy( conf_filepaths[1], envdir, MAX_LINE_LEN - 2 );
    
    /* print all options if requested... */
    if (verbose) 
       {
        printf("scoresite: choose_config_file(): filled path array:\n");
        for ( i = 0; i < NUMCONFPATHS ; i++)
            printf("%d:  %s\n",i,conf_filepaths[i]);
       }

    /* take first good path */
    for ( i= 0; i < NUMCONFPATHS; i++ ) 
       {
        f = fopen( conf_filepaths[i], "r");
        if ( f != NULL ) 
           {
            if ( verbose ) 
                printf("scoresite: choose_config_file(): found config at %s\n",
                       conf_filepaths[i]);
            conf_filename = conf_filepaths[i];
            fclose(f);
            return 0;    
           }
       }
    if ( verbose )
        printf("scoresite: choose_config_file(): no config file found...\n");
    
    return( 1 );
   } /* end choose_config_file() */

   

/***************************************************************************/
/* Reads in configuration file, filling in the array of structs describing */
/* each regulator.                                                         */
/*                                                                         */
/* Return value 0 for successful parse, 1 for error.                       */
/*                                                                         */
/***************************************************************************/

int  parse_config_file( void )
   {
    FILE *f;
    char *c;         /* char pointer */
    int lineno = 1;
    int retval = 0;    
    int matchno;   /* return value of regular expression search 0 means match*/
    int regidx;    /* index into regulators[] of current regulator */

    if (debug) 
        printf("scoresite: parse_config_file()...\n");

    initialize_regexps();
     
    if ( ( f = fopen( conf_filename, "r") )  ) 
       {
        if (verbose ) 
            printf("scoresite: using configuration file %s\n", conf_filename );
       }
    else 
       {
        printf( "scoresite: ERROR: unable to open configuration "
                "file %s\n", conf_filename );
        exit( errno ); 
       }
    
    regmatch_t *result = (regmatch_t *) malloc (sizeof(regmatch_t));
    
    while ( ( c = fgets( (char * ) line, ( MAX_LINE_LEN - 1 ), f ) ) )
       {
        trim(c);
        int i;
        
        for ( i = 0; i < NUM_REGEX ; i++ ) 
           {
            /*  Reset result to 0 each time...  */
            memset(result, 0, sizeof(regex_t));
            
            /* check for match ... */    
            matchno = regexec( regexp_comp[i], c , 1 , result, 0 );
            
            /* regexec returns 0 if there is a match, 1 otherwise... */
            if ( matchno == 0 ) 
               {
                /* printf("matline: %s", c); */
                switch( i ) 
                   {
                    case COMMENT:
                        if ( debug ) 
                            printf("scoresite: parse_config_file(): comment: %s\n", c);
                        break;
                    
                    case BLANK:
                        if ( debug ) 
                            printf("scoresite: parse_config_file(): blank: %s\n", c );
                        break;
                    
                    case REG_NAME:
                        if ( debug ) 
                            printf("scoresite: parse_config_file(): name: %s\n", c);
                        num_regulators++;
                        regidx = num_regulators - 1;
                        regulators[regidx] = 
                            (regulator_t *)  malloc( sizeof(regulator_t));
                        memset( regulators[regidx], 0, sizeof(regulator_t));
                        init_reg_log_matrix( regulators[regidx] );

                        char * s = c;
                        s++;
                        chomp(s); 
                        strncpy( (char *) regulators[regidx]->name, s, 
                                 MAX_NAME_LEN );    
                        if ( debug ) 
                            printf("scoresite: parse_config_file(): parsed name %s\n",s );
                        break;
                    
                    case DESC:
                        if ( debug ) 
                            printf("scoresite: parse_config_file(): description: %s\n", c);
                        strncpy( (char * ) regulators[regidx]->description, 
                                 c, MAX_DESC_LEN );
                        break;
                    
                    case MINSCORE:
                        if ( debug ) 
                            printf( "scoresite: parse_config_file(): minscore: %s\n", c );
                        float infloat;
                        sscanf( c, "%*s %f", &infloat);
                        set_reg_score( regulators[regidx], (double) infloat );
                        if (debug)
                            printf("scoresite: parse_config_file(): parsed a minscore of %2.3le\n", regulators[regidx]->min_score);
                        break;
                    
                    case MAXMIS:
                        if ( debug ) 
                           printf("scoresite: parse_config_file(): mismatch: %s\n", c);
                        int inint;
                        sscanf( c, "%*s %d", &inint );
                        regulators[regidx]->max_mismatch = inint;
                        if ( debug ) 
                           printf("scoresite: parse_config_file(): parsed a mismatch of %d\n", regulators[regidx]->max_mismatch);
                        break;
                    
                    case MATRIX_BEGIN:
                        if ( debug ) 
                            printf( "scoresite: parse_config_file(): begin matrix: %s\n", c);
                        retval = load_matrix( f, regidx );
                        break;
                    
                    case LOGIC_AND:
                        c = c + 6; /* move pointer after word "logic" */
                        trim(c);   /* remove whitespace */
                        if ( debug ) 
                           printf("scoresite: parse_config_file(): logic: %s\n", c);
                        if ( strcmp(c , "and") == 0 ) 
                           {
                            if ( debug ) 
                                printf("scoresite: parse_config_file(): logic found to be AND\n");                                            
                            regulators[regidx]->logic_and = 1;
                           }
                        else 
                           {
                            if ( debug ) 
                               printf("scoresite: parse_config_file(): logic found to be OR\n");    
                            regulators[regidx]->logic_and = 0;
                           }
                        /*strncpy( (char * ) regulators[regidx]->description , c , MAX_DESC_LEN ); */
                        break;
                    
                    default:
                        printf("scoresite: parse_config_file(): ERROR parsing line %s\n", c);
                        break;
                   } /* end switch */
               } /* end if line matched something */
           } /* end for all regexps lines */
            
        lineno++;
       } /* end for all lines of file... */
    return( 0 ); /* successful parse */
   } /* end parse_config_file */


void  clear_regexps( void )
   {
    memset( regexp, 0 , sizeof(regexp) );
    memset( regexp_comp, 0 , sizeof(regexp_comp) );
   }

/********************************************************************/
/* Initialize regular expressions used to detect the different line */
/* types within the configuration file.                             */
/********************************************************************/

void initialize_regexps( void ) 
   {
    int i = 0;
    int err_no;
    
    /* Regular expressions for line types   */
    if (debug) 
        printf("scoresite: initialize_regexps(): building pattern strings...\n");
    regexp[COMMENT] = "^#";                     /* comment lines             */
    regexp[BLANK] = "^[:space:]$";              /* blank line                */
    regexp[REG_NAME] = "^\\[[[:alnum:]-]*\\]";  /* line w/regulator name/hdr */
       /* note: orig. "^\[[[:alnum:]-]*\]" extra escape needed for C compiler*/
    regexp[DESC] = "^description";
    regexp[MINSCORE] = "^minscore";
    regexp[MAXMIS] = "^maxmismatch";
    regexp[LOGIC_AND] = "^logic";
    regexp[MATRIX_BEGIN] = "^matrix";
    
    if (debug) 
        printf("scoresite: initialize_regexps(): compiling regexps...\n");    
    for (i = 0; i < NUM_REGEX; i++ )
       {
        /* Compile the regex, print error if it fails */
        if (debug) 
            printf("scoresite: initialize_regexps(): compiling regexp %d\n", 
                    i );
        
        /* Make space for the regular expression */
          regexp_comp[i] = (regex_t *) malloc(sizeof(regex_t));
          memset( regexp_comp[i], 0, sizeof(regex_t) );
        
        /* Compile regular expressions */
        err_no = regcomp( regexp_comp[i], regexp[i], 0);
        if( err_no != 0) 
           {
            size_t length; 
            char *buffer;
            length = regerror (err_no, regexp_comp[i], NULL, 0);
            buffer = (char * ) malloc(length);
            regerror (err_no, regexp_comp[i], buffer, length);
            fprintf(stderr, "%s\n", buffer); /* Print the error */
            exit(errno);
           }
       }
   }
