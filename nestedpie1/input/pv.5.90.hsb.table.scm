 (define top_hsb_vals
   '(
     ;("Acidobacteria"                          4    0.25  0.7  0.85)
     ("Acidobacteria"                          4    0.25  0.7  0.9)
     ;("Actinobacteria"                         2    0.125 0.75  0.8)
     ("Actinobacteria"                         2    0.08 0.75  0.98)
     ;("Bacteroidetes"                          6    0.55  0.7  0.8)
     ("Bacteroidetes"                          6    0.55  0.7  0.9)
     ("Chlorobi"                              14    0.75  0.4  0.725)
     ("Cyanobacteria"                         11    0.475 0.4  0.7)
     ;("Firmicutes"                             3    0.175 0.7  0.85)
     ("Firmicutes"                             3    0.175 0.9  0.95)
     ;("Gemmatimonadetes"                       8    0.85  0.7  0.7)
     ("Gemmatimonadetes"                       8    0.85  0.5  0.9)
     ("Genera_incertae_sedis_BRC1"            16    0.175 0.6  1.0)
     ;("Genera_incertae_sedis_Dehalococcoides" 20    0.175 0.6  1.0)
     ("Genera_incertae_sedis_Dehalococcoides" 20    0.06 0.6  1.0)
     ("Genera_incertae_sedis_OP10"            18    0.175 0.6  1.0)
     ("Genera_incertae_sedis_OP11"            17    0.175 0.6  1.0)
     ;("Genera_incertae_sedis_TM7"             19    0.175 0.6  1.0)
     ("Genera_incertae_sedis_TM7"             19    0.12 0.6  1.0)
     ("Genera_incertae_sedis_WS3"             15    0.400 0.6  1.0)
     ("Nitrospira"                             9    0.3   0.5  1.0)
     ;("Planctomycetes"                         7    0.7  0.7   0.9)
     ("Planctomycetes"                         7    0.7  0.5   0.9)
     ;("Proteobacteria"                         1    0.0   0.75  0.9)
     ("Proteobacteria"                         1    0.0   0.65  0.93)
     ("Thermodesulfobacteria"                 12    1.0   0.4  1.0)
     ("Thermomicrobia"                        10    1.0   0.4  1.0)
     ("Thermotogae"                           13    0.575 0.4  1.0)
     ;("Verrucomicrobia"                        5    0.4   0.7  0.7 )
     ("Verrucomicrobia"                        5    0.4   0.7  0.85 )
    ))

;(set! color_mod_sat_fact 0.85)
;(set! color_mod_bright_fact 1)

(set! font_size 12) ;13
;(set! font_size 7) ;13
(set! annulus_radius 34)  ; 36

(show-label "Acidobacteria")
(show-label "Acidobacteria")
(show-label "Acidobacterium")
(show-label "Actinobacteria")
(show-label "Actinobacteria")
(show-label "Arthrobacter")
(show-label "Mycobacterium")
(show-label "Thermobispora")
(show-label "Sporichthya")
(show-label "Streptomyces")
(show-label "Bacteroidetes")
;(show-label "Flavobacteria")
(show-label "Flavobacterium")
(show-label "Sphingobacteria")
(show-label "Chitinophaga")
(show-label "Firmicutes")
(show-label "Bacilli")
(show-label "Bacillus")
(show-label "Thermobacillus")
(show-label "Clostridia")
(show-label "Desulfotomaculum")
(show-label "Genera_incertae_sedis")
(show-label "TM7")
(show-label "WS3")
(show-label "1145.8")
(show-label "Planctomycetes")
(show-label "Planctomycetacia")
(show-label "Gemmata")
(show-label "Pirellula")
(show-label "Proteobacteria")
(show-label "Alphaproteobacteria")
(show-label "Bradyrhizobium")
(show-label "Hyphomicrobium")
(show-label "Rhodoplanes")
(show-label "Rhizobium")
(show-label "Betaproteobacteria")
(show-label "Acidovorax")
(show-label "Duganella")
(show-label "Oxalobacter")
(show-label "Azonexus")
(show-label "Verrucomicrobia")
(show-label "Verrucomicrobiae")
(show-label "Prosthecobacter")
(show-label "Verrucomicrobium")
(show-label "Gemmatimonadetes")

(veto-label "Verrucomicrobiae" 1)
(veto-label "Planctomycetacia" 1)

(veto-label "Acidobacteria" 1)
(veto-label "Acidobacteriales" 1)
(veto-label "Acidobacteriaceae" 1)
(veto-label "Gemmatimonadetes" 1)
(veto-label "Sphingobacteria" 1)

(set-c-offsets   "Rhizobium"   '(0 0) 'cent)
(set-c-offsets   "Rhodoplanes"   '(0 0) 'cent)
(set-c-offsets   "Hyphomicrobiaceae"   '(0 0) 'cent)
(set-c-offsets   "Hyphomicrobium"   '(0 0) 'cent)
(set-c-offsets   "Bradyrhizobium"   '(0 0) 'cent)

(set-c-offsets   "Betaproteobacteria" '(0 4) '(0 -8))
(set-c-offsets   "Duganella"    '(0 -0.5) 'cent)

(show-label  "Deltaproteobacteria")
(set-c-offsets  "Deltaproteobacteria" '(0 0) 'cent)


(set-c-offsets "Desulfuromonales" '(0 3) 'cent)
(set-c-offsets "Desulfuromonaceae" '(0 0) 'cent)

(show-label "Pelobacter")
(set-c-offsets "Pelobacter" '(0 -2) 'cent)


(set-c-offsets "Streptomyces" '(0 0) 'cent)
(set-c-offsets "Arthrobacter" '(0 0) 'cent)
(set-c-offsets "Mycobacterium" '(0 0) 'cent)
(set-c-offsets "Sporichthya" '(0 0) 'cent)

(show-label    "Actinomycetales")
(set-c-offsets "Actinomycetales"  '(0 1) '(0 3))

(set-c-offsets "Firmicutes" '(0 0) 'cent)
(set-c-offsets "Bacilli" '(0 0) 'cent)
(set-c-offsets "Thermobacillus" '(0 3) 'cent)
(set-c-offsets "Clostridia" '(0 0) 'cent)

(show-label "Peptococcaceae")

(veto-label "Verrucomicrobiaceae" 1)
(set-c-offsets "Verrucomicrobium" '(0 -2) 'cent)


(show-label "Sphingobacteriales")
(set-c-offsets "Sphingobacteriales" '(0 0) 'cent)

(veto-label "Crenotrichaceae" 1)

(set-c-offsets "Flavobacteria" '(0 -1) 'cent)

(veto-label "Planctomycetaceae" 1)
(veto-label "Planctomycetales" 1)
(set-c-offsets "Planctomycetes" '(0 0) 'cent)
(set-c-offsets "Gemmata" '(0 0) 'cent)

(set-c-offsets "Gemmatimonadetes" '(0 0) 'cent)

(set-c-offsets "Gammaproteobacteria" '(0 0) '(0 -2))

(veto-label "Rhodocyclales" 1)
(veto-label "Micrococcaceae" 1)

(veto-label "Clostridia" 1)
(show-label "Clostridiales")

(veto-label "Verrucomicrobiales" 1)

(show-label "Rhodospirillales")
(show-label "Sphingomonadales")
(show-label "Bradyrhizobiaceae")
(show-label "Methylocystaceae")
(show-label "Conexibacter")

(if (eq? quant  amb-quant) 
    (begin
       (set! x_offset 6)
       (set! y_offset 0)
       ;(set-clabel-offsets "Verrucomicrobiales" '(0 4))
       (show-label "Gemmatimonadetes")

       (set-c-offsets   "Acidobacteria" '(0 -1) 'cent)
       (set-c-offsets   "Acidobacterium" '(0 -4) '(0 -3) )

       (set-c-offsets   "Azonexus"   '(0 -2) 'cent)

       (veto-label "Actinobacteria" 1)  ; knock out class redundancy
       (set-c-offsets "Actinobacteria"  '(0 5) 'cent)

       (set-c-offsets "Desulfotomaculum" '(0 0) 'cent)

       (set-c-offsets "Clostridia" '(0 2) 'cent)

       (set-c-offsets "Bacilli" '(0 0) 'cent)
       (set-c-offsets "Verrucomicrobia" '(0 -3) 'cent)
       (set-c-offsets  "Prosthecobacter" '(0 2) 'cent)

       (set-c-offsets   "Oxalobacter"    '(0 0) 'cent)
       (set-c-offsets   "Burkholderiales" '(0 3) 'cent)

       (set-c-offsets   "Betaproteobacteria" '(0 5) '(0 -8))

       (set-c-offsets   "Acidovorax"    '(0 -0.4) 'cent)
       (set-c-offsets   "Rhodocyclaceae" '(0 4) 'cent)
       (set-c-offsets "Peptococcaceae"  '(0 -3) '(0 -3))
       (set-c-offsets "Thermobispora" '(0 -0.5) 'cent)
       (set-c-offsets "Bacillus" '(0 0) 'cent)
       (set-c-offsets "Bacteroidetes" '(0 -5) 'cent)
       (set-c-offsets "Flavobacterium" '(0 0.7) 'cent)

       (set-c-offsets "Peptococcaceae" '(0 -1) '(0 -4))
       (set-c-offsets "Pirellula" '(0 0) 'cent)
       (set-c-offsets "Conexibacter" '(0 0) 'cent)
       )
    ;   Elevated
    (begin 
       (set! x_offset 10)

       (set-c-offsets   "Acidobacteria" '(0 3) '(0 3))
       (set-c-offsets   "Acidobacterium" '(0 -2) '(0 -2))

       (set-c-offsets   "Azonexus"   '(0 -2) 'cent)


       ;(veto-label "Thermobacillus" 0)

       (set-c-offsets "Bacilli" '(0 5) 'cent)
       (set-c-offsets "Verrucomicrobia" '(0 -1.7) 'cent)
       (set-c-offsets "Prosthecobacter" '(0 0) 'cent)

       (set-c-offsets   "Oxalobacter"    '(0 2) 'cent)
       (set-c-offsets   "Burkholderiales" '(0 3) 'cent)

       (set-c-offsets "Flavobacterium" '(0 0) 'cent)

       (set-c-offsets   "Acidovorax"    '(0 0.5) 'cent)

       (set-c-offsets "Actinobacteria"  '(0 7) 'cent)
       (set-c-offsets "Clostridia"      '(0 -1) 'cent)
       (set-c-offsets "Thermobispora" '(0 0) 'cent)
       (set-c-offsets "Bacillus" '(0 0.5) 'cent)
       (set-c-offsets "Bacteroidetes" '(0 -6) 'cent)

       (set-c-offsets "Clostridiales" '(0 0) 'cent)
       (set-c-offsets "Desulfotomaculum" '(0 -3) 'cent)
       (set-c-offsets "Peptococcaceae" '(0 -0.2) 'cent)
       (set-c-offsets "Pirellula" '(0 0.5) 'cent)
       (set-c-offsets "Conexibacter" '(0 -1.5) 'cent)

       )
    )


(if circular_outer_labels
    (begin
      (set-clabel-offsets "Acidobacteria" (list font_size 2))
      (set-clabel-offsets "Acidobacterium" (list (* 0 font_size) -3))

      (set-clabel-offsets "Chitinophaga" (list (* 0 font_size) -3))
      (set-clabel-offsets "Crenotrichaceae" (list (* 1 font_size) -1))
      (set-clabel-offsets "Sphingobacteriales" (list (* 2 font_size) 0))
      (set-clabel-offsets "Sphingobacteria" (list (* 3 font_size) 1))
      (set-clabel-offsets "Bacteroidetes" (list (* 4 font_size) 2))

      ))