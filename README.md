# khazern

## do! Examples

Iterate over a list but terminate as soon as the item is equal to 3.

```
* (do! ((a '(1 2 3 4) :value))
       ((eql a 3) a)
    (format t "value: ~a~%" a))
value: 1
value: 2
3
T
```

Iterate over a plist with no termination test beyond the automatic list end.

```
* (do! (((k v) '(:fu 1 :bar 2 :wibble 3) :plist-key-value))
       ()
    (format t "key: ~a, value: ~a~%" k v))
key: FU, value: 1
key: BAR, value: 2
key: WIBBLE, value: 3
NIL
```

Iterate over an alist with no termination test beyond the automatic list end.

```
* (do! (((k v) '((:fu . 1) (:bar . 2) (:wibble . 3)) :alist-key-value))
       ()
    (format t "key: ~a, value: ~a~%" k v))
key: FU, value: 1
key: BAR, value: 2
key: WIBBLE, value: 3
NIL
```

Iterate over a plist and set one of the values.

```
* (defparameter a `(:fu 1 :bar 2 :wibble 3))
A
* (do! (((k v) a :plist-key-value))
       ()
    (format t "Initial key: ~a, value: ~a~%" k v)
    (when (eq k :bar)
      (setf v 743))
    (format t "Final key: ~a, value: ~a~%" k v))
Initial key: FU, value: 1
Final key: FU, value: 1
Initial key: BAR, value: 2
Final key: BAR, value: 743
Initial key: WIBBLE, value: 3
Final key: WIBBLE, value: 3
NIL
* a
(:FU 1 :BAR 743 :WIBBLE 3)
```

Create a deque and use pop-head to empty it.

```
* (defparameter a (make-instance 'deque))
A
* (push-head a 1)
#<DEQUE {1001F5BAD3}>
* (push-head a 2)
#<DEQUE {1001F5BAD3}>
* (push-head a 3)
#<DEQUE {1001F5BAD3}>
* (do! ((s a :head))    
       ()
    (format t "value: ~a~%" s))
value: 3
value: 2
value: 1
NIL
* (emptyp a)
T
```

Now use pop-tail instead.

```
* (defparameter a (make-instance 'deque))
A
* (push-head a 1)
#<DEQUE {1001F9DD93}>
* (push-head a 2)
#<DEQUE {1001F9DD93}>
* (push-head a 3)
#<DEQUE {1001F9DD93}>
* (do! ((s a :tail))
       ()
    (format t "value: ~a~%" s))
value: 1
value: 2
value: 3
NIL
* (emptyp a)
T
```

Use multiple value binding in a normal `do` declaration.

```
* (do!* ((n '(10 37 743) :value)
         (d '(4   8  23) :value)
         ((q r) (when n (floor n d)) (when n (floor n d))))
        ()
    (format t "(floor ~a ~a) => (~a ~a)~%" n d q r))
(floor 10 4) => (2 2)
(floor 37 8) => (4 5)
(floor 743 23) => (32 7)
NIL
```

