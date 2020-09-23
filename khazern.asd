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
        ((:file "packages"))))
  . #+asdf3
      (:version "0.1"
       :bug-tracker "https://github.com/yitzchak/khazern/issues")
    #-asdf3 ())

