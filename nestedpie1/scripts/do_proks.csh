#!/bin/csh

alias nested-pie "mzscheme -r nested-pie.scm"

#nested-pie -T "Figure 1a" -P amb pv.5.90. > prok6amb.ps ; pstopdf prok6amb.ps
#nested-pie -T "Figure 1b" -P elev pv.5.90. > prok6elev.ps ; pstopdf prok6elev.ps
#open -a Preview prok6*.pdf


#final version?

nested-pie -P amb pv.5.90. > prok7amb.ps ; pstopdf prok7amb.ps
nested-pie -P elev pv.5.90. > prok7elev.ps ; pstopdf prok7elev.ps
open -a Preview prok7*.pdf
