; Usage:  mzscheme -r phylo-counter.scm   <file> ...
;
; feed this records of tab-separated phylogentic identifications, al la
;
;    Archaea Cenarchaea_Cren Cenarchaeales   SAGMA-X SAGMA-D NRP-P   otu_23
;    Archaea Cenarchaea_Cren Unclassified    otu_14
;    Archaea Cenarchaea_Cren Cenarchaeales   SAGMA-X SAGMA-D NRP-P   otu_23
;    Archaea Cenarchaea_Cren Unclassified    otu_14
;
(load "~/lib/io.scm")
(load "stringutils.scm")

(define tree '( (root 0 0 0) ) )


(define find-or-enter
  (lambda (tr x)
    (let ( (c (let find ( (chs (cdr tr)) )  ; find returns the child node
                (if (null? chs)            ; which matches x or #f if not found
                    #f
                    (if (equal? x (caaar chs))
                        (car chs)
                        (find (cdr chs))
                        )))) )
      ; if found, simply return it, else enter and then return it
      (if c
          c
          (let ( (new (cons (list (list x 0 0 0)) (cdr tr) )) )
            (set-cdr! tr new)
            (car new)))
      )))

(define position 1)

(define increment-node
  (lambda (node pos)
    (cond ( (= pos 1) (set-cdr! node (cons (+ (cadr node) 1) (cddr node))) )
          ( (= pos 2) (set-cdr! (cdr node) (cons (+ (caddr node) 1) (cdddr node))) )
          )))
      
    
(define accumulate
  (lambda (tr taxonomy)
    (if (not (null? taxonomy))
        (let ( (c (find-or-enter tr (car taxonomy))) )
          (increment-node (car c) position)
          (accumulate c (cdr taxonomy))
          ))))

(define indent
  (lambda (n)
    (if (> n 0)
        (begin
          (display "    ")
          (indent (- n 1))
          ))))

(define print-tree
  (lambda (tree)
    (display "(define tree") (newline) (display "'")
    (let prt ( (depth 0) (tr tree) )
      (indent depth)  (display "( ") (write (car tr)) (newline)
      (for-each (lambda (t) (prt (+ depth 1) t))
                (cdr tr)
                )
      (indent depth) (display ")") (newline)
      )
    (display ")") (newline)
    ))

;
; main program
;
; (vector->list (current-command-line-arguments))


(define position 0)
(for-each 
         (lambda (filename)
           (let ( (f (open-input-file filename)) )
             (set! position (+ position 1))
             (let pl ( (line (getline f)) )
               (if (not (eof-object? line))
                 (let ( (taxonomy (split-words line '(#\space #\tab #\newline))) )
                   ;(disp taxonomy)
                   (accumulate tree taxonomy)
                   (pl (getline f))
                   )
                 ))
             (close-input-port f)
             )
           )
         (vector->list (current-command-line-arguments))
         )


(print-tree tree)