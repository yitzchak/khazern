(in-package #:khazern)


(defgeneric push-head (instance new-value))


(defgeneric pop-head (instance))


(defgeneric push-tail (instance new-value))


(defgeneric pop-tail (instance))


(defgeneric head (instance))


(defgeneric (setf head) (new-value instance))


(defgeneric tail (instance))


(defgeneric (setf tail) (new-value instance))


(defgeneric emptyp (instance))
