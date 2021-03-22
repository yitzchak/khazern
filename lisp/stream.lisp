(in-package :khazern)


(defclass stream-iterator ()
  ((input-stream
     :reader input-stream
     :initarg :input-stream)))


(defclass stream-char-iterator (stream-iterator)
  ())


(defmethod pop-head ((instance stream-char-iterator) &optional index)
  (declare (ignore index))
  (let ((ch (read-char (input-stream instance) nil)))
    (values ch (and ch t))))


(defmethod head ((instance stream-char-iterator) &optional index)
  (declare (ignore index))
  (let ((ch (peek-char nil (input-stream instance) nil)))
    (values ch (and ch t))))


(defmethod emptyp ((instance stream-char-iterator))
  (not (peek-char nil (input-stream instance) nil)))


(defmethod make-iterator ((instance stream) (type (eql :char)))
  (declare (ignore type))
  (make-instance 'stream-char-iterator :input-stream instance))


(defclass stream-value-iterator (stream-iterator)
  ((value
     :accessor value
     :initform nil)
   (invalid
     :accessor invalid
     :initform t)))


(defmethod pop-head ((instance stream-value-iterator) &optional index)
  (declare (ignore index))
  (with-slots (input-stream value invalid)
              instance
    (when invalid
      (setf value (read input-stream nil :eof)
            invalid nil))
    (if (eq :eof value)
      (values nil nil)
      (multiple-value-prog1
        (values value t)
        (setf invalid t)))))


(defmethod head ((instance stream-value-iterator) &optional index)
  (declare (ignore index))
  (with-slots (input-stream value invalid)
              instance
    (when invalid
      (setf value (read input-stream nil :eof)
            invalid nil))
    (if (eq :eof value)
      (values nil nil)
      (values value t))))


(defmethod emptyp ((instance stream-value-iterator))
  (with-slots (input-stream value invalid)
              instance
    (when invalid
      (setf value (read input-stream nil :eof)
            invalid nil))
    (eq :eof value)))


(defmethod make-iterator ((instance stream) (type (eql :value)))
  (declare (ignore type))
  (make-instance 'stream-value-iterator :input-stream instance))



