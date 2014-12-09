; File:         graf.scm
; Language:     Scheme (mzScheme)
; Programmer:   Sean R. McCorkle
; Description:  low-level (Postscript generating) graphical routines
;
; $Id: graf.scm,v 3.5 2004/11/24 03:25:06 mccorkle Exp mccorkle $
;
(load "io.scm")

; (set-font "Courier-Bold" 15)
; (put-char c x y gray) - gray is inverted from PS 0 - lightest, 1 darkest

(define current_font_size #f)
(define current_font_width #f)
(define current_font_height #f)

(define left_limit 70.0)
(define right_limit (* 7.5 72))
(define bottom_limit 50)
(define top_limit (* 9.5 72))

(define set-landscape
  (lambda ()
    (disp 0 (* 11.0 72) "translate")
    (disp -90 "rotate")
    (set! bottom_limit 30.0)
    (set! top_limit (* 7.0 72))
    (set! left_limit 40.0)
    (set! right_limit (* 9.5 72))
    ))

(define set-font
  (lambda (name size)
    (set! current_font_size size)
    (set! current_font_width (* 0.6 size))
    (set! current_font_height (* 0.8 size))
    (disp (string-append "/" name) "findfont" size "scalefont setfont")
    ))
  
(define put-char
  (lambda (c x y color)
    (set-color color)
    (disp x y "moveto" (list->string (list #\( c #\))) "show")
    ))

(define put-string
  (lambda (s x y color)
    (set-color color)
    (disp x y "moveto" (string-append "(" s ")" ) "show")
    ))

(define put-string-right
  (lambda (s x y color)
    (set-color color)
    (disp x y "moveto" (string-append "(" s ")" ) "rightshow")
    ))

(define put-string-center
  (lambda (s x y color)
    (set-color color)
    (disp x y "moveto" (string-append "(" s ")" ) "showcenter")
    ))

(define put-string-vert-center
  (lambda (s x y color)
    (set-color color)
    (disp x y (string-append "(" s ")" ) "vshowcenter")
    ))

(define put-rot-string
  (lambda (s x y ang color)
    (set-color color)
    (disp x y "moveto" 
          "gsave"
          ang "rotate"
          (string-append "(" s ")" ) "show"
          "grestore" "% rot string")
    ))

(define put-rot-string-right
  (lambda (s x y ang color)
    (set-color color)
    (disp x y "moveto" 
          "gsave"
          (+ ang 180) "rotate"
          (string-append "(" s ")" ) "rightshow"
          "grestore" "% rot string")
    ))

(define show-page
  (lambda () (disp "showpage")))

(define set-gray
  (lambda (gray)
    (disp (- 1.0 gray) "setgray")))

(define set-rgb-color
  (lambda (r g b)
    (disp r g b "setrgbcolor")))

; (set-color number) -sets a gray level
; (set-color '(num num num)) - sets a rgb value
;                            - should add color names too
;
(define set-color
  (lambda (col)
    (cond ( (number? col)                                (set-gray col) )
          ( (and (list? col) 
                 (equal? '(#t #t #t) (map number? col))) (apply set-rgb-color col) )
          ( else                                         (error "bad color") )
          )))

(define set-hsb-color
  (lambda (h s b) (disp h s b "sethsbcolor")))

;(put-box x y width height color) - x, y coords of lower left corner
;
(define put-box 
  (lambda (x y width height color)
    (set-color color)
    (disp "newpath" x y "moveto")
    (disp 0 height "rlineto")
    (disp width 0 "rlineto")
    (disp 0 (- height) "rlineto")
    (disp "closepath fill")
    ))
;
; (put-iso-triangle x y width height angle color style)
; negative height points down.  style: 'filled 'unfilled
;
(define put-iso-triangle
  (lambda (x y width height ang color style)
    (set-color color)
    (disp x y width height ang
          (if (eq? style 'filled) "filledisotriangle" "unfilledisotriangle"))
    ))

(define put-circle
  (lambda (x y radius color style)
    (set-color color)
    (disp x y radius  (if (eq? style 'filled) "filledcircle" "unfilledcircle"))
    ))

(define put-line
  (lambda (x1 y1 x2 y2 color)
    (set-color color)
    (disp "newpath" x1 y1 "moveto" x2 y2 "lineto stroke")
    ))

;
; (put-waterdrop x y size color style)
; negative height points down.  style: 'filled 'unfilled
;
(define put-waterdrop
  (lambda (x y size color style)
    (set-color color)
    (disp x y size 
          (if (eq? style 'filled) "filledwaterdrop" "unfilledwaterdrop"))
    ))

(define put-hexagon
  (lambda (x y size color style)
    (set-color color)
    (disp x y "moveto" size 
          (if (eq? style 'filled) "filledhexagon" "unfilledhexagon"))
    ))

(define preamble
  (lambda (title progname)
    (disp "%!PS-Adobe-3.0")
    (disp "%%BoundingBox: 69 69 556 739")
    (disp "%%Title:" title)
    (disp "%%CreationDate: Tue Mar 16 11:52:57 2003")
    (disp "%%Creator:" progname "by Sean R. McCorkle (mccorkle@bnl.gov)")
    (disp "%%Orientation: Landscape")
    (disp "%%Pages: (atend)")
    (disp "%%EndComments")
    (disp "%%BeginProlog")
    (disp "")
    (disp "/rightshow { dup stringwidth pop 0 exch sub 0 rmoveto show } def" )
    (disp "/showcenter { dup stringwidth pop 2 div 0 exch sub 0 rmoveto show } def" )
    (disp "/vshowcenter { gsave 3 1 roll translate 90 rotate 0 0 moveto" )
    (disp "               dup stringwidth pop 2 div 0 exch sub 0 rmoveto" )
    (disp "               show  grestore } def" )
    (disp "/filledcircle { newpath 0 360 arc fill } def" )
    (disp "/unfilledcircle { newpath 0 360 arc stroke } def" )
    (disp "% xvert yvert w h ang isotriangle")
    (disp "/DrawSliceBorder {")
    (disp "            /grayshade exch def")
    (disp "            /endangle exch def")
    (disp "            /startangle exch def")
    (disp "            /radius exch def")
    (disp "            newpath 0 0 moveto")
    (disp "              0 0 radius startangle endangle arc")
    (disp "            closepath")
    (disp "            1.415 setmiterlimit")
    (disp "            gsave")
    (disp "              grayshade setgray")
    (disp "              fill")
    (disp "            grestore")
    (disp "            stroke")
    (disp "            } def")
    (disp "/DrawSlice {")
    (disp "            /grayshade exch def")
    (disp "            /endangle exch def")
    (disp "            /startangle exch def")
    (disp "            /radius exch def")
    (disp "            gsave")
    (disp "            newpath 0 0 moveto")
    (disp "              0 0 radius startangle endangle arc")
    (disp "            closepath")
    (disp "            grayshade setgray")
    (disp "            fill")
    (disp "            grestore")
    (disp "            } def")
    (disp "/DrawColorSlice {")
    (disp "            /b exch def")
    (disp "            /s exch def")
    (disp "            /h exch def")
    (disp "            /endangle exch def")
    (disp "            /startangle exch def")
    (disp "            /radius exch def")
    (disp "            gsave")
    (disp "            newpath 0 0 moveto")
    (disp "              0 0 radius startangle endangle arc")
    (disp "            closepath")
    (disp "            h s b sethsbcolor")
    (disp "            fill")
    (disp "            grestore")
    (disp "            } def")
    (disp "/DrawColorSliceBorder {")
    (disp "            /b exch def")
    (disp "            /s exch def")
    (disp "            /h exch def")
    (disp "            /endangle exch def")
    (disp "            /startangle exch def")
    (disp "            /radius exch def")
    (disp "            gsave")
    (disp "            newpath 0 0 moveto")
    (disp "              0 0 radius startangle endangle arc")
    (disp "            closepath")
    (disp "            gsave 0 setgray stroke grestore")
    (disp "            h s b sethsbcolor")
    (disp "            fill")
    (disp "            grestore")
    (disp "            } def")
    (disp "/FilledRectangle {")
    (disp "       /y2 exch def /y1 exch def /x2 exch def /x1 exch def")
    (disp "       newpath x1 y1 moveto x1 y2 lineto x2 y2 lineto x2 y1 lineto")
    (disp "       closepath fill } def")
    (disp "/insidecircletext")
    (disp "  { circtextdict begin")
    (disp "    /radius exch def")
    (disp "    /centerangle exch def")
    (disp "    /ptsize exch def")
    (disp "    /str exch def")
    (disp "    /xradius radius ptsize 3 div sub def")
    (disp "    gsave")
    (disp "      centerangle str findhalfangle sub rotate")
    (disp "      str")
    (disp "      { /charcode exch def")
    (disp "        ( ) dup 0 charcode put insideplacechar")
    (disp "      } forall")
    (disp "    grestore")
    (disp "    end")
    (disp "  } def")
    (disp "/leftinsidecircletext")
    (disp "  { circtextdict begin")
    (disp "    /radius exch def")
    (disp "    /centerangle exch def")
    (disp "    /ptsize exch def")
    (disp "    /str exch def")
    (disp "    /xradius radius ptsize 3 div sub def")
    (disp "    gsave")
    (disp "      centerangle rotate")
    (disp "      str")
    (disp "      { /charcode exch def")
    (disp "        ( ) dup 0 charcode put insideplacechar")
    (disp "      } forall")
    (disp "    grestore")
    (disp "    end")
    (disp "  } def")
    (disp "/outsidecircletext")
    (disp "  { circtextdict begin")
    (disp "    /radius exch def")
    (disp "    /centerangle exch def")
    (disp "    /ptsize exch def")
    (disp "    /str exch def")
    (disp "    /xradius radius ptsize 4 div add def")
    (disp "    gsave")
    (disp "      centerangle str findhalfangle add rotate")
    (disp "      str")
    (disp "      { /charcode exch def")
    (disp "        ( ) dup 0 charcode put outsideplacechar")
    (disp "      } forall")
    (disp "    grestore")
    (disp "    end")
    (disp "  } def")
    (disp "/leftoutsidecircletext")
    (disp "  { circtextdict begin")
    (disp "    /radius exch def")
    (disp "    /centerangle exch def")
    (disp "    /ptsize exch def")
    (disp "    /str exch def")
    (disp "    /xradius radius ptsize 4 div add def")
    (disp "    gsave")
    (disp "      centerangle rotate")
    (disp "      str")
    (disp "      { /charcode exch def")
    (disp "        ( ) dup 0 charcode put outsideplacechar")
    (disp "      } forall")
    (disp "    grestore")
    (disp "    end")
    (disp "  } def")
    (disp "/circtextdict 16 dict def")
    (disp "circtextdict begin")
    (disp "  /findhalfangle ")
    (disp "    { stringwidth pop 2 div 2 xradius mul pi mul div 360 mul } def")
    (disp "  /insideplacechar")
    (disp "     { /char exch def")
    (disp "       /halfangle char findhalfangle def")
    (disp "       gsave ")
    (disp "         halfangle rotate radius 0 translate 90 rotate")
    (disp "         char stringwidth pop 2 div neg 0 moveto char show")
    (disp "       grestore")
    (disp "       halfangle 2 mul rotate")
    (disp "     } def")
    (disp "  /outsideplacechar")
    (disp "     { /char exch def")
    (disp "       /halfangle char findhalfangle def")
    (disp "       gsave ")
    (disp "         halfangle neg rotate radius 0 translate -90 rotate")
    (disp "         char stringwidth pop 2 div neg 0 moveto char show")
    (disp "       grestore")
    (disp "       halfangle 2 mul neg rotate")
    (disp "     } def")
    (disp "  /pi 3.1415923 def")
    (disp "end")
    (disp "/filledisotriangle { gsave 5 3 roll translate rotate" )
    (disp "                     exch 2 div dup 3 -1 roll dup 4 1 roll neg" )
    (disp "                     newpath 0 0 moveto lineto neg exch neg lineto" )
    (disp "                     closepath fill grestore } def" )
    (disp "/unfilledisotriangle { gsave 5 3 roll translate rotate" )
    (disp "                       exch 2 div dup 3 -1 roll dup 4 1 roll neg" )
    (disp "                       newpath 0 0 moveto lineto neg exch neg lineto" )
    (disp "                       closepath stroke grestore } def" )
    (disp "" )
    (disp "%%EndProlog")
    (disp "%%BeginSetup")
    (disp "%%EndSetup")
    ))

(define postamble
  (lambda (page_count)
    (disp "%%Trailer" )
    (disp "%%Pages:" page_count)
    (disp "%%EOF")
    ))

(define page-preamble
  (lambda (number)
    (disp "")
    (disp "%%Page:" number number)
    (disp "")
    ))


