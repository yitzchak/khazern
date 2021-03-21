(in-package #:khazern)


(defgeneric push-head (instance &rest new-values))


(defgeneric pop-head (instance &optional index))


(defgeneric push-tail (instance &rest new-values))


(defgeneric pop-tail (instance &optional index))


(defgeneric head (instance &optional index))


(defgeneric (setf head) (new-value instance &optional index))


(defgeneric tail (instance &optional index))


(defgeneric (setf tail) (new-value instance &optional index))


(defgeneric emptyp (instance))


(defgeneric make-iterator (instance &rest initargs &key head tail &allow-other-keys))

