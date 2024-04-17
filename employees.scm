(define (hourly f l h r)
    (newline)
    (display "Hourly employee: ")
    (display f)
    (display " ")
    (display l)
    (newline)
    (display "hours worked: ")
    (display h)
    (display ", hourly rate: ")
    (display r)
    (newline)
    (display "earned $")
    (display (hourly-earnings h r))
)

(define (hourly-earnings h r)
    (cond
        ((<= h 40) (* h r))
        ((<= h 50) (+ (* 40 r)(*(- h 40)(* r 1.5))))
        (( > h 50) (+ (* 40 r)(* 10 (* r 1.5))(*(- h 50)(* r 2.0))))
    )
)

(define (salaried f l s)
    (newline)
    (display "Salaried employee: ")
    (display f)
    (display " ")
    (display l)
    (newline)
    (display "weekly salary: ")
    (display s)
    (newline)
    (display "earned ")
    (display s)
)

(define (commission f l m s r)
    (newline)
    (display "Commission employee: ")
    (display f)
    (display " ")
    (display l)
    (newline)
    (display "minimum salary: ")
    (display m)
    (display ", sales amount: ")
    (display s)
    (display ", commission rate: ")
    (display (* r 100))
    (display "%")
    (newline)
    (display "earned $")
    (display (commission-earnings m s r))
)

(define (commission-earnings m s r)
    (if (<= (* s r) m)
        m
        (* s r)
    )

)

(define (read-file name)
    (let ((port (open-input-file name))
         (lines '()))
    (define (read-file-helper port lines)
        (let ((line (read-line port)))
        (if (eof-object? line)
        'done
        (begin (cons line lines)
            (read-file-helper port)))))
    (let((result (read-file-helper port lines)))
         (close-input-port port)
         result)
    ))

(define (read-file filename)
(let ((port (open-input-file filename))
      (lines '()))  
  (define (read-lines port lines)
    (let ((line (read-line port)))
      (if (eof-object? line)
          lines
          (read-lines port (cons line lines))))
  )
  (let ((result (read-lines port lines)))
    (close-input-port port)
    result)
  )
)

(define (count lst)
    (display "There are ")
    (display (length lst))
    (display " employees.")
)
(define (avg lst)
    (display "avg")
)
(define (max lst)
    (display "max")
)
(define (min lst)
    (display "min")
)
(define (total lst)
    (let ((value 0))
        (define (total-helper lst)
            (let (
                  (line (parse-string (list-at lst 0))))
              (if (string=? (list-at line 0) "hourly")
                (+ value (hourly-earnings (string->number(list-at line 3)) (string->number(list-at line 4))))
                (if (string=? (list-at line 0) "salaried")
                    (+ value (string->number (list-at line 3)))
                    (if(string=? (list-at line 0) "commission")
                        (+ value (commission-earnings (string->number(list-at line 3)) (string->number(list-at line 4)) (string->number(list-at line 5))))
                    )
                )
              )
              if((=(length lst) 1)
                    value
                    (total-helper (cdr lst))
                )
            )
        )
      (total-helper lst)
    )
)
(define (print lst)
    (display "print")
)

(define (remove_gt lst thr)
    (define (predicate elem)
        (> elem thr))
    (filter predicate lst)
)
(define (remove_ge lst thr)
    (define (predicate elem)
    (>= elem thr))
    (filter predicate lst)
)
(define (remove_ne lst thr)
    (define (predicate elem)
    (not(= elem thr)))
    (filter predicate lst)
)
(define (remove_eq lst thr)
    (define (predicate elem)
    (= elem thr))
    (filter predicate lst)
)
(define (remove_lt lst thr)
    (define (predicate elem)
    (< elem thr))
    (filter predicate lst)
)
(define (remove_le lst thr)
    (define (predicate elem)
    (<= elem thr))
    (filter predicate lst)
)

(define (perform . args)
    (cond
        ((=(length args) 1)
            (display "Usage: (perform employee_file action)")
            (newline)
            (display "or")
            (newline)
            (display "Usage: (perform employee_file action operator threshold)")
            (newline)
            (newline)
            (display "Valid actions: count print min max total avg")
            (newline)
            (display "Valid operators: eq ne gt ge lt le")
            'done
        )
        ((=(length args) 2)
            (display (list-at (read-file (list-at args 0)) 0))
            (newline)
            (let ((currList (read-file (list-at args 0))))
                (execute-action (list-at args 1) currList)
            )
        )
        ((=(length args) 3)
            (display "or")
            (display (list-at args 0))
            (display (list-at args 1))
            (display (list-at args 2))
            'done
        )
        ((=(length args) 4)
            (display "why")
            (display (list-at args 0))
            (display (list-at args 1))
            (display (list-at args 2))
            (display (list-at args 3))
            'done
        )
        (else 
            (display "Invalid Arguments")
            'done
        )
    )
)

(define (execute-action act lst)
    (if(string=? act "print")
        (print lst)
    (if(string=? act "count")
        (count lst)
    (if(string=? act "max")
        (max lst)
    (if(string=? act "min")
        (min lst)
    (if(string=? act "avg")
        (avg lst)
    (if(string=? act "total")
        (total lst)
    ))))))
)

(define (list-at lst index)
(if (= index 0)
    (car lst)
    (list-at (cdr lst) (- index 1))))

(define (parse-string input-string)
    (define (parse-string-helper str start-index current-word result-list)
    (if (>= start-index (string-length str))
        (if (not (string-null? current-word))
            (reverse (cons current-word result-list))
            (reverse result-list))
        (let ((current-char (string-ref str start-index)))
            (if (or (char=? current-char #\space)
                    (char=? current-char #\tab)
                    (char=? current-char #\newline)
                    (char=? current-char #\return))
                (parse-string-helper str (+ start-index 1) "" (cons current-word result-list))
                (parse-string-helper str (+ start-index 1) (string-append current-word (string current-char)) result-list))))
    )
    (parse-string-helper input-string 0 "" '())
)