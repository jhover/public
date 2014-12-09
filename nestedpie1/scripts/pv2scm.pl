#!/usr/bin/perl
#
#  run this on p-values_for_16S_group_population_differences.5.90

print "(define tree \n";
print "  '( (root 0 0 0)\n";

$current_lev = -1;

while ( <> )
   {
    next if ( /^\s*;/ );
    ( /^(\t*)(\S.*)\s\((\d+)\)\s\((\d+)\), p-value = (\S+)/ ) 
       || die "Bad line $_\n";
    ($indent, $name, $c1, $c2, $pvalue) =  ($1, $2, $3, $4, $5);
    $lev = length($indent);
    print ";; $lev \"$name\" $c1 $c2, $pvalue\n";
    #die "lev $lev > 4!\n" if ( $lev > 4 );

    if ( $lev == $current_lev )
       { print "; ;same lev\n"; 
         print "$current_indent ) \n";
         print "$current_indent ( (\"$name\" $c1 $c2 $pvalue) \n";
         $current_indent = $indent;
       }
    elsif ( $lev < $current_lev )
       { 
         print ";; decrease lev\n";
         while ( $current_lev-- >= $lev )
            { print ")"; }
         print "\n";
         $current_lev  = $lev;
         $current_indent = $indent;
         print "$current_indent ( (\"$name\" $c1 $c2 $pvalue ) \n";
       }
    elsif ( $lev == $current_lev + 1 )
       {
         #print "increase lev\n";
         $current_lev = $lev;
         $current_indent = $indent;
         print "$current_indent ( (\"$name\" $c1 $c2 $pvalue ) \n";
       }
    else
       { die "Illegal case: $lev, where current = $current_lev\n"; } 
   }

while ( $current_lev-- >= 0 )
   { print " ) "; }
print "))\n";
