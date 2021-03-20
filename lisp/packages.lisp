(defpackage #:khazern
  (:use #:common-lisp)
  (:documentation "Looping, accumulation and deques.")
  (:export
    #:deque
    #:push-head
    #:pop-head
    #:push-tail
    #:pop-tail
    #:head
    #:tail
    #:emptyp))
