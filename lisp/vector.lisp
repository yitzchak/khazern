(in-package :khazern)


(defclass vector-value-iterator ()
  ((key
     :accessor key
     :initform 0)
   (reference
     :reader reference
     :initarg :reference)))


(defmethod pop-head ((instance vector-value-iterator) &optional index)
  (assert (null index)
          (index)
    "The index in a vector iterator must be nil.")
  (with-slots (key reference)
              instance
    (if (< key (length reference))
      (multiple-value-prog1
        (values (elt reference key) t)
        (incf key))
      (values nil nil))))


(defmethod head ((instance vector-value-iterator) &optional index)
  (assert (null index)
          (index)
    "The index in a vector iterator must be nil.")
  (elt (reference instance) (key instance)))


(defmethod (setf head) (new-value (instance vector-value-iterator) &optional index)
  (assert (null index)
          (index)
    "The index in a vector iterator must be nil.")
  (setf (elt (reference instance) (key instance)) new-value))


(defmethod emptyp ((instance vector-value-iterator))
  (= (length (reference instance)) (key instance)))


(defclass vector-key-value-iterator (vector-value-iterator)
  ())


(defmethod pop-head ((instance vector-key-value-iterator) &optional index)
  (assert (or (null index)
              (eql 0 index)
              (eql 1 index))
          (index)
    "The index in a vector key-value iterator must be nil, 0 or 1.")
  (with-slots (key reference)
              instance
    (if (< key (length reference))
      (multiple-value-prog1
        (case index
          (0
            (values key t))
          (1
            (values (elt reference key) t))
          (t
            (values (list key (elt reference key)) t)))
        (incf key))
      (values nil nil))))


(defmethod head ((instance vector-key-value-iterator) &optional index)
  (assert (or (null index)
              (eql 0 index)
              (eql 1 index))
          (index)
    "The index in a vector key-value iterator must be nil, 0 or 1.")
  (with-slots (key reference)
              instance
    (cond
      ((>= key (length reference))
        (values nil nil))
      ((eql 0 index)
        (values key t))
      ((eql 1 index)
        (values (elt reference key) t))
      (t
        (values (list key (elt reference key)) t)))))


(defmethod (setf head) (new-value (instance vector-key-value-iterator) &optional index)
  (assert (eql 1 index)
          (index)
    "The index in a vector key-value iterator must be 1.")
  (when (eql 1 index)
    (setf (elt (reference instance) (key instance)) new-value)))


(defmethod make-iterator ((instance vector) (type (eql :value)))
  (make-instance 'vector-value-iterator :reference instance))


(defmethod make-iterator ((instance vector) (type (eql :key-value)))
  (make-instance 'vector-key-value-iterator :reference instance))

