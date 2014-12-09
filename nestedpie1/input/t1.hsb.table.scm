 (define top_hsb_vals
   '(
     ("Gamma"                         1   0.0   0.65  0.93)
     ("Actinobacteria"                2    0.08 0.75  0.98)
     ("Alpha"                         3    0.175 0.9  0.95)
     ("Beta"                          4    0.25  0.7  0.9)
     ("Bacilli"                       5    0.4   0.7  0.85 )
    ))

(set-c-offsets "Bacilli" '(0 10) 'cent)
(set-c-offsets "Serratia sp." '(0 0) 'cent)
(set-c-offsets "Enterobacter amnigenus" '(0 0) 'cent)
(set-c-offsets "Enterobacter sp." '(0 0) 'cent)
(set-c-offsets "Pseudomonas sp." '(0 1) '(0 -8))
(set-c-offsets "Pseudomonas rhizosphaerae" '(0 0) 'cent)
(set-c-offsets "Kluyvera" '(0 0) '(0 -1))
(set-c-offsets "Kluyvera cochleae" '(0 -1) '(0 0))
(set-c-offsets "Rhodococcus sp." '(0 -1) '(0 -3))
(set-c-offsets "Rhodococcus equi." '(0 -1) '(0 -3))
(set-c-offsets "Rhodococcus equi." '(0 -1) '(0 -3))
(set-c-offsets "Stenotrophomonas" '(0 -1) '(0 0))
(set-c-offsets "Stenotrophomonas maltophilia" '(0 -1) '(0 0))
(set-c-offsets "Buttiauxella" '(0 -1) '(0 0))
(set-c-offsets "Buttiauxella gaviniae" '(0 0) '(0 0))
(set-c-offsets "Erwinia sp."           '(0 1) '(0 0))
(set-c-offsets "Leifsonia"             '(0 -2) '(0 0))
(set-c-offsets "Leifsonia xyli."       '(0 0) '(0 -0.5))
(set-c-offsets "Agromyces"             '(0 0) '(0 -0.5))
(set-c-offsets "Agromyces sp."         '(0 1) '(0 -0.5))

(set-c-offsets "Rhizobium"                  '(0 0) '(0 -2))
(set-c-offsets "Agrobacterium rhizogenes"   '(0 -2) '(0 -1))
(set-c-offsets "Agrobacterium tumefaciens"  '(0 0) '(0 -1))

(set-c-offsets "Pseudaminobacter"           '(0 -1) '(0 0))

(set-c-offsets "Burkholderia"               '(0 0) '(0 -1))
(set-c-offsets "Burkholderia sp."           '(0 -1) '(0 -1))

(set-c-offsets "Alcaligenaceae"             '(0 -2) '(0 0))
(set-c-offsets "Alcaligenes sp."            '(0 0) '(0 -0.8))

(set-c-offsets "Staphylococcus"             '(0 -1.5) '(0 0))
(set-c-offsets "Staphylococcus sp."         '(0 0.5) '(0 -0.8))

(set-c-offsets "Bacillus"                   '(0 -1) '(0 0))

(set! radial_label_thresh 10)
