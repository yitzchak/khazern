(in-package :khazern)


(defun make-do (base decls end-form body)
  (let ((iter-vars (mapcar (lambda (decl)
                             (when (member (second decl) '(:pop-head :pop-tail :from-head :from-tail))
                               (gensym)))
                           decls)))
    `(symbol-macrolet ,(mapcan (lambda (decl iter-var)
                                 (case (second decl)
                                   ((:pop-head :from-head)
                                     (if (listp (first decl))
                                       (loop for sub in (first decl)
                                             for index from 0
                                             collect `(,sub (head ,iter-var ,index)))
                                       `((,(first decl) (head ,iter-var)))))
                                   ((:pop-tail :from-tail)
                                     (if (listp (first decl))
                                       (loop for sub in (first decl)
                                             for index from 0
                                             collect `(,sub (tail ,iter-var ,index)))
                                       `((,(first decl) (tail ,iter-var)))))))
                                decls
                                iter-vars)
       (,base ,(mapcar (lambda (decl iter-var)
                         (case (second decl)
                           (:pop-head
                             `(,iter-var ,(third decl) (progn (pop-head ,iter-var) ,iter-var)))
                           (:pop-tail
                             `(,iter-var ,(third decl) (progn (pop-tail ,iter-var) ,iter-var)))
                           (:from-head
                             `(,iter-var (make-iterator ,(third decl) :head t ,@(cdddr decl)) (progn (pop-head ,iter-var) ,iter-var)))
                           (:from-tail
                             `(,iter-var (make-iterator ,(third decl) :tail t ,@(cdddr decl)) (progn (pop-tail ,iter-var) ,iter-var)))
                           (otherwise
                             decl)))
                       decls
                       iter-vars)
              ((or ,(first end-form)
                   ,@(mapcan (lambda (iter-var)
                               (when iter-var
                                 `((emptyp ,iter-var))))
                              iter-vars))
               ,@(cdr end-form))
            ,@body))))


(defmacro do! (decls end-form &body body)
  (make-do 'do decls end-form body))


(defmacro do!* (decls end-form &body body)
  (make-do 'do* decls end-form body))

                   
