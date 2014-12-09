(load "~/lib/io.zo")
                
(load "18s.elev.scm")
(load "18s.amb.scm")
 
(define make-node
  (lambda (name)
    (list (list name 0 0 0.0))))

(define tree (make-node "root"))

(define tmember 
  (lambda (tname tlst)
    (if (null? tlst)
        #f
        (if (equal? tname (caaar tlst))
            (car tlst)
            (tmember tname (cdr tlst))
            )
        )))
      
(define find-or-make-child
  (lambda (tname tr)
    (let ( (subl (tmember tname (cdr tr))) )
      (if subl
          subl
          (begin
            ;(disp "@ adding" tname)
            (set-cdr! tr (cons (make-node tname) (cdr tr)))
            (cadr tr)
            )
          ))))

;
; field is 'amb or 'elev
;
(define set-field!
  (lambda (r field count)
    (cond ( (eq? field 'amb)  (set-cdr! r (cons count (cddr r))) )
          ( (eq? field 'elev) (set-cdr! (cdr r) (cons count (cdddr r))) )
          )))

(define get-field
  (lambda (r field)
    (cond ( (eq? field 'amb) (cadr r) )
          ( (eq? field 'elev) (caddr r) )
          )))
                               
(define enter-tax
  (lambda (field count tr taxlst)
    (let ( (ch (find-or-make-child (car taxlst) tr)) )
      (if (null? (cdr taxlst))
          (set-field! (car ch) field count)
          (enter-tax field count ch (cdr taxlst))
          ))))
               
(define enter-all
  (lambda (field recs)
    (for-each (lambda (r) 
                (let ( (count (car r)) (gb (cadr r)) (taxlst  (caddr r)) )
                  ;(display "@@@") (display count) (write taxlst) (newline)
                  (enter-tax field count tree taxlst)
                  ))
               recs)
    ))

; (sum  l) - sum a list of numbers  

(define sum (lambda (l) (apply + l)))

;(sum-field field tree)

(define sum-field 
  (lambda (field tr)
    (if (not (null? (cdr tr)))
        (begin        
          (for-each (lambda (ch) (sum-field field ch))
                    (cdr tr)
                    )
          (if (not (= 0 (get-field (car tr) field)))
              (begin
                (disp "*** error non zero parent" field (car tr))
                ))
          ;(disp "@ set field" (car tr))
          (set-field! (car tr) field 
                      (sum (map (lambda (n) (get-field (car n) field))
                                (cdr tr))
                           )
                      )
          ))))



 ;;;;;;;;
 ; Main ;
 ;;;;;;;;

(enter-all 'amb amb_recs)
(enter-all 'elev elev_recs)

(sum-field 'amb tree)
(sum-field 'elev tree)
(write tree) (newline)

;(define t1 '(("root" 0 0) (("fred" 0 0) (("mary" 0 0)) (("alice" 0 0)))
;             (("maple" 0 0)) ))

;(find-or-make-child "fred" t1)
;(enter-tax 'amb 15 t1 '("fred" "alice"))
;(enter-tax 'elev 15 t1 '("fred" "mary"))
;(enter-tax 'elev 23 t1 '("fred" "mary" "jane"))
;t1
;(define t2 (find-or-make-child "fred" t1))
;(define m (find-or-make-child "mary" t2))

