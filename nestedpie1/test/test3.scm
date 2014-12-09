(require (lib "compat.ss"))

(load "graf.scm")
(load "pv.5.90.scm")
(load "pv.hsb.table.scm")


; functions to extract one of the numberic quantities of the 
; tree nodes

(define amb-quant
   (lambda (r) (list-ref r 1) ) )

(define elev-quant
   (lambda (r) (list-ref r 2) ) )

(define delta-quant
   (lambda (r) (- (list-ref r 2) (list-ref r 1))))

(define quant amb-quant)  ; takes one of the above values

; (sum  l) - sum a list of numbers  (abs applied to each number for delta-quant)

(define sum
  (lambda (l)
    (apply + (map abs l))))

; (calc-starts '(5 10 17 2 100 1)) ->  (0 5 15 32 34 134)

(define calc-starts
  (lambda (off lst)
    (letrec ((gs (lambda (l resl sum)
                   (if (null? l)
                       (reverse resl)
                       (gs (cdr l ) (cons sum resl) (+ sum (car l)) )
                       )))
          )
      (gs lst '() off)
      )))

;
;(map quant (map car(cdr tree)))
;(sum (map quant (map car(cdr tree))))
;
(define indent
  (lambda (depth)
    (if (> depth 0)
        (begin (display "    ")
               (indent (- depth 1))
               )
        )))

; to-string converts symbols, numbers and () to string, and
; recursively applies to lists of such. 

(define to-string
  (lambda (x)
    (string-append "("
                    (cond ( (null? x) "" )
                          ( (string? x) x )
                          ( (symbol? x) (symbol->string x) )
                          ( (number? x) (number->string x) )
                          ( (list? x)   (apply string-append (map to-string x)) )
                          ( else (error x) )
                          )
                    ")")))
                         

(define pie-wedge
  (lambda (node depth start_ang delta_ang col)
    (let ( (h (list-ref col 0))
           (s (list-ref col 1))
           (b (list-ref col 2))
           )
      (display "% ")
      (indent depth)
     (display delta_ang) (display " ")
                      (display node) (newline)
     (let ( (rad (* 57 (+ depth 1))) )
         (disp rad start_ang (+ start_ang delta_ang) h s b "DrawColorSlice")
         (if (> delta_ang 10)
             (disp (to-string (car node))
                   5 (+ start_ang (* 0.5 delta_ang)) (- rad 5)
                       "insidecircletext")
            )
        ))))


(define make-colors
  (lambda (incol tr)
    (if incol
        (let ( (h (car incol))
               ;(b (* 1.5 (caddr incol)))
               (b (/ (caddr incol) 1.5))
               (delta_s (* (/ (cadr incol) (length tr))  0.8))
               (delta_b (* (/ (caddr incol) (length tr)) 0.8))  ;0.7 is goo
               (delta_h 0.1)
               )
          ;(disp "% incol h b delta length" h b delta (length tr) )
          (let modc ( (n (length tr))
                      (hue    h)
                      (sat    (+ 0.2 delta_s))
                      (bright b)
                      (hsbsofar '())
                      )
            ;(disp "%  modc n sat sofar" n sat hsbsofar)
            (if (<= n 0)
                (reverse hsbsofar)
                (modc (- n 1) 
                      (if (< (- h delta_h) 0) (- (+ h 1.0) delta_h) (- h delta_h))
                      (+ sat delta_s) (- bright delta_b)
                      (cons (list h sat bright) hsbsofar))
                )))
        (map (lambda (r)
               (disp "% make-colors" (car r))
               (let ( (hsb (hash-table-get hsb_vals (car r))) )
                 (list (car hsb) (cadr hsb) (* (expt 1.5 4) caddr hsb))
                 )
               )
             (map car tr)
             ))))



(define rend
  (lambda (tr_raw depth start_ang stop_ang incol)
    (if (and (not (null? tr_raw)) (< depth 5))
        (let ( (tr 
                (sort ;(lambda (a b) (< (quant (car a)) (quant (car b))))
                      (lambda (a b) (< (hash-table-get order (caar a)
                                                     (lambda () (quant (car a))))
                                       (hash-table-get order (caar b)
                                                     (lambda () (quant (car b))))
                                       ))
                      tr_raw)
                ) )
          (let ( (qs (map quant (map car tr))) )
            ; (display (list "car tr" (map car tr))) (display (list "qs " qs)) (newline)
            (let ( (ang_range (if (= (sum qs) 0)
                                  0
                                  (/ (- stop_ang start_ang) (sum qs) )
                                  )) )
              (let ( (d_angs (map (lambda (q) (* ang_range q)) qs)) )
                ;(display "Ang range ") (display ang_range) (newline)
                (for-each (lambda (t start delta_ang col)
                             (rend (cdr t) (+ depth 1) start (+ start delta_ang) col)
                             (pie-wedge (car t) depth start delta_ang col)
                            )
                          tr
                          (calc-starts start_ang d_angs)
                          d_angs
                          (make-colors incol tr)
                          )
                )))))))

; (render tree)  - starts the ball rolling for the inner (full) circle
;
(define render
  (lambda (tr) (rend (cdr tr) 0 0 360.0 #f) ))

; make the HSB hash table 
(define hsb_vals (make-hash-table 'equal))
(define order   (make-hash-table 'equal))

(for-each
   (lambda (r)
     (hash-table-put! order    (car r) (- (cadr r)))
     (hash-table-put! hsb_vals (car r) (cddr r))
     )
   top_hsb_vals
   )

;(hash-table-get hsb_vals "Acidobacteria")
;(hash-table-get hsb_vals "Verrucomicrobia")


(preamble "tree" "test1.scm")
(page-preamble 1)
(disp 305 400 "translate")
(set-font "Helvetica-Bold" 5)
(render tree)
(postamble 1)
