; Program:      rectangular.scm
; Programmer:   Sean R. McCorkle
; Description:  Generates a rectangular diagram of populations from a
;               control/condition taxonomic file from Dimitris Papamichail
;
; $Id: nested-pie.scm,v 0.4 2006/07/18 16:51:53 mccorkle Exp mccorkle $
;
(require (lib "compat.ss"))
(require (lib "cmdline.ss"))

(load "rectangular-functions.scm")

(define quant amb-quant)
;(define pref "pv.5.90")
;(define pref "euk")
;(define pref "archea")
(define pref "" )
(define data_filename "")
(define color_filename "")

                                    ;;;;;;;;;;;;;
                                    ; Constants ;
                                    ;;;;;;;;;;;;;

(define font_size 7)
(define rotational_symmetry #f)
(define circular_outer_labels #f)
(define x_offset 0)
(define y_offset 0)
                                     ;;;;;;;;;;;
                                     ; Globals ;
                                     ;;;;;;;;;;;

(define title "")



(define rectangle
  (lambda (node depth start_y delta_y col)
    (disp (hue col) (sat col) (bright col) "sethsbcolor")
    (disp (round3 (depth->x (- depth 1)))
          (round3 (depth->x depth))
          (round3 start_y)
          (round3 (+ start_y delta_y))
          "FilledRectangle")
    ))


(define check-fit-inner-label?
  (lambda (s depth delta_y)
    (> delta_y (str-len-fudge s) )))

; was 1.25

; call check-fit-inner-label? before invoking this

(define inner-rect-label
  (lambda (s depth start_y delta_y col)
    (put-string-vert-center s (round3 (depth->x (- depth 0.5)))
                              (round3 (+ start_y (* 0.5 delta_y)))
                              1.0)
    ))

(define check-fit-radial-label? 
  (lambda (s depth delta_ang)
    (and (> delta_ang 10)
         (> (- (depth->radius depth) (depth->radius (- depth 1)))
            (* 3 (str-len-fudge s)))
         )))
     
; call check-fit-radial-label? before invoking this

(define radial-label 
  (lambda (s depth start_ang delta_ang col)
    (let ( (r (- (depth->radius depth) 3))
           (ang (+ start_ang 5.0)) )
      (put-rot-string-right s (* r (cos (deg->rad ang))) (* r (sin (deg->rad ang)))
                            ang 1.0)
      )))

(define big-region? (lambda (depth ang) (>= ang 10)))

(define calc-conn-rad
  (lambda (s depth)
    (let ( (r  (/ (+ (depth->radius (- depth 1)) (depth->radius depth)) 2))
           (cc (conn-offsets s)) )
      (if (eq? cc 'cent)
          r
          (+ r (car cc))
          ))))

; this returns angle in rad

(define calc-conn-ang
  (lambda (s depth start_ang delta_ang)
    (let ( (cc (conn-offsets s)) )
      (deg->rad 
          (+ start_ang (if (eq? cc 'cent)
                           (/ delta_ang 2)
                           (+ (* (+ depth 1) (/ delta_ang (+ max_annuli 1)))
                              (cadr cc))
                           )))
      )))
             
    
(define connection-label
  (lambda (s depth start_ang delta_ang col)
    (let ( (r  (calc-conn-rad s depth))
           (r2 (+ (* 1.05 outer_rad) (clabel-r-offset s)))
           (c_ang (deg->rad (+ start_ang (/ delta_ang 2))))
           (ang (calc-conn-ang s depth start_ang delta_ang))
           )
      (let ( (ang2 (+ (* 1.5 (- ang c_ang)) c_ang 
                      (deg->rad (clabel-ang-offset s)) )) )
        (let ( (x1 (* r (cos ang)))  (y1 (* r (sin ang)))
               (x2 (* r2 (cos ang2)))  (y2 (* r2 (sin ang2))) )
            (put-circle x1 y1 1 1.0 'filled)
            (put-line  x1 y1 x2 y2 1.0)
            (if circular_outer_labels
                (disp (string-append "(" s ")")
                      font_size (rad->deg ang2) 
                      r2
                      ;(- (depth->radius depth) (if intext 5 (+ 1 font_size)))

                      (if (or rotational_symmetry 
                              (and (> ang2 pi) (< ang2 (* 2 pi))))
                          "leftinsidecircletext" "leftoutsidecircletext")
                     )
                ((if (or rotational_symmetry 
                         (or (<= ang2 (/ pi 2)) (>= ang2 (* 3 (/ pi 2)))))
                     put-rot-string 
                     put-rot-string-right) s x2 y2 (rad->deg ang2) 1.0)
                )
          )
        )
      )))
     
(define rect-label
  (lambda (node depth start_y delta_y col)
     (let ( (s (to-string (car node))) )
       (if (not (veto-label? s depth))
           (cond ( (check-fit-inner-label? s depth delta_y)
                               (inner-rect-label s depth start_y delta_y col) )
                 ;( (check-fit-radial-label? s depth delta_ang)
                 ;             (radial-label s depth start_ang delta_ang col) )
                 ;( (or (big-region? depth delta_ang) (show-label? s))
                 ;              (connection-label s depth start_ang delta_ang col) )
                 )))))


;
; radial-color-func produces a function that alters 
;  the inital color for radial changes
; test 2: modify to include specified saturation  sat + depth * delta_s
;

;(define rcf_delta_b -0.04)
(define rcf_delta_b -0.05)

(define radial-color-func
  (lambda (col)
    (let ( (delta_s 0.0) (delta_b rcf_delta_b) ) ; -0.05
      (lambda ()
        (adjust-sat (adjust-bright col + delta_b) + delta_s))
      )))


(define ccf_delta_h -0.1)
(define ccf_delta_s -0.7) ; -0.6
(define ccf_delta_b 0.1)

(define circum-color-func
  (lambda (rad_col i n)
    (let ( (delta_h (* ccf_delta_h (/ (hue rad_col) n)))
           ;(delta_s (* -0.6 (/ (sat rad_col) n)))
           (delta_s -0.07)
           (delta_b (* 0.1 (/ (bright rad_col) n)))
           (k (- n i))
           )
      (radial-color-func (adjust-bright 
                           (adjust-sat 
                            (adjust-hue rad_col + (* k delta_h)) 
                                                 + (* k delta_s))
                                                  + (* k delta_b)))
      )))



; (make-color-funcs parent_col tr) - produces a list of circumfertial colors
;   (hsb hsb hsb ...) for the current level in tr, starting from the 
;   parent_col  (hsb)

(define make-color-funcs
  (lambda (radial_col tr)
    (if radial_col
        (let ( (n (length tr)) )
          (let modc ( (i n) (colfs '()) 
                      )
            (if (<= i 0)
                (reverse colfs)
                (modc (- i 1) 
                      (cons (circum-color-func radial_col i n) colfs))
                )))
        (map (lambda (r)
               (radial-color-func (hash-table-get hsb_vals (car r)))
               )
             (map car tr)
             ))))



(define rect-sort
  (lambda (a b) (> (hash-table-get order (caar a) (lambda () (quant (car a))))
                   (hash-table-get order (caar b) (lambda () (quant (car b)))) )
    ))

(define rend-rect
  (lambda (tr_raw depth start_y stop_y parent_col)
    (if (and (not (null? tr_raw)) (< depth max_bars))
        (let ( (tr (sort rect-sort tr_raw)) )
          (let ( (qs (map quant (map car tr))) )
            (let ( (y_range (if (= (sum qs) 0)
                                0
                                (/ (- stop_y start_y) (sum qs) )
                                )) )
              (let ( (delta_ys (map (lambda (q) (* y_range q)) qs)) )
                (for-each (lambda (t start delta_y colf)
                             (rend-rect (cdr t) (+ depth 1) start (+ start delta_y)
                                       ((radial-color-func (colf))))
                             (rectangle (car t) depth start delta_y (colf))
                            )
                          tr
                          (calc-starts start_y delta_ys)
                          delta_ys
                          (make-color-funcs parent_col tr)
                          )
                )))))))


(define rend-labels
  (lambda (tr_raw depth start_y stop_y parent_col)
    (if (and (not (null? tr_raw)) (< depth max_bars))
        (let ( (tr (sort rect-sort tr_raw)) )
          (let ( (qs (map quant (map car tr))) )
            (let ( (y_range (if (= (sum qs) 0)
                                  0
                                  (/ (- stop_y start_y) (sum qs) )
                                  )) )
              (let ( (delta_ys (map (lambda (q) (* y_range q)) qs)) )
                (for-each (lambda (t start delta_y colf)
                             (rend-labels (cdr t) (+ depth 1) start (+ start delta_y)
                                       ((radial-color-func (colf))))
                             (rect-label (car t) depth start delta_y (colf))
                            )
                          tr
                          (calc-starts start_y delta_ys)
                          delta_ys
                          (make-color-funcs parent_col tr)
                          )
                )))))))

;
; (render tree)  - starts the ball rolling for the inner (full) circle
;
(define render
  (lambda (tr)
    (rend-rect   (cdr tr) 0 min_y max_y #f)
    (rend-labels (cdr tr) 0 min_y max_y #f)
    ))


                                 ;;;;;;;;;;;;;;;;
                                 ; Main Program ;
                                 ;;;;;;;;;;;;;;;;

(if (= 1 0)
    (begin
;
; Parse command line arguments and options, and set appropriate global values
;
(command-line "nested-pie" (current-command-line-arguments)
              (once-each
                 (("-T" "--title") t "plot title" (set! title t))
                 (("-a" "--annulus-spacing") a "annulus spacing"
                         (cond ( (or (string-ci=? a "lin") (string-ci=? a "linear"))
                                      (set! depth->radius linear-depth->radius) )
                               ( (string-ci=? a "eq-area")
                                      (set! depth->radius eq-area-depth->radius) )
                               ( else (error (string-append "bad -a arg: "
                                                       a "; must be lin or eq-area")))
                               ))
                 (("-f" "--font-size") fs "font size" 
                         (set! font_size (string->number fs)))
                 (("-r" "--annulus-radius") r "average annulus radius"
                         (set! annulus_radius (string->number r)))
                 (("-m" "--max-depth") m "maximum phylogentic depth to show"
                         (set! max_annuli (string->number m)))
                 (("-X" "--x-offset") x "X offset of center"
                         (set! x_offset (string->number x)))
                 (("-Y" "--y-offset") y "Y offset of center"
                         (set! y_offset (string->number y)))
                 (("-C" "--circular_outer_labels") "Circumferential outer labels"
                         (set! circular_outer_labels #t))
                 (("-R" "--rotational-symmetry")  "Rotationally symmetric labels"
                         (set! rotational_symmetry #t))
                 )
                (args (sample fname) 
                         (cond ( (string-ci=? sample "amb") (set! quant amb-quant) )
                               ( (string-ci=? sample "elev") (set! quant elev-quant) )
                               ( else (error (string-append "bad sample val: "
                                                   sample "; must be amb or elev" ))) 
                               )
                         (set! pref (cond ( (str-end-match? fname ".scm")
                                               (str-remove-match fname ".scm") )
                                          ( (str-end-match? fname ".")
                                               (str-remove-match fname ".") )
                                          ( else fname ) ))
                         (set! data_filename (string-append pref ".scm"))
                         (set! color_filename (string-append pref ".hsb.table.scm"))
                         )
                )

))
(set! pref "pv.5.90")
(set! data_filename (string-append pref ".scm"))
(set! color_filename (string-append pref ".hsb.table.scm"))

 
;(disp "pref" pref)
(load data_filename)
(load color_filename)

(update-parameters)

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



(preamble title "nested-pie.scm")
(page-preamble 1)
(disp  x_offset y_offset "translate")
(disp 0.2 "setlinewidth")
(set-font "Helvetica" font_size)
(render tree)
(set-font "Helvetica" (* 2.5 font_size))
;(put-string-center title 0  (* 1.3 outer_rad) 1.0)
(postamble 1)
