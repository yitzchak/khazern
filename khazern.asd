(asdf:defsystem #:khazern
  :description "Looping, accumulation and deques."
  :author "Tarn W. Burton"
  :license "MIT"
  :depends-on
    ()
  :components
    ((:module lisp
      :serial t
      :components
        ((:file "packages")
         (:file "interface")
         (:file "deque")
         (:file "list")
         (:file "vector")
         (:file "stream")
         (:file "do"))))
  . #+asdf3
      (:version "0.1"
       :bug-tracker "https://github.com/yitzchak/khazern/issues")
    #-asdf3 ())

