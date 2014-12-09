/* File:          freq_norm.c                                                */
/* Description:   This houses init_freq_norm_array() and associated routines */
/*                and data.  init_freq_norm_array() is invoked on each       */
/*                regulator struct by load_matrix() after loading from       */
/*                the conf file                                              */
/*****************************************************************************/

#include "scoresite.h"


double  mono_nt_freq[MAX_NT_INDEX_VALUE] = 
                   /* A     C     G     T */
                  { 0.2918, 0.2082, 0.2082, 0.2918,  /* from UCSC mouse mm5 */
                    0.25,   0.25,   0.25,   0.25,
                    0.25,   0.25,   0.25,   0.25,
                    0.25,   0.25,   0.25,   0.25,
                    0.25,   0.25,   0.25,   0.25 
                  };

/****************************************************************************/
/* dinucleotide frequency normalization after P. Buchers p, q arrays        */
/* (J. Mol. Biol. (1990) 212, 563-578).                                     */
/*    p[i][j] is the probability nucleotide[j] occurs after nucleotide[i]   */
/*    q[j][k] is the probability nucleotide[j] occurs before nucleotide[k]  */
/****************************************************************************/

/* If I understand the probabilities right, the rows are normalized to one  */
/*  for p ...                                                               */

double  p[4][4] = 
       {  /*  A       C       G       T  */
/* A */  { 0.3131, 0.1826, 0.2511, 0.2531 },
/* C */  { 0.3577, 0.2503, 0.0401, 0.3519 }, 
/* G */  { 0.2984, 0.1955, 0.2503, 0.2558 },
/* T */  { 0.2186, 0.2130, 0.2553, 0.3131 }
       };

/* ... and the columns are normalized to one for q. */

double  q[4][4] = 
       {   /*  A      C       G       T */
/* A */  { 0.3131, 0.2558, 0.3512, 0.2531 },
/* C */  { 0.2553, 0.2503, 0.0401, 0.2511 },
/* G */  { 0.2130, 0.1955, 0.2503, 0.1826 },
/* T */  { 0.2186, 0.2984, 0.3577, 0.3131 }
       };


void  init_freq_norm_with_mono_nt( regulator_t *r, int len )
   {
    int b, i;   /* b for base, i for motif position */

    for ( b = 0; b < MAX_NT_INDEX_VALUE; b++ )
        for ( i = 0; i < len; i++ )
            r->freq_norm[i][b] = mono_nt_freq[b];
   }


/* after Bucher, JMB (1990) 212,563-578.  (Note that our frequency matrices  */
/* are transposed WRT his, ie n[b][i] == r->matrix[i][b], but not p and q)   */

void  init_freq_norm_with_dinucs( regulator_t *r, int len  )
   {
    int     a, b, c;
    int     i;             /* b & c for base, i for motif position */
    int     l = len - 1;   /* last position */
    double  u, v;       /* internal position factors */

    /* for each base */

    fill_matrix_const( r->freq_norm, len, 0.0 );     /* zero out before sums */
    for ( b = 0; b < 4; b++ )
       {
        for ( c = 0; c < 4; c++ )                          /* first position */
            r->freq_norm[0][b] += r->matrix[1][c] * q[b][c];

        /* Need to check for motif lengths < 2!!!! */
        for ( i = 1; i < l; i++ )                      /* internal positions */
           {
            u = v = 0.0;
            for ( a = 0; a < 4; a++ )
                u += r->matrix[i-1][a] * p[a][b];
            for ( c = 0; c < 4; c++ )
                v += r->matrix[i+1][c] * q[b][c];
            r->freq_norm[i][b] = sqrt( u * v );
           }

        for ( a = 0; a < 4; a++ )                          /* last position */
            r->freq_norm[l][b] += r->matrix[l-1][a] * p[a][b];
       }
   }


void  init_freq_norm_array( regulator_t *r, int len )
   {
    if ( debug )
        printf( "%s: %s: n_order is %d\n", progname, "init_freq_norm_array",
                n_order );
    switch ( n_order )
       {
        case 0:    fill_matrix_const( r->freq_norm, len, 0.25 );
                   break;

        case 1:    init_freq_norm_with_mono_nt( r, len );
                   break;

        case 2:    init_freq_norm_with_dinucs( r, len );
                   break;

        default:   fprintf( stderr,
                            "%s: %s: internal error - %d is bad n_order val\n",
                            progname, "init_freq_norm_array", n_order );
                   exit( 1 );
       }
    if ( debug )
       {
        print_matrix( "Freq  array", r->matrix, len );
        print_matrix( "Freq norm array", r->freq_norm, len );
       }
   }

