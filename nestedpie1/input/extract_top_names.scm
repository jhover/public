(load "pv.5.90.scm")

(for-each 
   (lambda (x) (display x) (newline))
   (map car tree)
   ; (map car (cdr (map car tree)))
   )
