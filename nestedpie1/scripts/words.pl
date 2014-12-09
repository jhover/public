#!/usr/bin/perl
#

while ( <> )
   {
    chomp;
    s/^\s+//;
    s/\s+$//;
    foreach $w ( split() )
       { 
        print "$w\n";
       }
   }
