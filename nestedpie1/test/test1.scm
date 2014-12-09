(load "graf.scm")
(load "pv.5.90.scm")

; functions to extract one of the numberic quantities of the 
; tree nodes

(define amb-quant
   (lambda (r) (list-ref r 1) ) )

(define elev-quant
   (lambda (r) (list-ref r 2) ) )

(define delta-quant
   (lambda (r) (- (list-ref r 2) (list-ref r 1))))

(define quant elev-quant)  ; takes one of the above values

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
                          ( (string? x) x)
                          ( (symbol? x) (symbol->string x) )
                          ( (number? x) (number->string x) )
                          ( (list? x)   (apply string-append (map to-string x)) )
                          ( else (error x) )
                          )
                    ")")))
                         

(define pie-wedge
  (lambda (node depth start_ang delta_ang)
    (display "% ")
    (indent depth)
    (display delta_ang) (display " ")
                    (display node) (newline)
    (let ( (rad (* 57 (+ depth 1))) )
       (disp rad start_ang (+ start_ang delta_ang) 0.7 "DrawSlice")
       (if (> delta_ang 10)
           (disp (to-string (car node))
                  5 (+ start_ang (* 0.5 delta_ang)) (- rad 5)
                      "insidecircletext")
           )
      )))


(define rend
  (lambda (tr depth start_ang stop_ang)
    (if (and (not (null? tr)) (< depth 5))
        (let ( (qs (map quant (map car tr))) )
          ; (display (list "car tr" (map car tr))) (display (list "qs " qs)) (newline)
          (let ( (ang_range (if (= (sum qs) 0)
                                0
                                (/ (- stop_ang start_ang) (sum qs) )
                                )) )
            (let ( (d_angs (map (lambda (q) (* ang_range q)) qs)) )
              ;(display "Ang range ") (display ang_range) (newline)
              (for-each (lambda (t start delta_ang)
                           (rend (cdr t) (+ depth 1) start (+ start delta_ang))
                           (pie-wedge (car t) depth start delta_ang)
                          )
                        tr
                        (calc-starts start_ang d_angs)
                        d_angs
                        )
              ))))))

; (render tree)  - starts the ball rolling for the inner (full) circle
;
(define render
  (lambda (tr) (rend (cdr tr) 0 0 360.0) ))


(preamble "tree" "test1.scm")
(page-preamble 1)
(disp 305 400 "translate")
(set-font "Helvetica-Bold" 5)
(render tree)
(postamble 1)
