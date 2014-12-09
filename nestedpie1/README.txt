################
#  Software    #
################

Main graphics program:  (Scheme)
 
   nested-pie.scm           - main program and a number of higher-level
                              routines.

   nested-pie-functions.scm - sort of a catchall for simple functions
                              eventually this was going to be 
                              re-organized.  As it is now, there's
                              not a real clear line whether or not
                              a function is in here or in the main
                              module

   graf.scm         - low level graphics "primitives" (Postscript)

   io.scm           - old version of my io lib - just houses the 
                      function (disp ...) which is like println or 
                      writeln

   The program runs under mzscheme

     http://www.plt-scheme.org/software/mzscheme/

    mzscheme -r nested-pie.scm  <options> 

    mzscheme -r nested-pie.scm  -h       lists options


# Scripts

    pv2scm  (perl)  converts Dimitris phylogenetic counts into
                    scheme tree stucture which is the input for
                    nested-pie.scm

                    example:
                    pv2scm DimitrisArcheaRedo/dimitris_arch_redo.tab

    
    do_euks  - generate eukaryotic plots

    du_archs - generate archea plots
     
########
# Data #
########


    Dimitris output (main data format for this problem)

     Example:  In subdirectory  Dimitris.RDP.2007.09.27, see file

      p-values_for_16S_group_population_differences.reclassification.5.txt

     the indentation (by tab characters) indicates phylogentic
      depth. Each entry is followed by a breakdown of that entry
      at progressively lower levels until a max depth of 5 is reached.

     Each entry line has four items of data. Example:

          Opitutaceae (6) (1), p-value = 0.068790271438876
     
     1) The taxonomic identifier "Opitutaceae", in this case.
     2) The number of Ambient CO2 sample 16S sequencess placed into this 
        classification at this level:  6 in this case
     3) The number of Elevated CO2 sample 16S sequences placed into this
        classification at this level    1 in this case
     4) probability estimate that these two previous numbers are 
        statistically equal.  (this is ignored by the plot program)

    nested-pie.scm expects input in one format only - a scheme tree
    data structure.

    The perl script pv2scm converts this format into a scheme tree
    structure that nested-pie.scm inputs.  Other formats were hacked
    or processed by other scripts into the same scheme tree format.

    Because Dimitris data format combines TWO experimental results,
    there is a manditory argument on the command line which specifies
    which set to plot.  "amb" or "elev" must be explicitly stated
    to select the first or second sets.


################
# Plot Control #
################

    In addition to the input data, nested-pie.scm ALSO expects a 2nd input 
    file which contains plot control information.   This file is pure
    scheme code which is loaded after the data.  This input file name
    is determined by the input data tree filename. If the main data
    file is X.scm, the plot control input file is X.hsb.table.scm.

    The plot control file must contain a structure - a list of lists -
    called top_hsb_vals.   This lists establishes the physical order 
    (going counter-clockwise from 0 degrees) of the top-level phylogenetic
    classes (innermost circle) and also assigns their colors via HSB values
    (which are the starting points for lower levels).  In the list, there
    is one list (record) for each top-level classification, its order index
    and 3 hue, saturation and brightness values (real numbers in the    
    range  0.0 - 1.0)

     example
(define top_hsb_vals

  '(
      ("Fungi"                  1    0.125 0.75  0.85) 
      ("Viridiplantae"          2    0.25  0.75  0.9) 
      ("Cercozoa"               3    0.175  0.9  0.95 ) 
      ("Metazoa"                4    0.07  0.7  0.85)
      ("Stramenopiles"          5    0.90   0.6  0.8)  
      ("Alveolata"              6    0.56  0.6  0.9)
      ("Lobosea"                7    0.98  0.6  0.8)
      ("Cryothecomonas"         8    0.75  0.6  0.75)
      ("Proleptomonas"          9   0.175 0.6  1.0)  
      ("environmental samples"  10   0.175 0.6  1.0) 
      ("Apusomonadidae"         11    0.3   0.5  1.0) 
      ("Acanthamoebidae"        12   1.0   0.4  1.0)  
      ("Choanoflagellida"       13   0.475 0.4  0.7)  
      ("Granuloreticulosea"     14   1.0   0.4  1.0)  
      ("Cryptophyta"            15   0.575 0.4  1.0)  
      ("Plasmodiophorida"       16   0.175 0.6  1.0)  
      ("Eccrinales"             17   0.175 0.6  1.0)  
      ("Ichthyosporea"          20   0.175 0.6  1.0)  
      ("Heterolobosea"          21   0.175 0.6  1.0)  
      ("Centroheliozoa"         25   0.175 0.6  1.0)  
      ("Rhodophyta"             26   0.75  0.4  0.725) 
   ))

     The file can also contain scheme functions to force or veto
     the printing of labels, and also control label placement.
     Any scheme code can also be included if desired.

     

     
Notes:

 1)  We went through at least three rounds of reclassification
     before finally deciding on which to use, so there's a LOT
     of wreckage here.

 2)  Initially a rectangular plot was going to be an option too,
     but I eventually gave up on the idea.  There still may be some
     vestigal garbage left over from that.

 3)  There were a lot of problems with duplicate names.  In
     some cases I had to manually hack the input .scm trees.

 4)  Somewhere in the program, all underscores "_" in the names
     are converted to blanks before the labels are printed.
     This is a big disaster because the names also serve as "keys"
     for veto flags etc.   I never fixed that nightmare.
     Very embarrassing.

 5)  Identifying labels for label control in the .hsb.table.scm file 
     is really bad - It was written assuming that classifications are
     unique and sure enough, there turned out to be some classifications 
     which have the same name at different levels.


#
# For Hugenholz
#
last_converter Amb_16S_Archaea_HugenholtzClassification.txt >amb_16s_archea_hugenholtz.txt 
last_converter Elev_16S_Archaea_HugenholtzClassification.txt > elev_16s_archea_hugenholtz.txt

mzscheme -r phylo-counter.scm amb_16s_archea_hugenholtz.txt elev_16s_archea_hugenholtz.txt > 16s_archaea_hugenholtz.scm

May hugenholtzes
csv_converter Amb_Bacteria_16S_Hugenholtz_Classification.csv >amb_16s_bacteria_hugenholtz.txt

csv_converter Amb_Bacteria_16S_Hugenholtz_Classification.csv >amb_16s_bacteria_hugenholtz.txt

#
#  For new Dimitris blastn RDP
#


