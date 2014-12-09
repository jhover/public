; File:         io.scm
; Language:     Scheme (mzScheme)
; Programmer:   Sean R. McCorkle
; Description:  low-level io functions & procedures
;
; $Id: io.scm,v 3.0 2004/11/24 03:26:43 mccorkle Exp mccorkle $
;

;
; (fdisp f a b c ...) - display items a b c to output-port f, with a newline 
;                       at end, space seperated
;
(define fdisp
  (lambda (f . items)
    (let fd ( (its items) )
      (cond ( (null? its)       (newline f)           )
            ( (null? (cdr its)) (display (car its) f)
                                (newline f)           )
            ( else              (display (car its) f)
                                (display " " f)
                                (fd (cdr its))
                                )))))

;
; (disp a b c ...) - display items a b c, newline at end, space seperated
;
(define disp 
   (lambda items 
      (apply fdisp (cons (current-output-port) items))))


