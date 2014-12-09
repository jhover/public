;(require (lib "cmdline.ss"))

;(command-line "vot" (current (args vars))

(write (vector->list (current-command-line-arguments)))
(newline)


