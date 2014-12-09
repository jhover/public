; Program:      nested-pie.scm
; Programmer:   Sean R. McCorkle
; Description:  Generates a nested-pie diagram of populations from a control/condition
;               taxonomic file from Dimitris Papamichail
;
; $Id: nested-pie.scm,v 0.5 2006/07/24 18:55:49 mccorkle Exp mccorkle $
;
(require (lib "compat.ss"))
(require (lib "cmdline.ss"))

(load "nested-pie-functions.scm")

(define quant amb-quant)
(define sort-quant amb-quant)

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
(define radial_label_thresh 10)  ; minimum angle for automatic radial labels
(define connect_label_thresh 10) ;   automatic connection labels

                                     ;;;;;;;;;;;
                                     ; Globals ;
                                     ;;;;;;;;;;;

(define title "")
(define show_counts #f)
(define show_percents #f)
(define color_mod_bright_fact 1.0)
(define color_mod_sat_fact 1.0)

(define color-modify
  (lambda (col)
    (adjust-bright (adjust-sat col * color_mod_sat_fact) * color_mod_bright_fact)))
     
; draw a pie slice, covering anything underneath.

(define pie-wedge
  (lambda (node depth start_ang delta_ang col)
    (disp (depth->radius depth) start_ang (+ start_ang delta_ang) 
               (hue col) (sat col) (bright col) "DrawColorSlice")
    ))

(define check-fit-inner-label?
  (lambda (s depth delta_ang)
    (> (/ (* delta_ang 3.14 (depth->radius depth)) 360.0) 
        (str-len-fudge s) )))
; was 1.25

; call check-fit-inner-label? before invoking this

(define inner-wedge-label
  (lambda (s depth start_ang delta_ang col s2)
    (let ( (mid_ang (+ start_ang (* 0.5 delta_ang))) )
      (let ( (intext (or rotational_symmetry 
                         (outer-label? s2 depth)
                         (and (> mid_ang 180) (< mid_ang 360)))) )
        (disp (string-append "(" s ")")
               font_size mid_ang 
               (- (depth->radius depth) (if intext 5 (+ 1 font_size)))
               (if intext "insidecircletext" "outsidecircletext")
               )
        ))))

(define check-fit-radial-label? 
  (lambda (s depth delta_ang)
    (and (> delta_ang radial_label_thresh)
         (> (- (depth->radius depth) (depth->radius (- depth 1)))
            (* 3 (str-len-fudge s)))
         )))
;
; call check-fit-radial-label? before invoking this
;
(define radial-label 
  (lambda (s depth start_ang delta_ang col)
    (let ( (ang (+ start_ang 8.0)) )
      (let ( (orient (or rotational_symmetry (or (<= ang 90) (>= ang 270)))) )
        (let ( (r (- (depth->radius depth) 3)) )
           (disp "% radial label" s "depth" depth "orient is" orient)
           ((if orient  put-rot-string-right
                        put-rot-string)     
                        s (* r (cos (deg->rad ang))) (* r (sin (deg->rad ang)))
                           ;(if orient ang (+ ang 180)) 1.0)
                           (+ ang 180) 1.0)
          )))))

(define big-region? (lambda (depth ang) (>= ang connect_label_thresh)))

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
  (lambda (s lab depth start_ang delta_ang col)
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
                (disp (string-append "(" lab ")")
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
                     put-rot-string-right) lab x2 y2 (rad->deg ang2) 1.0)
                )
          )
        )
      )))
 
(define percent
  (lambda (node) 
    (let ( (p (/ (* 100 (quant node)) total_counts)) )
      (cond ( (> p 10) (round0 p) )
            ( (>= p 1) (round1 p) )
            ( (>= p 0.1) (round1 p) )
            ( (>= p 0.01) (round2 p) )
            ( else     (round3 p) )
            ))))

(define wedge-label
  (lambda (node depth start_ang delta_ang col)
     (let ( (s (tidy-string (to-string (car node)))) )
       (let ( (lab (cond ( show_counts   (string-append s "  " (to-string (quant node))) )
                         ( show_percents (string-append s "  " (to-string (percent node))) )
                         ( else          s)
                         )) )
         (if (not (veto-label? s depth))
             (cond ( (check-fit-inner-label? lab depth delta_ang)
                                 (inner-wedge-label lab depth start_ang delta_ang col s) )
                   ( (check-fit-radial-label? lab depth delta_ang)
                                 (radial-label lab depth start_ang delta_ang col) )
                   ( (or (big-region? depth delta_ang) (show-label? s))
                                 (connection-label s lab depth start_ang delta_ang col) )
                   ))))))


;
; radial-color-func produces a function that alters 
;  the inital color for radial changes
; test 2: modify to include specified saturation  sat + depth * delta_s
;

;(define rcf_delta_b -0.04)
(define rcf_delta_b -0.02) ; -0.02 ;-0.05

(define old-radial-color-func
  (lambda (col)
    (let ( (delta_s 0.0) (delta_b rcf_delta_b) ) ; -0.05
      (lambda ()
        (adjust-sat (adjust-bright col + delta_b) + delta_s))
      )))


(define radial-color-func
  (lambda (col)
    (let ( (b_reduc 0.99) )
      (lambda ()
        (adjust-bright (adjust-bright col * b_reduc) - 0.01))
      )))


(define ccf_delta_h -0.1) ; -0.1  (tried -0.2)
(define ccf_delta_s -0.6) ; -0.6  (tried -0.7)
(define ccf_delta_b 0.1)

(define old-circum-color-func
  (lambda (rad_col i n)
    (let ( (delta_h (* ccf_delta_h (/ (hue rad_col) n)))
           ;(delta_s (* -0.6 (/ (sat rad_col) n)))
           (delta_s -0.07) ; -0.07 (tried -0.20)
           (delta_b (* 0.1 (/ (bright rad_col) n)))  ; 0.1 (tried 0.2)
           (k (- n i))
           )
      (let ( (base_col (adjust-hsb rad_col + 0 + (* -1 delta_s) + (* -1 delta_b)) ) )
        (radial-color-func 
             (adjust-hsb base_col + (* k delta_h) + (* k delta_s) + (* k delta_b)))
        ))))


(define circum-color-func
  (lambda (rad_col i n)
    (let ( (colv (make-vector 2))
           ;(delta_h (* ccf_delta_h (/ (hue rad_col) n)))
           (delta_h 0)
           (delta_s -0.2) ; -0.07 (tried -0.20)
           (delta_b (* 0.15 (/ (bright rad_col) n)))  ; 0.1 (tried 0.2) 0.1 for niels test1
           (k (- n i)) )
      (let (  ;(base_col rad_col)
              (base_col (adjust-hsb rad_col + 0 + (* -1 delta_s) + (* -2 delta_b)))
              )
         (vector-set! colv 0 (adjust-hsb base_col + (* 1 delta_h)
                                               + (* 1 delta_s) + (* 1 delta_b)))
         (vector-set! colv 1 (adjust-hsb base_col + (* 2.5 delta_h)
                                               + (* 2.5 delta_s) + (* 2.5 delta_b)))
         (radial-color-func (vector-ref colv (modulo k 2)))
        ))))
      
   
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



(define pie-sort
  (lambda (a b) (> (hash-table-get order (caar a) (lambda () (sort-quant (car a))))
                   (hash-table-get order (caar b) (lambda () (sort-quant (car b)))) )
    ))

(define rend-pie
  (lambda (tr_raw depth start_ang stop_ang parent_col)
    (if (and (not (null? tr_raw)) (< depth max_annuli))
        (let ( (tr (sort pie-sort tr_raw)) )
          (let ( (qs (map quant (map car tr))) )
            (let ( (ang_range (if (= (sum qs) 0)
                                  0
                                  (/ (- stop_ang start_ang) (sum qs) )
                                  )) )
              (let ( (d_angs (map (lambda (q) (* ang_range q)) qs)) )
                (for-each (lambda (t start delta_ang colf)
                             (rend-pie (cdr t) (+ depth 1) start (+ start delta_ang)
                                       ((radial-color-func (colf))))
                             (pie-wedge (car t) depth start delta_ang (colf))
                            )
                          tr
                          (calc-starts start_ang d_angs)
                          d_angs
                          (make-color-funcs parent_col tr)
                          )
                )))))))


(define rend-labels
  (lambda (tr_raw depth start_ang stop_ang parent_col)
    (if (and (not (null? tr_raw)) (< depth max_annuli))
        (let ( (tr (sort pie-sort tr_raw)) )
          (let ( (qs (map quant (map car tr))) )
            (let ( (ang_range (if (= (sum qs) 0)
                                  0
                                  (/ (- stop_ang start_ang) (sum qs) )
                                  )) )
              (let ( (d_angs (map (lambda (q) (* ang_range q)) qs)) )
                (for-each (lambda (t start delta_ang colf)
                             (rend-labels (cdr t) (+ depth 1) start (+ start delta_ang)
                                       ((radial-color-func (colf))))
                             (wedge-label (car t) depth start delta_ang (colf))
                            )
                          tr
                          (calc-starts start_ang d_angs)
                          d_angs
                          (make-color-funcs parent_col tr)
                          )
                )))))))

;
; (render tree)  - starts the ball rolling for the inner (full) circle
;
(define render
  (lambda (tr)
    (rend-pie   (cdr tr) 0 0 360.0 #f)
    (rend-labels (cdr tr) 0 0 360.0 #f)
    ))


                                 ;;;;;;;;;;;;;;;;
                                 ; Main Program ;
                                 ;;;;;;;;;;;;;;;;

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
                 (("-c" "--connect-label-thresh") rlt "Minimum angle for connected labels"
                         (set! connect_label_thresh (string->number rlt)))
                 )
              (once-any
                 (("-S" "--show-counts") "Show total counts in labels"
                         (set! show_counts #t))
                 (("-P" "--show-percents") "Show percentages in labels"
                         (set! show_percents #t))
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

;(disp "pref" pref)
(load data_filename)
(load color_filename)

(update-parameters)

(define total_counts (sum (map quant (map car (cdr tree)))))

; make the HSB hash table 
(define hsb_vals (make-hash-table 'equal))
(define order   (make-hash-table 'equal))

(for-each
   (lambda (r)
     (hash-table-put! order    (car r) (- (cadr r)))
     (hash-table-put! hsb_vals (car r) (color-modify (cddr r)))
     )
   top_hsb_vals
   )



(preamble title "nested-pie.scm")
(page-preamble 1)
(set-landscape)
(set-font "Helvetica" (* 1.0 font_size))
;(put-string-center title 0  (* 1.3 outer_rad) 1.0)
(put-string title 50 710 1.0)

(disp (+ 305 x_offset) (+ 400 y_offset) "translate")
(disp 0.2 "setlinewidth")
(set-font "Helvetica" font_size)
(render tree)
(postamble 1)
