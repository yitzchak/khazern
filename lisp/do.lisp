(in-package :khazern)


(defun make-do (base decls end-form body)
  (let ((gen-vars (mapcar (lambda (decl &aux (var (first decl))
                                             (step-form (third decl)))
                             (when (or (listp var) ; create gensyms for all the iteration or multiple value declarations.
                                       (keywordp step-form))
                               (gensym)))
                           decls)))
    `(symbol-macrolet ,(mapcan (lambda (decl gen-var &aux (var (first decl))
                                                          (step-form (third decl)))
                                 (cond
                                   ((keywordp step-form) ; For the iteration declarations make a symbol macro that binds to head/tail
                                     (let ((iter-func (if (tail-iterator-p step-form) 'tail 'head)))
                                       (if (listp var)
                                         (loop for sub in var
                                               for index from 0
                                               collect `(,sub (,iter-func ,gen-var ,index)))
                                         `((,var (,iter-func ,gen-var))))))
                                   (gen-var ; For the multiple value declarations make a symbol macro that binds to nth
                                     (loop for sub in var
                                           for index from 0
                                           collect `(,sub (nth ,index ,gen-var))))))
                                decls
                                gen-vars)
       (,base ,(mapcar (lambda (decl gen-var &aux (var (first decl))
                                                  (init-form (second decl))
                                                  (step-form (third decl)))
                         (cond
                           ((keywordp step-form) ; iteration declaration
                             `(,gen-var (make-iterator ,init-form ,step-form)
                                        (progn
                                          (,(if (tail-iterator-p step-form) 'pop-tail 'pop-head) ,gen-var)
                                          ,gen-var)))
                           ((and gen-var
                                 (cddr decl)) ; multiple value declation with a step form
                             `(,gen-var (multiple-value-list ,init-form) (multiple-value-list ,step-form)))
                           (gen-var ; multiple value declation with no step form
                             `(,gen-var (multiple-value-list ,init-form)))
                           (t ; normal declaration
                             decl)))
                       decls
                       gen-vars)
              ((or ,(first end-form)
                   ,@(mapcan (lambda (decl gen-var &aux (step-form (third decl)))
                               (when (keywordp step-form)
                                 `((emptyp ,gen-var))))
                              decls
                              gen-vars))
               ,@(cdr end-form))
            ,@body))))


(defmacro do! (decls end-form &body body)
  (make-do 'do decls end-form body))


(defmacro do!* (decls end-form &body body)
  (make-do 'do* decls end-form body))

                   
