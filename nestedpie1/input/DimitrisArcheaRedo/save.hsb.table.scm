(define top_hsb_vals 
   '(
     ("Crenarchaea"   1  0.07  0.7  0.85) ; 0.08 0.75  0.98) ;
     ("Thermoplasmata"   2  0.175 0.9  0.95 ) ;  0.525  0.6  0.8)
    ))

(set! font_size 12) ;13
(set! annulus_radius 34)  ; 36
(set! connect_label_thresh 3)

(veto-label "ARCP1-30" 3)
(show-label "anta6")

(if (eq? quant  elev-quant) 
    (begin
       (set! x_offset -8)
       (set! y_offset 0)
       (set-c-offsets "Thermoplasmata" '(0 6) 'cent)
       (set-c-offsets "E2" '(0 -3) '(0 -0.7))
       (set-c-offsets "anta6" '(0 -1) 'cent)
;       (set-c-offsets "OTU-122" '(0 0.5) '(0 0.5))
;       (set-c-offsets "Terrestrial group" '(0 -1.4) '(0 0))
;       (set-c-offsets "Thermoplasmata" '(0 -9) 'cent)
;
;       (set-c-offsets "Crenarchaeales" '(0 0) '(0 -4.5))
;       (set-c-offsets "SAGMA-X"        '(0 -2) '(0 -1))
       )
     ; ambient
     (begin
       (set! x_offset -2)
       (set! y_offset 0)
       (set-c-offsets "Thermoplasmata" '(0 3) 'cent)
       (set-c-offsets "anta6" '(0 0) '(0 -6))
       )
    )
