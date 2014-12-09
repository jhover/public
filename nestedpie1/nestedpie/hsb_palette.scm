; hsbmap.scm  - produces a multi-page HSB (Hue Saturation Brightness)
;               palette, showing HSB values for postscript sethsbcolor

(load "graf.scm")

(define defbox
  (lambda ()
    (disp "/box {  /l exch def" )
    (disp "        gsave" )
    (disp "        translate" )
    (disp "        newpath 0 0 moveto" )
    (disp "	        0 l rlineto" )
    (disp "		l 0 rlineto" )
    (disp "		0 l neg rlineto" )
    (disp "	closepath fill grestore } def" )
    (disp "" )))

(define box 
  (lambda (x y l)
    (disp x y l "box")))


(define sat-page
  (lambda (s)
    (do ( (h 0 (+ h 25/1000)) (y yoff (+ y (+ boxl 1))) )
        ( (> h 1) )
          (do ( (b 1 (- b 1/20)) (x xoff (+ x (+ boxl 3))) )
             ( (< b 0) )
             (set-hsb-color (exact->inexact h) s (exact->inexact b))
             (box x y boxl)
             )
          (put-string (number->string (exact->inexact h)) (- xoff 30) (+ y 6) 1.0)
         )
    (do ( (b 1 (- b 1/20)) (x xoff (+ x (+ boxl 3))) )
        ( (< b 0) )
        (put-string-vert-center (number->string (exact->inexact b))
                                (+ x 12) (- yoff 10) 1.0)
        )
    (put-string (string-append "sat: " (number->string s)) 550 50 1.0)
    ))
   

(preamble "tree" "test1.scm")
(page-preamble 1)
(defbox)

(set-font "Helvetica" 10)

(define boxl 17)

(define yoff 50)
(define xoff 100)


(do ( (s 1 (- s 1/10)) )
    ( (< s 0) )
    (sat-page (exact->inexact s))
    (put-string-vert-center "hue" (- xoff 50) 400 1.0)
    (put-string "brightness" 290 (- yoff 40) 1.0)
    (show-page)
    )

(postamble 1)