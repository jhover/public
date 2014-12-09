(define top_hsb_vals
  '(
      ("Fungi"                  1    0.125 0.75  0.85)           ; 271 246 0.0)
      ("Viridiplantae"          2    0.25  0.75  0.9)           ; 270 286 0.0)
      ;("Cercozoa"               3    0.4   0.6  0.85 )           ; 73 102 0.0)
      ("Cercozoa"               3    0.175  0.9  0.95 )           ; 73 102 0.0)
      ("Metazoa"                4    0.07  0.7  0.85)      ;0.07     ; 67 69 0.0)
      ;("Stramenopiles"          5    0.475 0.6  0.75)           ; 59 34 0.0)
      ("Stramenopiles"          5    0.90   0.6  0.8)      ;.98     ; 59 34 0.0)
      ;("Alveolata"              6    0.90  0.6  0.85)           ; 57 113 0.0)
      ("Alveolata"              6    0.56  0.6  0.9)           ; 57 113 0.0)
      ("Lobosea"                7    0.98  0.6  0.8)           ; 15 4 0.0)
      ("Cryothecomonas"         8    0.75  0.6  0.75)           ; 51 5 0.0)
      ("Proleptomonas"          9   0.175 0.6  1.0)           ; 0 2 0.0) 17
      ("environmental samples"  10   0.175 0.6  1.0)           ; 8 4 0.0)
      ("Apusomonadidae"         11    0.3   0.5  1.0)           ; 8 0 0.0)
      ("Acanthamoebidae"        12   1.0   0.4  1.0)           ; 8 0 0.0)
      ("Choanoflagellida"       13   0.475 0.4  0.7)           ; 4 0 0.0)
      ("Granuloreticulosea"     14   1.0   0.4  1.0)           ; 3 0 0.0)
      ("Cryptophyta"            15   0.575 0.4  1.0)           ; 3 0 0.0)
      ("Plasmodiophorida"       16   0.175 0.6  1.0)           ; 1 3 0.0)
      ("Eccrinales"             17   0.175 0.6  1.0)           ; 1 0 0.0)
      ("Ichthyosporea"          20   0.175 0.6  1.0)           ; 0 4 0.0)
      ("Heterolobosea"          21   0.175 0.6  1.0)           ; 0 3 0.0)
      ("Centroheliozoa"         25   0.175 0.6  1.0)           ; 1 0 0.0)
      ("Rhodophyta"             26   0.75  0.4  0.725)         ; 1 0 0.0) ;14
   ))

(set! font_size 12) ;13
;(set! font_size 7) ;13
(set! annulus_radius 30) ; 36
(set! y_offset -80)

(show-label "Fungi")
(show-label "Ascomycota")
(show-label "Cazia")
(show-label "Pachyphloeus")
(show-label "Basidiomycota")
(show-label "Inocybe")
(show-label "Grifola")
(show-label "Laccaria")
(show-label "Boletus")
(show-label "Thanatephorus")
(show-label "Thelephora")
(show-label "Tremellodendron")
(show-label "Cryptococcus")
(show-label "Rhodotorula")
(show-label "Zygomycota")
(show-label "Mortierella")

(show-label  "Mortierellaceae")
(show-label "Chytridiomycota")
(show-label "Glomeromycota")

(veto-label "Enoplea" 1)
(veto-label "Zygomycetes" 1)
(veto-label "Mortierellales" 1)
(veto-label "Pezizomycotina" 1)
(veto-label "Pezizomycetes" 1)
(veto-label "Cercomonadidae" 1)
(veto-label "Oomycetes" 1)
(veto-label "Pythiales" 1)
(veto-label "Pythiaceae" 1)
(veto-label "Ciliophora" 1)
(veto-label "Arthropoda" 1)
(veto-label "Hexapoda" 1)
(veto-label "Collembola" 1)
(veto-label "Spirotrichea" 1)
(veto-label "Stichotrichia" 1)
(veto-label "Bryophyta" 1)

(veto-label "Pezizales" 1)
(veto-label "Pezizaceae" 1)
(veto-label "Mortierellaceae" 1)
(set-c-offsets "Chlorophyta" '(-20 0) 'cent)
(set-c-offsets "Chlorophyceae" '(-20 0) 'cent)
(show-label "Trebouxiophyceae")
(set-c-offsets "Trebouxiophyceae" '(-20 0) 'cent)

(set-c-offsets "Cryothecomonas" '(0 0) 'cent)

(set-c-offsets "Pezizales" '(0 -2) 'cent)

(set-c-offsets "Mortierellaceae" '(0 0) 'cent)

(set-c-offsets "Cercozoa" '(0 -2) 'cent)
(set-c-offsets "Cercomonadida" '(0 1) 'cent)

(set-c-offsets "Nematoda" '(0 0) 'cent)

(set-c-offsets "Stramenopiles" '(0 0) 'cent)
(set-c-offsets "Pythium" '(0 0) 'cent)

(veto-label "Stichotrichida" 1)
(set-c-offsets "Stichotrichida" '(0 2) 'cent)

(set-c-offsets "Bryopsida" '(0 0) 'cent)
(set-c-offsets "Dicranidae" '(0 -2) 'cent)
(set-c-offsets "Oxytrichidae" '(0 -2) 'cent)

(veto-label "Oxytrichidae" 1)
(show-label "Orthamphisiella")
(set-c-offsets "Orthamphisiella" '(0 0) 'cent)

(show-label "Gonostomum")
(set-c-offsets "Gonostomum" '(0 0) 'cent)

(set-c-offsets "Laccaria" '(0 0) 'cent)
(set-c-offsets "Glomeromycota" '(0 0) 'cent)
(set-c-offsets "Chytridiomycota" '(0 0) 'cent)


(set-c-offsets "Inocybe" '(0 0) 'cent)

(show-label "Asterales")
(set-c-offsets "Asterales" '(0 0) 'cent)
(show-label "Liliopsida")
(set-c-offsets "Liliopsida" '(0 0) 'cent)

(veto-label "Tricholomataceae" 1)

(show-label "Heterobasidiomycetes")
(show-label "Tremellomycetidae")

(show-label "Cryothecomonas")

(show-label "Bryopsida")
(show-label "Dicranidae")
(show-label "Euglyphida")
(show-label "Trinema")
(veto-label "Trinematidae" 1)

(if (eq? quant  amb-quant) 
    (begin
       (set! x_offset 0)
       (set-c-offsets "Tremellomycetidae" '(0 -1) 'cent)
       (set-c-offsets "Agaricales" '(0 0) 'cent)
       (set-c-offsets "Rhodotorula" '(0 0) 'cent)
       (set-c-offsets "Zygomycota" '(0 -5) 'cent)   ; 3
       (set-c-offsets "Cercomonas" '(0 -1) 'cent)
       (set-c-offsets "Alveolata" '(0 2) 'cent)
       (set-c-offsets "Cazia" '(0 0) '(0 -5))
       (set-c-offsets "Ascomycota" '(0 0) 'cent)
       (set-c-offsets "Pachyphloeus" '(0 0) 'cent)
       (set-c-offsets "Cryptococcus" '(0 2) 'cent)
       (set-c-offsets "Mortierella" '(0 0) 'cent)
       (set-c-offsets "Grifola" '(0 0) 'cent)
       (set-c-offsets "Homobasidiomycetes" '(0 3) '(0 5))
       (set-c-offsets "Thelephora" '(0 0) 'cent)
       (set-c-offsets "Thanatephorus" '(0 0) 'cent)
       (set-c-offsets "Cryothecomonas" '(-60 0) 'cent)
       (set-c-offsets "Bryopsida" '(0 0) 'cent)
       (set-c-offsets "Trinema" '(0 2) 'cent)
       (set-c-offsets "Metazoa" '(0 7) 'cent)

      ; (show-label "Gemmatimonadetes")
       )
    (begin 
       (set! x_offset 0)
       (set-c-offsets "Cercomonas" '(0 0) 'cent)
       (set-c-offsets "Alveolata" '(0 1) 'cent)
       (set-c-offsets "Cazia" '(0 1.5) 'cent)
       (set-c-offsets "Ascomycota" '(0 3.6) 'cent)
       (set-c-offsets "Pachyphloeus" '(0 0) 'cent)
       (set-c-offsets "Mortierella" '(0 1.6) 'cent)
       (set-c-offsets "Grifola" '(0 -7) 'cent)
       (set-c-offsets "Thelephora" '(0 -4) 'cent)
       (set-c-offsets "Thanatephorus" '(90 -3) 'cent)
       (set-c-offsets "Rhodotorula" '(90 -2.5) 'cent)
       (set-c-offsets "Cryptococcus" '(90 0) 'cent)
       (set-c-offsets "Zygomycota" '(0 -1.4) 'cent)   ; 3
       (set-c-offsets "Heterobasidiomycetes" '(0 -17) 'cent) 
       (set-c-offsets "Tremellomycetidae" '(0 -13) 'cent)
       (set-c-offsets "Cryothecomonas" '(-60 0) 'cent)
       (set-c-offsets "Bryopsida" '(0 2) 'cent)
       (set-c-offsets "Metazoa" '(0 0) 'cent)

       ;(set-clabel-offsets "Sphingobacteriales" '(0 -2))
       )
    )
      