(define top_hsb_vals 
   '(
     ;("Crenarchaeota"   1  0.875  0.6  0.8)
     ("Crenarchaeota"   1 0.07  0.7  0.85)
     ("Euryarchaeota"   2  0.525  0.6  0.8)
     ;("Environmental_samples"      3  0.225  0.6  0.8)
     ("Environmental_samples"      3 0.125 0.75  0.85)
    ))

(show-label "AJ831163")
(set-c-offsets   "AJ831163" '(0 -3) 'cent)

(show-label "DQ223193")

;;
(show-label "AJ535129")
(set-c-offsets   "AJ535129" '(0 0) 'cent)
(show-label "AJ535123")
(set-c-offsets   "AJ535123" '(0 0) 'cent)
(show-label "AY601298")
(set-c-offsets   "AY601298" '(0 0) 'cent)
(show-label "AJ535127")
(set-c-offsets   "AJ535127" '(0 0) 'cent)
(show-label "AJ535130")
(show-label "AJ428025")
(show-label "AJ535121")
(set-c-offsets   "AJ535121" '(0 0) 'cent)
(show-label "AJ496176")
(set-c-offsets   "AJ496176" '(0 0) 'cent)
(show-label "U62816")
(show-label "AM039534")
(set-c-offsets   "AM039534" '(0 0) 'cent)
;;

;;
(show-label "AB161345")
(set-c-offsets   "AB161345" '(0 0) 'cent)
(show-label "X96688")
(set-c-offsets   "X96688" '(0 0) 'cent)
(show-label "AF523939")
(set-c-offsets   "AF523939" '(0 0) 'cent)
(show-label "AF523944")
(set-c-offsets   "AF523944" '(0 0) 'cent)
(show-label "X96691")
(set-c-offsets   "X96691" '(0 0) 'cent)
(show-label "X96696")
(set-c-offsets   "X96696" '(0 0) 'cent)
(show-label "AJ831163")
(set-c-offsets   "AJ831163" '(0 0) 'cent)
(show-label "AJ831155")
(set-c-offsets   "AJ831155" '(0 0) 'cent)
;;

(show-label "Euryarchaeota")
(set-c-offsets "Euryarchaeota" '(0 0.3) 'cent)

(if (eq? quant  amb-quant) 
    (begin
       (set-c-offsets   "Environmental samples" '(0 20) 'cent)
       (set-c-offsets   "AJ535130" '(0 0) 'cent)
       (set-c-offsets   "AJ428025" '(0 0) 'cent)
       (set-c-offsets   "U62816" '(0 2) 'cent)
       )
    (begin  ; elev
       (set-c-offsets   "Environmental samples" '(0 5) 'cent)
       (set-c-offsets   "AJ535130" '(0 2) 'cent)
       (set-c-offsets   "AJ428025" '(0 4.5) 'cent)
       (set-c-offsets   "U62816" '(0 0) 'cent)
       )
  )