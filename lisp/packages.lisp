(defpackage #:khazern
  (:use #:common-lisp)
  (:documentation "Looping, accumulation and deques.")
  (:export
    #:deque
    #:emptyp
    #:head
    #:pop-head
    #:pop-tail
    #:push-head
    #:push-tail
    #:repeat
    #:tail))

