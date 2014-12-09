#include "scoresite.h"

int          num_regulators = 0;

regulator_t *regulators[MAX_REGULATORS];   /* All the regulators from the config file(s) */

regulator_t *regs_to_use[MAX_REGULATORS];  /* Regulators we actually want to use to search*/
                                           /* for sites. Filled in by parse_reglist()     */


/* Zeros out regulator arrays, just to be careful */

void  clear_regulators( void )
   {
    memset( regulators, 0, sizeof(regulators) );
    memset( regs_to_use, 0 , sizeof(regs_to_use) );
   }

/**********************************
 * Parses command line provided list of 
 * comma-separated regulators. 
 *********************************/

void  parse_reglist(char * regstr) 
   {
    int          next_idx = 0;    
    char        *c;
    char        *delim = ",";
    regulator_t *r;
    
    if (verbose) 
        printf( "scoresite: parse_reglist(): regulator list: %s\n", regstr );
            
    c = strtok( regstr, delim );
    if ( debug ) 
        printf( "scoresite: parse_reglist(): next(0) reg is %s\n", c );        
    if ( ( r = (regulator_t * ) get_regulator(c) ) != NULL ) 
       {
        regs_to_use[next_idx] = r;
        next_idx++;    
       }
    while ( (c = strtok(NULL,delim)) != NULL )
       { 
        if ( debug ) 
            printf("scoresite: parse_reglist(): next(+) reg is %s\n", c );
        
        if ( ( r = (regulator_t * ) get_regulator(c) ) != NULL ) 
           {
            regs_to_use[next_idx] = r;
            next_idx++;    
           }    
       }
    if (verbose) 
       printf( "scoresite: parse_reglist(): found %d regulators to use.\n", 
                next_idx );
   }


/**************************************************************************/
/* Finds regulator with desired name and returns a pointer to it. Used by */
/* argument parsing code.                                                 */
/**************************************************************************/

regulator_t * get_regulator(char* name) 
   {
    int i;
    
    if ( debug ) 
       printf( "scoresite: get_regulator(): searching for %s\n", name) ;
    
    for ( i = 0;  i < MAX_REGULATORS && regulators[i] != NULL ; i++) 
        if ( strcmp( ((regulator_t* ) regulators[i])->name, name ) == 0 )
           {
            if ( debug ) 
                printf( "scoresite: get_regulator(): found regulator named %s\n",name);    
            return( regulators[i] );
           }

    printf( "scoresite: get_regulator(): failed to find regulator %s, "
            "check your command line arguments\n", name) ;
    return( NULL );
   }

/**************************************************/
/* Prints list of regulators defined in conf file */
/**************************************************/

void print_reglist( void ) 
   {
    int i;

    if ( num_regulators > 0 ) 
       {
        printf("scoresite: available regulators:\n");    
        
        for ( i = 0; i < num_regulators ; i++ )
            printf(" %s\n", regulators[i]->name );    
       }
    else
        printf( "scoresite: no regulators in %s \n", conf_filename );
   }

/**************************************************/
/* Prints list of regulators defined in conf file */
/**************************************************/

void print_regs_to_use( void )
   {
    int i = 0;
    while ( regs_to_use[i] != NULL ) 
       {
        printf( "scoresite: regs_to_use():  %s\n", regs_to_use[i]->name );
        i++;    
       }
   }


void  fill_matrix_const( double m[MAX_PAT_LEN+1][MAX_NT_INDEX_VALUE],
                          int len, double c )
   {
    int b, i;  /* b for base, i for motif position */

    for ( b = 0; b < MAX_NT_INDEX_VALUE; b++ )   /* do this with a memset*/
        for ( i = 0; i <= len; i++ )
            m[i][b] = c;
   }

void  print_matrix( char  *label, 
                    double m[MAX_PAT_LEN+1][MAX_NT_INDEX_VALUE],
                    int    len
                  )
   {
    int b, j;

    printf( "%s:\n", label );
    for ( b = 0; b < MAX_NT_INDEX_VALUE; b++ )
       {
        printf( "%d: ", b );
        for ( j = 0; j < len; j++ )
            printf( "%g ",  m[j][b] );
        printf( "\n" );
       }

   }

/* This could be generalized and invoked from freq_norm.c as well */
void  init_reg_log_matrix( regulator_t *r )
   { 
    int i, j;

    for ( i = 0; i <= MAX_PAT_LEN; i++ )
        for ( j = 0; j < MAX_NT_INDEX_VALUE; j++ )
            r->log_matrix[i][j] = log10( LOG_EPSILON );
   }

/* set the regulator score - mind whether or not we're doing logs */

void  set_reg_score( regulator_t *r, double score )
   {
    if ( score_method == ADD_SCORE )
        r->min_score = score;
    else
       {
        if ( score < 1.0e-30 )
            r->min_score = -100000.0;
        else
            r->min_score = log10( (double) score );
       }
   }
