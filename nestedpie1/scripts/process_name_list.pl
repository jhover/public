#!/usr/bin/perl
#
$thresh = 15;

while ( <> )
   {
    chomp;
    ($name,$amb,$elev) = split( /\s+/ );
    if ( $amb + $elev >= $thresh || $amb >= $thresh || $elev >= $thresh )
       {
        print "(show-label \"$name\")\n";
        print "(set-c-offsets   \"$name\" \'(0 0) \'cent)\n";
       }
   }
