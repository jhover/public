; Module:       nested-pie-functions.scm
; Programmer:   Sean R. McCorkle
; Description:  most functions for nested-pie.scm
;
; $Id: nested-pie-functions.scm,v 0.5 2006/07/24 19:02:16 mccorkle Exp mccorkle $
;

(load "graf.scm")

; constants

(define pi 3.141592653)
(define annulus_radius 45)  ; 57 45
(define max_annuli 5)
(define outer_rad (* max_annuli annulus_radius))

(define update-parameters
  (lambda ()
    (set! outer_rad (* max_annuli annulus_radius))
    ))

; depth->radius returns OUTER radius of annulus for depth.
;        depth 0 is first depth - if depth < 0, 0 is returned

(define linear-depth->radius
  (lambda (depth)
    (if (< depth 0)
        0
        (* annulus_radius (+ depth 1))
        )))

(define eq-area-depth->radius
  (lambda (depth)
    (if (< depth 0)
        0
        (let ( (r1 (/ outer_rad (sqrt max_annuli))) )
          (* r1 (sqrt (+ depth 1)))
          )
        )))

(define depth->radius eq-area-depth->radius)

; some string functions

(define str-end-match?
  (lambda (big_s end_s)
    (let ( (blen (string-length big_s))
           (elen (string-length end_s)) )
      (if (>= blen elen)
          (string-ci=? (substring big_s (- blen elen) blen) end_s)
          #f
          ))))

(define str-remove-match
  (lambda (big_s end_s)
    (if (str-end-match? big_s end_s)
        (substring big_s 0 (- (string-length big_s) (string-length end_s)) )
        big_s
        )))


(define str-len-fudge
  (lambda (s) (* 1.45 (/ font_size 5) (string-length s))))

(define tidy-string
  (lambda (s)
    (regexp-replace* "_" s " ")))

; functions to extract one of the numberic quantities of the 
; tree nodes

(define amb-quant
   (lambda (r) (list-ref r 1) ) )

(define elev-quant
   (lambda (r) (list-ref r 2) ) )

(define delta-quant
   (lambda (r) (- (list-ref r 2) (list-ref r 1))))

(define quant elev-quant)  ; takes one of the above values

;
;  Yes yes I know -this is stupid, but I'm in a hurry
;
(define round3
  (lambda (x)
    (exact->inexact (/ (inexact->exact (round (* 1000 x))) 1000))))

(define round2
  (lambda (x)
    (exact->inexact (/ (inexact->exact (round (* 100 x))) 100))))

(define round1
  (lambda (x)
    (exact->inexact (/ (inexact->exact (round (* 10 x))) 10))))

(define round0
  (lambda (x)
    (inexact->exact (round x))))

(define hue    (lambda (hsb) (car hsb)))
(define sat    (lambda (hsb) (cadr hsb)))
(define bright (lambda (hsb) (caddr hsb)))

;  
;(define adjust-hue hsb op amount)  (adjust-hue hsb - 0.2)
;  hue always ends up in [0.0-1.0] interval via circular wrap-around
;
(define adjust-hue
  (lambda (hsb op amount)
    (let ( (newh (op (car hsb) amount)) )
      (list (round3 (if (or (< newh 0) (> newh 1))
                        (- newh (floor newh))
                        newh))
            (cadr hsb)
            (caddr hsb))
      )))


;(define adjust-sat hsb op amount)  (adjust-sat sat - 0.2)
;  resultant values below 0 and above 1 are converted to 0 and 1

(define adjust-sat
  (lambda (hsb op amount)
    (let ( (news (round3 (op (cadr hsb) amount))) )
      (list (car hsb)
            (cond ( (> news 1.0) 1.0 )
                  ( (< news 0.0) 0.0 )
                  ( else news ) )
            (caddr hsb))
      )))

;(define adjust-bright hsb op amount)  (adjust-sat b - 0.2)
;  resultant values below 0 and above 1 are converted to 0 and 1

(define adjust-bright
  (lambda (hsb op amount)
    (let ( (newb (round3 (op (caddr hsb) amount))) )
      (list (car hsb)
            (cadr hsb)
            (cond ( (> newb 1.0) 1.0 )
                  ( (< newb 0.0) 0.0 )
                  ( else newb ) )
            )
      )))

(define adjust-hsb
  (lambda (hsb h_op h_amount s_op s_amount b_op b_amount)
    (adjust-bright 
     (adjust-sat 
      (adjust-hue hsb h_op h_amount) s_op s_amount) b_op b_amount)))
          
(define veto_labels_tab (make-hash-table 'equal))

(define veto-label
  (lambda (name depth)
    (hash-table-put! veto_labels_tab name depth)))

(define veto-label?
  (lambda (name depth)
    (>= depth (hash-table-get veto_labels_tab name (lambda () 1000000)))))



(define show_labels_tab (make-hash-table 'equal))

(define show-label 
  (lambda (name)
    (hash-table-put! show_labels_tab name #t)))

(define show-label? 
  (lambda (name)
    (hash-table-get show_labels_tab name (lambda () #f))))



(define c_label_offsets_tab (make-hash-table 'equal))

(define set-clabel-offsets
  (lambda (name offs)
    (hash-table-put! c_label_offsets_tab name offs)))

(define clabel-offsets
  (lambda (name)
    (hash-table-get c_label_offsets_tab name (lambda () '(0 0)))))

(define clabel-r-offset
  (lambda (name)
    (car (clabel-offsets name))))

(define clabel-ang-offset
  (lambda (name)
    (cadr (clabel-offsets name))))

(define c_conn_offsets_tab (make-hash-table 'equal))

(define set-conn-offsets
  (lambda (name offs)
    (hash-table-put! c_conn_offsets_tab name offs)))

(define conn-offsets
  (lambda (name)
    (hash-table-get c_conn_offsets_tab name (lambda () '(0 0)))))

(define set-c-offsets
  (lambda (name lab_off conn_off)
    (set-clabel-offsets name lab_off)
    (set-conn-offsets name conn_off)
    ))


(define outer_labels_tab (make-hash-table 'equal))

(define outer-label
  (lambda (name depth)
    (hash-table-put! outer_labels_tab name depth)))

(define outer-label?
  (lambda (name depth)
    (>= depth (hash-table-get outer_labels_tab name (lambda () 1000000)))))


                      ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                      ; miscellaneous low-level stuff ;
                      ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; (sum  l) - sum a list of numbers  (abs applied to each number for delta-quant)

(define sum (lambda (l) (apply + (map abs l))))

; calc-starts takes an offset angle and a list of delta angles for
;   pie wedges, and produces a list of start angles for the wedges
;
; (calc-starts 100 '(5 10 17 2 100)) ->  (0 5 15 32 34 134)

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

; to-string converts symbols, numbers and () to string, and
; recursively applies to lists of such. 

(define to-string
  (lambda (x)
    (cond ( (null? x) "" )
          ( (string? x) x )
          ( (symbol? x) (symbol->string x) )
          ( (number? x) (number->string x) )
          ( (list? x)   (apply string-append (map to-string x)) )
          ( else (error x) )
          )
    ))

(define deg->rad  (lambda (deg) (/ (* pi deg) 180.0)))
(define rad->deg  (lambda (rad) (/ (* 180.0 rad) pi)))

   