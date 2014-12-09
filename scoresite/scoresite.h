/* File:         scoresite.h                       */
/* Description:  header file for scoresite project */

#include <sys/types.h>
#include <ctype.h>
#include <errno.h>
#include <math.h>
#include <string.h>
#include <stdio.h>
#include <unistd.h>


		/*   DEFINES    */

#define MAX_LINE_LEN        1024
#define MAX_HDR_LEN          256
#define MAX_PAT_LEN          256
#define MAX_STR_LEN          256
#define MAX_NEIGHBOR_LEN      50
#define DEF_MIN_SCORE	   0.735
#define MAX_BUFF_LEN     (MAX_NEIGHBOR_LEN  + MAX_PAT_LEN + MAX_NEIGHBOR_LEN)
#define LOG_EPSILON    0.0000001   /* added before taking log10 */

/* not too many input files...*/
#define MAX_ARGS           16484 
#define MAX_NAME_LEN          64
#define MAX_DESC_LEN         512  
#define MAX_REGULATORS      1024
#define MAX_REGEX             16
#define NUM_REGEX              8
/* for array of possible configuration file paths */
#define NUMCONFPATHS           5
#define MAX_NT_INDEX         256
#define MAX_NT_INDEX_VALUE    20
#ifndef NULL
#define NULL        ((void *) 0)
#endif

		/* STRUCTS   */

/* Holds all relevant info for a single case matrix. */
typedef struct regulator 
   {
    double min_score;
    int    max_mismatch;
    int    templ_len;
    int    logic_and;                /* 0 for "and", 1 for "or" */
    char   name[MAX_NAME_LEN];
    char   description[MAX_DESC_LEN];
    char   templ[MAX_PAT_LEN + 1];
    double matrix[MAX_PAT_LEN+1][MAX_NT_INDEX_VALUE];
    double log_matrix[MAX_PAT_LEN+1][MAX_NT_INDEX_VALUE];
    double freq_norm[MAX_PAT_LEN+1][MAX_NT_INDEX_VALUE];  
   } regulator_t;

extern  double       freq_norm[MAX_PAT_LEN+1][MAX_NT_INDEX_VALUE];
                                      /* defined in freq_norm.c */

extern  const char  *progname;        /* defined in scoresite.c  */
extern  const char  *bugaddress;      /*    "     "     "        */
extern  const char  *version;         /*    "     "     "        */
extern  char        *conf_filename;   /*    "     "     "        */
extern  FILE        *outstream;       /* defined in parse_args.c */
extern  FILE        *instream;	      /*    "     "     "        */
extern  int          num_infiles;     /*    "     "     "        */
extern  char         comp_char[];     /* defined in utils.c */
extern  int          num_regulators;  /* defined in regs.c */
extern  regulator_t *regulators[];    /* defined in regs.c */
extern  regulator_t *regs_to_use[];   /* defined in regs.c */

/* vars settable by command line args, defined in parse_args.c */
extern  int    debug;
extern  int    verbose;
extern  int    ignore_case;
extern  int    list;
extern  int    gff;
extern  int    logic_and;
extern  int    n_order;
extern  int    mismatch;
extern  float  score;
extern  char  *reglist;
extern  char  *outfile;
extern  char  *infiles[];
#define  ADD_SCORE     1
#define  LOG1_SCORE    2
extern  int    score_method;   /* one of the above */
/*extern  char  *score_method; */

/* Function prototypes */

int          parse_arguments( int, char ** ); /* defined in parse_args.c */
void         clear_regulators( void );        /* defined in regs.c       */
void         print_regs_to_use( void );       /*    "     "   "          */
void         print_reglist( void );           /*    "     "   "          */
regulator_t *get_regulator( char * );         /*    "     "   "          */
void         parse_reglist( char * );         /*    "     "   "          */
int          choose_config_file( void );      /* defined in conf_file.c  */
int          parse_config_file( void );       /*    "     "   "          */
void         rev_comp( char *, char * );      /* defined in utils.c      */
int          is_valid_base( char );           /* defined in utils.c      */
void         chomp( char * );                 /*    "     "   "          */
void         trim( char * );                  /*    "     "   "          */
void         close_file( FILE * );            /*    "     "   "          */
FILE        *open_file( char * );             /*    "     "   "          */
void         init_freq_norm_array( regulator_t *, int );  /* defined in freq_norm.c */
void         print_matrix( char  *label,       /* defined in regulators.c */
                           double m[MAX_PAT_LEN+1][MAX_NT_INDEX_VALUE],
                           int    len );
void         fill_matrix_const( double m[MAX_PAT_LEN+1][MAX_NT_INDEX_VALUE],
                                int len, 
                                double c );
void         set_reg_score( regulator_t *, double );
void         init_reg_log_matrix( regulator_t *r );  /* defined in regulators.c */
void         clear_regexps( void );            /* defined in conf_file.c  */




