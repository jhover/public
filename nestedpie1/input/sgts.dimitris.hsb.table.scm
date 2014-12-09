(define top_hsb_vals
  '(
      ("Fungi"                  1    0.125 0.75  0.85)           ; 271 246 0.0)
      ("Alveolata"              2    0.56  0.6  0.9)           ; 57 113 0.0)
      ("stramenopiles"          3    0.90   0.6  0.8)      ;.98     ; 59 34 0.0)
      ("Acanthamoebidae"        4    1.0   0.4  1.0)           ; 8 0 0.0)
      ("Cercozoa"               5    0.175  0.9  0.95 )           ; 73 102 0.0)
      ("Euglenozoa"             6   0.75  0.4  0.725)         ; 1 0 0.0) ;14
      ("Metazoa"                7    0.07  0.7  0.85)      ;0.07     ; 67 69 0.0)
      ("Viridiplantae"          8    0.25  0.75  0.9)           ; 270 286 0.0)
      ("Acantharea"             9    0.575 0.4  1.0) 
      ("Lobosea"               10    0.98  0.6  0.8)           ; 15 4 0.0)
      ("Polycystinea"          11   0.175 0.6  1.0)           ; 1 3 0.0)
      ("Rhodophyta"            12   0.75  0.4  0.725)         ; 1 0 0.0) ;14

      ;("Cercozoa"               3    0.4   0.6  0.85 )           ; 73 102 0.0)
      ;("Stramenopiles"          5    0.475 0.6  0.75)           ; 59 34 0.0)
      ;("Alveolata"              6    0.90  0.6  0.85)           ; 57 113 0.0)
      ;("Cryothecomonas"         8    0.75  0.6  0.75)           ; 51 5 0.0)
      ;("Proleptomonas"          9   0.175 0.6  1.0)           ; 0 2 0.0) 17
      ;("environmental_samples"  10   0.175 0.6  1.0)           ; 8 4 0.0)
      ;("Apusomonadidae"         11    0.3   0.5  1.0)           ; 8 0 0.0)
      ;("Choanoflagellida"       13   0.475 0.4  0.7)           ; 4 0 0.0)
      ;("Granuloreticulosea"     14   1.0   0.4  1.0)           ; 3 0 0.0)
      ;("Cryptophyta"            15   0.575 0.4  1.0)           ; 3 0 0.0)
      ;("Plasmodiophorida"       16   0.175 0.6  1.0)           ; 1 3 0.0)
      ;("Eccrinales"             17   0.175 0.6  1.0)           ; 1 0 0.0)
     ; ("Ichthyosporea"          20   0.175 0.6  1.0)           ; 0 4 0.0)
      ;("Heterolobosea"          21   0.175 0.6  1.0)           ; 0 3 0.0)
      ;("Centroheliozoa"         25   0.175 0.6  1.0)           ; 1 0 0.0)
     ; ("Trimastix"              27   0.175 0.6  1.0)           ; 0 4 0.0)

   ))

(set! font_size 12) ; 12 ;13
(set! connect_label_thresh 3)
(set! annulus_radius 44)

(veto-label "Ascomycota" 3)

(veto-label "Bicosoecida" 2)
(veto-label "unclassified" 2)
(veto-label "Bicosoecida"  1)
(veto-label "Halocafeteria" 2)

(veto-label "Kinetoplastida" 1)
(veto-label "Bodonidae" 2)
(veto-label "Acanthamoeba" 1)
(veto-label "Cercomononas" 1)
(veto-label "Cercomonadidae" 1)
(veto-label "Heteromitidae" 1)

(show-label "Euglenozoa")
(show-label "Dimastigella")
(set-c-offsets "Euglenozoa"       '(0 0) '(0 0))
(set-c-offsets "Dimastigella"       '(0 0) '(0 0))

(set-c-offsets "Basidiomycota"  '(0 2)  '(0 -3))
(set-c-offsets "Urediniomycetes"  '(0 0)  '(0 0))
(set-c-offsets "Sporidiobolaceae"  '(0 -2)  '(0 0))
(set-c-offsets "Leucosporidium"  '(0 -4)  '(0 0))

(set-c-offsets "Cercozoa"        '(0 -2.5) 'cent)
(set-c-offsets "Cercomonadidae"  '(0 0) '(0 0))
(set-c-offsets "Cercomonas"      '(0 0) 'cent)
(set-c-offsets "Heteromita"      '(0 0) 'cent)

(set-c-offsets "Xylariales"      '(0 0) 'cent)
(set-c-offsets "Ophiostomatales"      '(0 0) 'cent)

(set-c-offsets "Acanthamoebidae" '(0 -2) 'cent)
(set-c-offsets "stramenopiles"    '(0 0) 'cent)

(set-c-offsets "Dinophyceae" '(0 0) 'cent)
(set-c-offsets "Alveolata" '(0 2) 'cent)

(set-c-offsets "Pezizomycotina" '(0 0) '(0 0))
(set-c-offsets "Sordariomycetes" '(0 0) '(0 -2))

(set-c-offsets "Bicosoecida" '(0 0) '(0 1))
(set! x_offset 50)
(set! y_offset -30)


