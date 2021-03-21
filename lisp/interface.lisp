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


(defgeneric make-iterator (instance type)
  (:method (instance (type (eql :head)))
    (declare (ignore type))
    instance)
  (:method (instance (type (eql :tail)))
    (declare (ignore type))
    instance))


(defgeneric tail-iterator-p (type)
  (:method (type)
    (declare (ignore type))
    nil)
  (:method ((type (eql :tail)))
    (declare (ignore type))
    t))

