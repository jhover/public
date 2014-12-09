(load "euk.scm")

(for-each (lambda (x) (write x) (newline))
          (map car (cdr tree))
          )