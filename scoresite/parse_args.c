/* File:  parse_args.c */

#include "scoresite.h"
#include "argtable2.h"      /* Provides command line argument parsing */    


/* vars settable by command line args  */

int     debug = 0;         /* debug flag                         */
int     verbose = 0;       /* verbose flag                       */
int     ignore_case = 0;   /* case insensitive flag              */
int     list = 0;          /* list flag                          */
int     gff = 0;           /* GFF output flag                    */
int     logic_and;         /* AND/OR command line request.       */
int     n_order;           /* number of nucleotides to consider for normalization*/
int     mismatch;          /* command line maximum mismatch      */
float   score;             /* command line minimum score         */
int     score_method;      /* command line score method          */
char   *reglist;           /* command line regulator list string */
char   *outfile;           /* command line outfile name          */
char   *infiles[MAX_ARGS]; /* command line arguments             */
int     num_infiles;   

FILE   *outstream;         /* where to send output               */
FILE   *instream;          /* where to get input                 */

/*********************************************************
 * Procedure to collect all command line options. Placed
 * in a single procedure to make this the only place where
 * argtable-specific functionality is used. 
 * 
 * ******************************************************/
int parse_arguments( int argc, char *argv[] ) 
   {
    int aterrors; /* argtable errors count  */
    int j;

    /* These argtable structs hold the values parsed from command line by arg_parse() */
    struct arg_lit *l, *O, *A, *v, *d, *g, *h, *i; 
    struct arg_str *r, *S;
    struct arg_file *c , *o , *inf;
    struct arg_int *m, *n;
    struct arg_dbl *s ;
    struct arg_end *end;

    /* Argtable entries  */
    void *argtable[] = {
        h = arg_lit0(  "h", "help",  "Print this helpful message."),
        i = arg_lit0(  "i", "ignore-case", 
                            "Perform case-insensitive DNA comparisions" ),
        c = arg_file0( "c", "config", "<configfile>",
                            "Override default configuration file"),    
        v = arg_lit0(  "v", "verbose","Produce verbose output"),
        d = arg_lit0(  "d", "debug", "Produce debugging output"),
        g = arg_lit0(  "g", "gff", "Output in GFF format"),
        A = arg_lit0(  "A", "and", 
                            "Use AND logic for output decision, overriding cfg"),
        O = arg_lit0(  "O", "or", 
                            "Use OR logic for output decision, overriding cfg"),
        l = arg_lit0(  "l", "list", "List available definitions in cfg"),

        S = arg_str0(  "S", "Scoring method", "<add,log1>" , 
                            "Scoring method: additive or log-prob"),
        r = arg_str0(  "r", "regulators", "<s>" , 
                            "Comma-separated list of regulators: re1,cre,re3"),
        n = arg_int0(  "n", "n-order", "<n>",  
                            "num. of nucleotides used for normalizing: 0, 1 or 2"),
        m = arg_int0(  "m", "mismatch", "<n>",  
                            "Number of mismatches-overrides for ALL regulators"),
        s = arg_dbl0(  "s", "score", "<f>", 
                            "Minimum hit score-overrides for ALL regulators"),
        o = arg_file0( "o", "outfile", "<outfile>" , 
                            "Output to <outfile> instead of STDOUT"), 
        inf = arg_filen( NULL, NULL, "FILE", 0, argc + 2, "Input file(s)" ),
        end = arg_end(20),
    };

    /* verify the argtable[] entries were allocated sucessfully */
    if (arg_nullcheck(argtable) != 0)
        {
        /* NULL entries were detected, some allocations must have failed */
        printf("scoresite: parse_arguments(): insufficient memory\n");
        return 1;       
        }

    /* Parse the command line as defined by argtable[] */
    aterrors = arg_parse(argc,argv,argtable);

    /* If the parser returned any errors then display them and exit */
    if (aterrors > 0) {
        /* Display the error details contained in the arg_end struct.*/
        arg_print_errors(stdout,end,progname);
        printf("Try '%s --help' for more information.\n",progname);
        exit(1);
    }    


    /* Set argument defaults */
    verbose = 0;
        ignore_case = 0;
    debug = 0;
    gff = 0;
    mismatch = -1;
    score = -1;
    logic_and = -1;
    list = 0;
    outfile = NULL;
    outstream = stdout;  /*by default, send everything to stdout  */
    instream = stdin;
    reglist = "ALL";  /* by default, use all regulators   */


    /* Collect all command line arguments into global vars  */
     if (d->count > 0 ){
          verbose = 1;
          debug = 1;
          printf("scoresite: parse_arguments(): debug flag set\n");
      }
    
    if ( v->count > 0 ){ 
          verbose = 1;
        if (debug)
        printf("scoresite: parse_arguments(): verbose flag set\n");
    }    

    if ( i->count > 0 ){ 
          ignore_case = 1;
        if (debug)
        printf("scoresite: parse_arguments(): ignore_case flag set\n");
    }    
          
    if ( g->count > 0 ){
        gff = 1;
        if (debug)
         printf("scoresite: parse_arguments(): gff flag set\n");
    }
    
    if (l->count > 0 ){
        list = 1;
        if (debug)
         printf("scoresite: parse_arguments(): list flag set\n");
        
    }

    if ( n->count > 0 )
       {
        n_order = n->ival[0];
        if (debug)
             printf("scoresite: parse_arguments(): n_order: %d\n", n_order );    
        if ( n_order < 0 || n_order > 2 )
           {
           fprintf( stderr, 
                    "%s argument given to --n-order (-n) must be 0, 1 or 2\n", 
                    progname );
            exit( 1 );
          }
       }

    if ( m->count > 0 )
       {
        mismatch = m->ival[0];
        if (debug)
             printf("scoresite: parse_arguments(): mismatch: %d\n", mismatch);    
       }
    
    if (s->count > 0 ){
        score = s->dval[0];
    if (debug)
         printf("scoresite: parse_arguments(): score: %f\n", score);    
        
    }
    
    
    if (o->count > 0 ){
        outfile = (char *) o->filename[0]; 
        if (debug)
          printf("scoresite: parse_arguments(): outfile name: %s\n", outfile);    
    }        
    if ( inf->count > 0 ){
        num_infiles = inf->count;
        for ( j = 0; j < inf->count; j++) {
            infiles[j] = (char *) inf->filename[j];
        }
    }

    if ( S->count > 0 )
       {
        if ( strcmp( (char *) S->sval[0], "add" ) == 0 )
            score_method = ADD_SCORE;
        else if ( strcmp( (char *) S->sval[0], "log1" ) == 0 )
            score_method = LOG1_SCORE;
        else
           {
            fprintf( stderr, "scoresite: score method must be \"add\" or \"log1\"\n" );
            exit( 1 );
           }
       }  
    else
        score_method = ADD_SCORE;
    if ( debug )
        printf("scoresite: parse_arguments(): score_method: %d\n", score_method);    
        
    if ( r->count > 0 )
        reglist = (char *)  r->sval[0];    
    
    if ( c->count > 0 )
        conf_filename = (char *) c->filename[0];    

    
    if (h->count > 0 ) {
        printf("scoresite: Version %s--Search for degenerate sites in DNA sequences using a frequency matrix.\n", version);
        printf("Usage:    scoresite "); 
        arg_print_syntaxv(stdout, argtable, "\n");
        arg_print_glossary(stdout, argtable, "     %-28s %s\n");
        printf("Report bugs to <%s>\n", bugaddress);
        exit(0);
    }
     
    if ( A->count > 0 )
        logic_and = 1;

    if ( O->count > 0 )
        logic_and = 0;    
     
     
         
    return 0;
} /* end parse_arguments */
