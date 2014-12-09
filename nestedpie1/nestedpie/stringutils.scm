; stringutils.scm
;

(define whitespace?
  (lambda (x) (or (char=? x #\space)
                  (char=? x #\tab)
                  (char=? x #\newline))))

; removes whitespace from end of string
(define trim
  (lambda (str)
    (let tr ( (n (- (string-length str) 1)) )
      (if (and (>= n 0) (whitespace? (string-ref str n)))
          (tr (- n 1))
          (substring str 0 (+ n 1))
          ))))
;
; returns index of first occurance of char ch in string str, 
; -1 if not found
;
(define string-index 
  (lambda (str ch)
    (let ( (n (string-length str)) )
      (let strind ( (i 0) )
        (if (>= i n)
            -1
            (if (char=? ch (string-ref str i))
                i
                (strind (+ i 1))
                ))))))

;
; returns index of first occurance in string str of any chars in charset (list),
;  (string-length str) if not found
;
(define string-index-set
  (lambda (str charset)
    (let ( (n (string-length str)) )
      (let strind ( (i 0) )
        (if (>= i n)
            n
            (if (member (string-ref str i) charset)
                i
                (strind (+ i 1))
                ))))))
;
; returns index of first occurance in string str of a char which is NOT
; in charset (list) - length of string is returned if not found
;  -1 if not found
;
(define string-index-comp-set
  (lambda (str charset)
    (let ( (n (string-length str)) )
      (let strind ( (i 0) )
        (if (>= i n)
            n
            (if (member (string-ref str i) charset)
                (strind (+ i 1))
                i
                ))))))

; skip delimiters, chop off and return word and return remainder
; string
;   (word remainder) <- (fetch-word str delims)
;    or ("" "") if  empty
;
(define fetch-word
  (lambda (str delims)
    (let ( (wstart (string-index-comp-set str delims)) )
      (let ( (t (substring str wstart (string-length str))) )
        (let ( (wstop (string-index-set t delims)) )
          (list (substring t 0 wstop) (substring t wstop (string-length t)) )
          )))))

;
; (split-words "str" delims)
;
(define split-words
  (lambda (str delims)
    (let splw ( (fw (fetch-word str delims)) (sofar '()) )
      (let ( (w (car fw)) (s (cadr fw)) )
        (if (> (string-length w) 0)
            (splw (fetch-word s delims) (cons w sofar))
            (reverse sofar)
            )))))

