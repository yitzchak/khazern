(in-package :khazern)


(defstruct deque-item
  value
  (previous nil)
  (next nil))


(defclass deque ()
  ((head-item
     :accessor head-item
     :initform nil)
   (tail-item
     :accessor tail-item
     :initform nil)))


(defmethod push-head ((instance deque) &rest new-values)
  (assert (= 1 (length new-values))
          (new-values)
    "Only one value is permitted to be pushed into a deque.")
  (with-slots (head-item tail-item)
              instance
    (let ((new-item (make-deque-item :value (car new-values) :next head-item)))
      (when head-item
        (setf (deque-item-previous head-item) new-item))
      (setf head-item new-item)
      (unless tail-item
        (setf tail-item head-item))
      instance)))


(defmethod pop-head ((instance deque) &optional index)
  (assert (null index)
          (index)
    "Only one value is permitted to be pushed into a deque hence a non-null index is meaningless.")
  (with-slots (head-item tail-item)
              instance
    (if head-item
      (multiple-value-prog1
        (values (deque-item-value head-item) t)
        (if (deque-item-next head-item)
          (setf head-item (deque-item-next head-item))
          (setf head-item nil
                tail-item nil)))
      (values nil nil))))


(defmethod push-tail ((instance deque) &rest new-values)
  (assert (= 1 (length new-values))
          (new-values)
    "Only one value is permitted to be pushed into a deque.")
  (with-slots (head-item tail-item)
              instance
    (let ((new-item (make-deque-item :value (car new-values) :previous tail-item)))
      (when tail-item
        (setf (deque-item-next tail-item) new-item))
      (setf tail-item new-item)
      (unless head-item
        (setf head-item tail-item))
      instance)))


(defmethod pop-tail ((instance deque) &optional index)
  (assert (null index)
          (index)
    "Only one value is permitted to be pushed into a deque hence a non-null index is meaningless.")
  (with-slots (head-item tail-item)
              instance
    (if tail-item
      (multiple-value-prog1
        (values (deque-item-value tail-item) t)
        (if (deque-item-previous tail-item)
          (setf tail-item (deque-item-previous tail-item))
          (setf head-item nil
                tail-item nil)))
      (values nil nil))))


(defmethod head ((instance deque) &optional index)
  (assert (null index)
          (index)
    "Only one value is permitted to be pushed into a deque hence a non-null index is meaningless.")
  (with-slots (head-item)
              instance
    (if head-item
      (values (deque-item-value head-item) t)
      (values nil nil))))


(defmethod (setf head) (new-value (instance deque) &optional index)
  (assert (null index)
          (index)
    "Only one value is permitted to be pushed into a deque hence a non-null index is meaningless.")
  (with-slots (head-item)
              instance
    (unless head-item
      (error "deque is empty"))
    (setf (deque-item-value head-item) new-value)))


(defmethod tail ((instance deque) &optional index)
  (assert (null index)
          (index)
    "Only one value is permitted to be pushed into a deque hence a non-null index is meaningless.")
  (with-slots (tail-item)
              instance
    (if tail-item
      (values (deque-item-value tail-item) t)
      (values nil nil))))


(defmethod (setf tail) (new-value (instance deque) &optional index)
  (assert (null index)
          (index)
    "Only one value is permitted to be pushed into a deque hence a non-null index is meaningless.")
  (with-slots (tail-item)
              instance
    (unless tail-item
      (error "deque is empty"))
    (setf (deque-item-value tail-item) new-value)))


(defmethod emptyp ((instance deque))
  (null (head-item instance)))
