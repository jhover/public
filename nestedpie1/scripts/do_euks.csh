#!/bin/csh

alias nested-pie "mzscheme -r nested-pie.scm"

#nested-pie -m 7 -T "Figure 2a" -P amb euk. > euk7amb.ps ; pstopdf euk7amb.ps
#nested-pie -m 7 -T "Figure 2b" -P elev euk. > euk7elev.ps ; pstopdf euk7elev.ps
#open -a Preview euk7*.pdf

#final verson?
nested-pie -m 7  -P amb euk. > euk8amb.ps ; pstopdf euk8amb.ps
nested-pie -m 7  -P elev euk. > euk8elev.ps ; pstopdf euk8elev.ps
open -a Preview euk8*.pdf
