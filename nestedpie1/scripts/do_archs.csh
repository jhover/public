#!/bin/csh

alias nested-pie "mzscheme -r nested-pie.scm"

set root="edited_archea"
set ambname="$root.amb"
set elevname="$root.elev"
set common_opts="-a lin -f 12 -m 3"


nested-pie $common_opts -T "Figure 3a" -P amb $root. > $ambname.ps 
pstopdf $ambname.ps
nested-pie $common_opts -T "Figure 3b" -P elev $root. > $elevname.ps 
pstopdf $elevname.ps

open -a Preview $ambname.pdf $elevname.pdf
