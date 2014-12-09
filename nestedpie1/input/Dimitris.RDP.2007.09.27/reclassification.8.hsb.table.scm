 (define top_hsb_vals
   '(
     ("Proteobacteria"                         1    0.0   0.65  0.93)
     ("Acidobacteria"                          2    0.08  0.75  0.98)
     ("Actinobacteria"                         3    0.175 0.9  0.95)
     ("Firmicutes"                             4    0.25  0.7  0.9)
     ("Verrucomicrobia"                        5    0.4   0.7  0.85 )
     ("Bacteroidetes"                          6    0.55  0.7  0.9)
     ("Planctomycetes"                         7    0.7   0.5   0.9)
     ("Gemmatimonadetes"                       8    0.85  0.5  0.9)
     ("Nitrospira"                             9    0.3   0.5  1.0)

     ("OD1"                                   10    1.0   0.4  1.0)
     ("Chloroflexi"                           11    0.475 0.4  0.7)
     ("Cyanobacteria"                         12    1.0   0.4  1.0)
     ("Dehalococcoides"                       13    0.575 0.4  1.0)
     ("Thermomicrobia"                        14    0.75  0.4  0.725)
     ("OP11"                                  15    0.400 0.6  1.0)
     ("TM7"                                   16    0.175 0.6  1.0)
     ("WS3"                                   17    0.175 0.6  1.0)
     ("BRC1"                                  18    0.175 0.6  1.0)
     ("Deferribacteres"                       19    0.12  0.6  1.0)
     ("OP10"                                  20    0.06  0.6  1.0)
    ))

;(set! color_mod_sat_fact 0.85)
;(set! color_mod_bright_fact 1)

;(set! font_size 12) ;13
(set! font_size 7) ;13
(set! annulus_radius 34)  ; 36
(set! connect_label_thresh 3)

(veto-label "Sphingomonadales" 2)
(veto-label "Caulobacterales" 2)

(veto-label "TM7 genera incertae sedis" 1)
(show-label "TM7")
(set-c-offsets   "TM7"   '(0 0) 'cent)

(veto-label "Dehalococcoides genera incertae sedis" 1)
(show-label   "Dehalococcoides")
(set-c-offsets   "Dehalococcoides" '(0 0) 'cent)

(veto-label "Gemmatimonadetes" 0)
(veto-label "Gemmatimonadetes" 1)
(veto-label "Gemmatimonadales" 2) 
(veto-label "Gemmatimonadaceae" 3)

(veto-label "Nitrospira" 1)
(veto-label "Nitrospirales" 2)
(veto-label "Nitrospiraceae" 3)

;(veto-label "Planctomycetes" 0)
(veto-label "Planctomycetacia" 1)
(veto-label "Planctomycetales" 2)

(veto-label "Sphingobacteriales" 2)
(set-c-offsets "Bacteroidetes" '(0 0) 'cent)
(set-c-offsets "Niastella" '(0 0) 'cent)

(veto-label "Verrucomicrobiae" 1)
;(veto-label "Verrucomicrobiales" 2)
;(veto-label "Xiphinematobacteriaceae genera incertae sedis" 4)
(set-c-offsets "Verrucomicrobia" '(0 -4) 'cent)

(veto-label "Bacillales" 2)

(show-label "Chloroflexi")
(set-c-offsets "Chloroflexi" '(0 0) 'cent)
(veto-label "Anaerolineae" 1)
(veto-label "Anaerolinaeles" 2)
(veto-label "Anaerolinaeceea" 3)
(veto-label "Anaerolinea" 4)
(veto-label "Caldilineales" 2)
(veto-label "Caldilineacea" 3)
(veto-label "Caldilinea" 4)
(veto-label "Levilinea" 4)

(veto-label "Rubrobacteridae" 1)
(veto-label "Rubrobacterales" 2)
(set-c-offsets  "Rubrobacterineae" '(0 0) 'cent)
  
(veto-label "Thermoanaerobacteriaceae" 2)

(show-label "Pedomicrobium")
(show-label "Methalocystis")
(show-label "Sphingomonas")
(show-label "Caulobacteraceae")
(show-label "Rhodobium")
(show-label "Oxalobacteraceae")
(show-label "Duganella")
(show-label "Polaromonas")
(show-label "Thiomonas")

(set-c-offsets "Sphingomonas" '(0 0) 'cent)

(veto-label "Xanthomonadales" 2)
(show-label "Xanthomonadaceae")
(veto-label "Pseudomonadales" 2)
(show-label "Pseudomonadaceae")
(show-label "Pseudomonas")

(show-label "Actinobacteridae")
(show-label "Micrococcaceae")
(show-label "Arthrobacter")

(show-label "Streptosporangineae")
(show-label "Frankia")

(show-label "Rubrobacterineae")
(show-label "Solirubrobacter")
;(show-label "Pseudonocardineae")
(show-label "Actinosynnemataceae")
(show-label "Lechevalieria")

(show-label "Clostridia")
(veto-label "Bacillaceae" 3)
(show-label "Alicyclobacillus" )
(show-label "Thermoanaerobacteriales")
(show-label "Thermacetogenium")
          
(veto-label "3" 3)
(show-label "3 genera incertae sedis")

(show-label "Verrucomicrobiales")
(show-label "Xiphinematobacteriaceae genera incertae sedis")

(veto-label "Terrimonas" 4)
(show-label "Chitinophaga")

(show-label "Planctomycetes")

(show-label "Gemmata")

(show-label "Nitrospira")

(show-label "Chloroflexi")

(show-label "Thermomicrobia")
(set-c-offsets "Thermomicrobia" '(0 0) 'cent)

(show-label "Cyanobacteria")

(show-label "Gp2")
(show-label "OD1")
(set-c-offsets "OD1" '(0 0) 'cent)

(show-label "WS3")
(veto-label   "Pseudonocardineae" 3)

(show-label "Frankineae")

(if (eq? quant  elev-quant) 
    ;   Elevated
    (begin 
        (outer-label "Gp1" 4)
        (outer-label "Gp3" 4)
        (set-c-offsets   "Rhodospirillales"   '(0 0) 'cent)
        (set-c-offsets   "Acetobacteraceae"   '(0 0) 'cent)
        (set-c-offsets   "Betaproteobacteria"   '(0 1.5) 'cent)
        (set-c-offsets   "Deltaproteobacteria"   '(0 0) 'cent)
        (set-c-offsets   "Gammaproteobacteria"   '(0 0) '(0 1))
        (set-c-offsets   "Myxococcales"          '(0 -1) 'cent)
        (set-c-offsets   "Desulfuromonales"      '(0 1) 'cent)
        (veto-label   "Rubrobacterineae"   3)
        (set-c-offsets "Actinosynnemataceae" '(0 0) '(0 -2))
        (set-c-offsets "Lechevalieria" '(0 0) '(0 -1))
        (set-c-offsets "Clostridia" '(0 0) 'cent)
        (set-c-offsets "Firmicutes" '(0 1) 'cent)
        (set-c-offsets "Solirubrobacter" '(0 0) '(0 -1))
        (set-c-offsets "Rubrobacteraceae" '(0 0) '(0 -1))
        (set-c-offsets "Thermacetogenium" '(0 -2) 'cent)
        (set-c-offsets "Verrucomicrobiales" '(0 0) 'cent)
        (set-c-offsets "Xiphinematobacteriaceae" '(0 0) 'cent)
        (set-c-offsets "Xiphinematobacteriaceae genera incertae sedis" 
                                               '(0 0)  '(0 1))
        (set-c-offsets "Thermoanaerobacteriales" '(0 -0.5) 'cent)

        (set-c-offsets "Gemmatimonadetes" '(0 0) 'cent)
        (set-c-offsets "Crenotrichaceae" '(0 0) 'cent)
        (set-c-offsets "Planctomycetes" '(0 -1) 'cent)
        (set-c-offsets "Nitrospira" '(0 0) 'cent)
        (set-c-offsets "Chloroflexi" '(0 0) 'cent)
        (set-c-offsets "WS3" '(0 0) 'cent)
        (set-c-offsets "Cyanobacteria" '(0 0) 'cent)
        (set-c-offsets "Thiomonas" '(0 0) 'cent)
        (set-c-offsets "Duganella" '(0 -0.5) 'cent)
        (set-c-offsets "Burkholderia" '(0 -0.5) 'cent)
       )
     ; Amb
     (begin
        (outer-label "Gp1" 4)

        (set-c-offsets "Sphingobacteria" '(0 0) 'cent)
        (set-c-offsets "Bacteroidetes" '(0 -5) 'cent)
        (veto-label "Actinobacteridae" 1)
        (set-c-offsets "Actinobacteria" '(0 -1) 'cent)
        (set-c-offsets "Lechevalieria" '(0 -0.5) 'cent)
        (set-c-offsets "Frankineae" '(0 -0.8) 'cent)
        (set-c-offsets "Actinomycetales" '(0 1) 'cent)
        (set-c-offsets   "Betaproteobacteria"   '(0 0) '(0 0))
        (set-c-offsets   "Deltaproteobacteria"   '(0 0) 'cent)
        (set-c-offsets   "Gammaproteobacteria"   '(0 0) 'cent)
        (veto-label "Sorangineae" 3)
        (set-c-offsets "Polyangiaceae" '(0 -2) 'cent)
        (set-c-offsets "Burkholderiaceae" '(0 0) 'cent)
        (set-c-offsets "Burkholderia" '(0 -1) 'cent)
        (set-c-offsets "Burkholderiales" '(0 0) 'cent)
        (set-c-offsets "Rhodospirillales" '(0 2) 'cent)
        (set-c-offsets "Thermoanaerobacteriales" '(0 0) 'cent)
        (set-c-offsets "Clostridia" '(0 0) 'cent)
        (set-c-offsets "Firmicutes" '(0 -8) 'cent)
        (set-c-offsets "Pseudomonas" '(0 2) 'cent)
        (set-c-offsets "Micrococcaceae" '(0 -1) 'cent)
        (set-c-offsets "Streptosporangineae" '(0 1) 'cent)
        (set-c-offsets "Actinomycetales" '(0 0) 'cent)
        (set-c-offsets "Actinosynnemataceae" '(0 1) 'cent)
        (set-c-offsets "Crenotrichaceae" '(0 0) 'cent)
        (set-c-offsets "Planctomycetes" '(0 -3) 'cent)
        (set-c-offsets "Nitrospira" '(0 0) 'cent)
        (set-c-offsets "Chloroflexi" '(0 -0.6) 'cent)
        (set-c-offsets "Corynebacterineae" '(0 0) '(0 -1))
        (set-c-offsets "Micrococcaceae" '(0 -2) '(0 -1))
        (set-c-offsets   "Arthrobacter"   '(0 -0.75) '(0 -1))
        (set-c-offsets "WS3" '(0 0.9) 'cent)
        (set-c-offsets "Cyanobacteria" '(0 -0.4) 'cent)
        (set-c-offsets "Gemmatimonadetes" '(0 0) 'cent)

       )
    )

; remove - this is temp
;        (set-c-offsets   "Betaproteobacteria"   '(80 0) 'cent)

