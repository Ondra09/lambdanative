#|

|#

;; pomodoro app test

;; add test for timout prevent negative numbers
;; 

(define gui #f)
(define finalTimer #f)
(define timer-label #f)
(define LONG_BREAK_SECS (* 15 60))
(define SHORT_BREAK_SECS (* 5 60))
(define WORK_SECS (* 25 60))
(define WORK_HISTORY '())

;; (deftype fruit () '(member apple orange banana))

(define-structure work-block time-end finished block-type)
;; (define p (make-work-block 0 #f 0))

(define (add-workblock block)
  (set! WORK_HISTORY (cons block WORK_HISTORY)))

;; (define (next-workblock lst)
;;   ())

(define (get-seconds cur)
  (let ([seconds (/ cur 60)])
    (inexact->exact (truncate (* 60 (- seconds (truncate seconds))))))
  ;; (remainder cur 60)
  )

(define (get-minutes cur)
  (inexact->exact (truncate (/ cur 60))))

(define (get-separator cur)
  (let ([secs (inexact->exact(truncate (* cur 2)))])
    (if (= (modulo secs 2) 1)
	":"
	" "
	)))
(define (two-digitalize seconds)
  (if (= (string-length seconds) 1)
      (string-append "0" seconds)
      seconds))

(define (update-labels)
  (if (and gui finalTimer)
      (let* ([time-diff (time-diff-until finalTimer)]
	     [seconds (two-digitalize (number->string (get-seconds time-diff)))]
	     [minutes (number->string (get-minutes time-diff))]
	     [separator-sym (get-separator time-diff)]
	     )
	(glgui-widget-set! gui timer-label 'label (string-append minutes separator-sym seconds))
	;; (display minutes)
	)
      ;;(display ##now)
      ;; (display "\n")
      ))

(define (time-diff-until until)
  (- until ##now))

(define (button-callback g w t x y)
  (let ((oldcolor (glgui-widget-get g w 'color)))
    (glgui-widget-set! g w 'color (if (= oldcolor White) Red White))
    (set! finalTimer (+ ##now LONG_BREAK_SECS))
    (glgui-widget-set! g timer-label 'label (number->string (time-diff-until finalTimer)))
  ))

(main
;; initialization
  (lambda (w h)
    (make-window 320 480)
    (glgui-orientation-set! GUI_PORTRAIT)
    (set! gui (make-glgui))
    (let* ((w (glgui-width-get))
           (h (glgui-height-get))
           (dim (min (/ w 2) (/ h 2)))
	   (bw 150)
	   (bh 100))
      (glgui-box gui (/ (- w dim) 2) (/ (- h dim) 2) dim dim Red)
      (set! timer-label (glgui-label gui 0 0 200 50 "AAAA B" pomomono_32.fnt White))
      (glgui-button-string gui 50 50 bw bh "Test button" pomoid_24.fnt button-callback))
  )
;; events
  (lambda (t x y) 
    (if (= t EVENT_KEYPRESS)
	(begin
	  (if (= x (char->integer #\A)) (display 'A))
	  (if (= x EVENT_KEYESCAPE) (terminate))
	  ))
    ;;(if (fx= t EVENT_REDRAW) (thread-sleep! 0.05))
    (if (fx= t EVENT_REDRAW) (update-labels))
    (glgui-event gui t x y))
;; termination
  (lambda () #t)
;; suspend
  (lambda () (glgui-suspend))
;; resume
  (lambda () (glgui-resume))
)

;; eof
