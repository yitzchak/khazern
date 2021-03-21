(in-package :khazern)


(defclass list-iterator ()
  ((head-cons
     :accessor head-cons
     :initarg :head-cons
     :initform nil)))


(defmethod pop-head ((instance list-iterator) &optional index)
  (with-slots (head-cons)
              instance
    (if head-cons
      (values (pop head-cons) t)
      (values nil nil))))


(defmethod head ((instance list-iterator) &optional index)
  (with-slots (head-cons)
              instance
    (if head-cons
      (values (car head-cons) t)
      (values nil nil))))


(defmethod (setf head) (new-value (instance list-iterator) &optional index)
  (with-slots (head-cons)
              instance
    (unless head-cons
      (error "iterator is empty"))
    (setf (car head-cons) new-value)))


(defmethod emptyp ((instance list-iterator))
  (null (head-cons instance)))


(defclass plist-iterator ()
  ((head-cons
     :accessor head-cons
     :initarg :head-cons
     :initform nil)))


(defmethod pop-head ((instance plist-iterator) &optional index)
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


(defmethod head ((instance plist-iterator) &optional index)
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


(defmethod (setf head) (new-value (instance plist-iterator) &optional index)
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


(defmethod emptyp ((instance plist-iterator))
  (null (head-cons instance)))


(defclass alist-iterator ()
  ((head-cons
     :accessor head-cons
     :initarg :head-cons
     :initform nil)))


(defmethod pop-head ((instance alist-iterator) &optional index)
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


(defmethod head ((instance alist-iterator) &optional index)
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


(defmethod (setf head) (new-value (instance alist-iterator) &optional index)
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


(defmethod emptyp ((instance alist-iterator))
  (null (head-cons instance)))


(defmethod make-iterator ((instance list) (type (eql :list)))
  (make-instance 'list-iterator :head-cons instance))


(defmethod make-iterator ((instance list) (type (eql :alist)))
  (make-instance 'alist-iterator :head-cons instance))


(defmethod make-iterator ((instance list) (type (eql :plist)))
  (make-instance 'plist-iterator :head-cons instance))


