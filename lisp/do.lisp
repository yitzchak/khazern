(in-package :khazern)


(defun make-do (base decls end-form body)
  (let ((iter-vars (mapcar (lambda (decl &aux (step-form (third decl)))
                             (when (keywordp step-form)
                               (gensym)))
                           decls)))
    `(symbol-macrolet ,(mapcan (lambda (decl iter-var &aux (var (first decl)) (step-form (third decl)))
                                 (when (keywordp step-form)
                                   (let ((iter-func (if (tail-iterator-p step-form) 'tail 'head)))
                                     (if (listp var)
                                       (loop for sub in var
                                             for index from 0
                                             collect `(,sub (,iter-func ,iter-var ,index)))
                                       `((,var (,iter-func ,iter-var)))))))
                                decls
                                iter-vars)
       (,base ,(mapcar (lambda (decl iter-var &aux (init-form (second decl)) (step-form (third decl)))
                         (if (keywordp step-form)
                           `(,iter-var (make-iterator ,init-form ,step-form)
                                       (progn
                                         (,(if (tail-iterator-p step-form) 'pop-tail 'pop-head) ,iter-var)
                                         ,iter-var))
                            decl))
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

                   
