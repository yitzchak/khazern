(in-package :khazern)


(defclass list-value-iterator ()
  ((head-cons
     :accessor head-cons
     :initarg :head-cons
     :initform nil)))


(defmethod pop-head ((instance list-value-iterator) &optional index)
  (with-slots (head-cons)
              instance
    (if head-cons
      (values (pop head-cons) t)
      (values nil nil))))


(defmethod head ((instance list-value-iterator) &optional index)
  (with-slots (head-cons)
              instance
    (if head-cons
      (values (car head-cons) t)
      (values nil nil))))


(defmethod (setf head) (new-value (instance list-value-iterator) &optional index)
  (with-slots (head-cons)
              instance
    (unless head-cons
      (error "iterator is empty"))
    (setf (car head-cons) new-value)))


(defmethod emptyp ((instance list-value-iterator))
  (null (head-cons instance)))


(defclass list-key-value-iterator (list-value-iterator)
  ((key
     :accessor key
     :initform 0)))


(defmethod pop-head ((instance list-key-value-iterator) &optional index)
  (with-slots (head-cons key)
              instance
    (cond
      ((null head-cons)
        (values nil nil))
      ((eql 0 index)
        (multiple-value-prog1
          (values key t)
          (pop head-cons)
          (incf key)))
      ((eql 1 index)
        (multiple-value-prog1
          (values (pop head-cons) t)
          (incf key)))
      (t
        (multiple-value-prog1
          (values (list key (pop head-cons)) t)
          (incf key))))))


(defmethod head ((instance list-key-value-iterator) &optional index)
  (with-slots (head-cons key)
              instance
    (cond
      ((null head-cons)
        (values nil nil))
      ((eql 0 index)
        (values key t))
      ((eql 1 index)
        (values (car head-cons) t))
      (t
        (values (list key (car head-cons)) t)))))


(defmethod (setf head) (new-value (instance list-key-value-iterator) &optional index)
  (with-slots (head-cons)
              instance
    (unless head-cons
      (error "iterator is empty"))
    (setf (car head-cons) new-value)))


(defclass plist-value-iterator ()
  ((head-cons
     :accessor head-cons
     :initarg :head-cons
     :initform nil)))


(defmethod pop-head ((instance plist-value-iterator) &optional index)
  (assert (or (null index)
              (eql 0 index)
              (eql 1 index))
          (index)
    "The index in a plist iterator must be nil, 0 or 1.")
  (with-slots (head-cons)
              instance
    (cond
      ((null head-cons)
        (values nil nil))
      ((eql index 0)
        (multiple-value-prog1
          (values (pop head-cons) t)
          (pop head-cons)))
      ((eql index 1)
        (pop head-cons)
        (values (pop head-cons) t))
      (t
        (values (cons (pop head-cons) (pop head-cons)) t)))))


(defmethod head ((instance plist-value-iterator) &optional index)
  (assert (or (null index)
              (eql 0 index)
              (eql 1 index))
          (index)
    "The index in a plist iterator must be nil, 0 or 1.")
  (with-slots (head-cons)
              instance
    (cond
      ((null head-cons)
        (values nil nil))
      ((eql index 0)
        (values (car head-cons) t))
      ((eql index 1)
        (values (cadr head-cons) t))
      (t
        (values (list (car head-cons) (cadr head-cons)) t)))))


(defmethod (setf head) (new-value (instance plist-value-iterator) &optional index)
  (assert (or (null index)
              (eql 0 index)
              (eql 1 index))
          (index)
    "The index in a plist iterator must be nil, 0 or 1.")
  (with-slots (head-cons)
              instance
    (cond
      ((null head-cons)
        (error "iterator is empty"))
      ((eql index 0)
        (setf (car head-cons) new-value))
      ((eql index 1)
        (setf (cadr head-cons) new-value))
      (t
        (setf (car head-cons) (car new-value)
              (cadr head-cons) (cadr new-value))))))


(defmethod emptyp ((instance plist-value-iterator))
  (null (head-cons instance)))


(defclass alist-value-iterator ()
  ((head-cons
     :accessor head-cons
     :initarg :head-cons
     :initform nil)))


(defmethod pop-head ((instance alist-value-iterator) &optional index)
  (assert (or (null index)
              (eql 0 index)
              (eql 1 index))
          (index)
    "The index in a alist iterator must be nil, 0 or 1.")
  (with-slots (head-cons)
              instance
    (cond
      ((null head-cons)
        (values nil nil))
      ((eql index 0)
        (values (car (pop head-cons)) t))
      ((eql index 1)
        (values (cdr (pop head-cons)) t))
      (t
        (multiple-value-prog1
          (values (list (caar head-cons) (cdar head-cons)) t)
          (pop head-cons))))))


(defmethod head ((instance alist-value-iterator) &optional index)
  (assert (or (null index)
              (eql 0 index)
              (eql 1 index))
          (index)
    "The index in a alist iterator must be nil, 0 or 1.")
  (with-slots (head-cons)
              instance
    (cond
      ((null head-cons)
        (values nil nil))
      ((eql index 0)
        (values (caar head-cons) t))
      ((eql index 1)
        (values (cdar head-cons) t))
      (t
        (values (list (caar head-cons) (cdar head-cons)) t)))))


(defmethod (setf head) (new-value (instance alist-value-iterator) &optional index)
  (assert (or (null index)
              (eql 0 index)
              (eql 1 index))
          (index)
    "The index in a alist iterator must be nil, 0 or 1.")
  (with-slots (head-cons)
              instance
    (cond
      ((null head-cons)
        (error "iterator is empty"))
      ((eql index 0)
        (setf (caar head-cons) new-value))
      ((eql index 1)
        (setf (cdar head-cons) new-value))
      (t
        (setf (car head-cons) (cons (car new-value) (cadr new-value)))))))


(defmethod emptyp ((instance alist-value-iterator))
  (null (head-cons instance)))


(defmethod make-iterator ((instance list) (type (eql :value)))
  (make-instance 'list-value-iterator :head-cons instance))


(defmethod make-iterator ((instance list) (type (eql :key-value)))
  (make-instance 'list-key-value-iterator :head-cons instance))


(defmethod make-iterator ((instance list) (type (eql :alist-key-value)))
  (make-instance 'alist-value-iterator :head-cons instance))


(defmethod make-iterator ((instance list) (type (eql :plist-key-value)))
  (make-instance 'plist-value-iterator :head-cons instance))


