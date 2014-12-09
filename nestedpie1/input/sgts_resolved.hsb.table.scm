(define top_hsb_vals
  '(
      ("Fungi"                  1    0.125 0.75  0.85)           ; 271 246 0.0)
      ("Viridiplantae"          2    0.25  0.75  0.9)           ; 270 286 0.0)
      ;("Cercozoa"               3    0.4   0.6  0.85 )           ; 73 102 0.0)
      ("Cercozoa"               3    0.175  0.9  0.95 )           ; 73 102 0.0)
      ("Metazoa"                4    0.07  0.7  0.85)      ;0.07     ; 67 69 0.0)
      ;("Stramenopiles"          5    0.475 0.6  0.75)           ; 59 34 0.0)
      ("stramenopiles"          5    0.90   0.6  0.8)      ;.98     ; 59 34 0.0)
      ;("Alveolata"              6    0.90  0.6  0.85)           ; 57 113 0.0)
      ("Alveolata"              6    0.56  0.6  0.9)           ; 57 113 0.0)
      ("Lobosea"                7    0.98  0.6  0.8)           ; 15 4 0.0)
      ("Cryothecomonas"         8    0.75  0.6  0.75)           ; 51 5 0.0)
      ("Proleptomonas"          9   0.175 0.6  1.0)           ; 0 2 0.0) 17
      ("environmental_samples"  10   0.175 0.6  1.0)           ; 8 4 0.0)
      ("Apusomonadidae"         11    0.3   0.5  1.0)           ; 8 0 0.0)
      ("Acanthamoebidae"        12   1.0   0.4  1.0)           ; 8 0 0.0)
      ("Choanoflagellida"       13   0.475 0.4  0.7)           ; 4 0 0.0)
      ("Granuloreticulosea"     14   1.0   0.4  1.0)           ; 3 0 0.0)
      ("Cryptophyta"            15   0.575 0.4  1.0)           ; 3 0 0.0)
      ;("Plasmodiophorida"       16   0.175 0.6  1.0)           ; 1 3 0.0)
      ("Polycystinea"       16   0.175 0.6  1.0)           ; 1 3 0.0)
      ("Eccrinales"             17   0.175 0.6  1.0)           ; 1 0 0.0)
      ("Ichthyosporea"          20   0.175 0.6  1.0)           ; 0 4 0.0)
      ("Heterolobosea"          21   0.175 0.6  1.0)           ; 0 3 0.0)
      ("Centroheliozoa"         25   0.175 0.6  1.0)           ; 1 0 0.0)
      ("Rhodophyta"             26   0.75  0.4  0.725)         ; 1 0 0.0) ;14
      ("Euglenozoa"             26   0.75  0.4  0.725)         ; 1 0 0.0) ;14
      ("Trimastix"              27   0.175 0.6  1.0)           ; 0 4 0.0)

   ))

(set! font_size 16) ; 12 ;13
(set! connect_label_thresh 3)

(veto-label "Ascomycota" 3)

(veto-label "Bicosoecida" 2)
(veto-label "unclassified" 2)
(veto-label "Bicosoecida"  2)
(veto-label "Halocafeteria" 2)

(veto-label "Kinetoplastida" 1)
(veto-label "Bodonidae" 2)
(veto-label "Acanthamoeba" 2)

(set-c-offsets "Acanthamoebidae" '(0 0) '(0 3))

(set-c-offsets "Bicosoecida" '(0 0) '(0 1))
(set! x_offset -60)
(set! y_offset 30)