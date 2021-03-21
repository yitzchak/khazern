(defpackage #:khazern
  (:use #:common-lisp)
  (:documentation "Looping, accumulation and deques.")
  (:export
    #:deque
    #:do!
    #:do!*
    #:emptyp
    #:head
    #:pop-head
    #:pop-tail
    #:push-head
    #:push-tail
    #:tail))

