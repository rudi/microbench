;;;; Copyright (c) 2012 Nikodemus Siivola <nikodemus@random-state.net>
;;;;
;;;; Permission is hereby granted, free of charge, to any person
;;;; obtaining a copy of this software and associated documentation files
;;;; (the "Software"), to deal in the Software without restriction,
;;;; including without limitation the rights to use, copy, modify, merge,
;;;; publish, distribute, sublicense, and/or sell copies of the Software,
;;;; and to permit persons to whom the Software is furnished to do so,
;;;; subject to the following conditions:
;;;;
;;;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
;;;; EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
;;;; MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
;;;; IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
;;;; CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
;;;; TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
;;;; SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

(in-package :microbench)

;;;; VARARG RITHMETIC

(defun vararg2 (fun a b)
  (declare (function fun))
  (declare (optimize (speed 3) (safety 0)))
  (funcall fun a b))

(defun vararg4 (fun a b c d)
  (declare (function fun))
  (declare (optimize (speed 3) (safety 0)))
  (funcall fun a b c d))

(defun vararg8 (fun a b c d e f g h)
  (declare (function fun))
  (declare (optimize (speed 3) (safety 0)))
  (funcall fun a b c d e f g h))

(defbenchmark vararg+[ff] (:group vararg+)
  (vararg2 #'+ 123 907))

(defbenchmark vararg+[ffff] (:group vararg+)
  (vararg4 #'+ 121 -9 897 182736))

(defbenchmark vararg+[ffffffff] (:group vararg+)
  (vararg8 #'+ 121 -9 897 182736 -291837 123987 123 -123))

(defbenchmark vararg+[ss] (:group vararg+)
  (vararg2 #'+ 123.0f0 907.0f0))

(defbenchmark vararg+[ssss] (:group vararg+)
  (vararg4 #'+ 121.0f0 -9.0f0 897.0f0 182736.0f0))

(defbenchmark vararg+[ssssssss] (:group vararg+)
  (vararg8 #'+ 121.0f0 -9.0f0 897.0f0 182736.0f0 -291837.0f0 123987.0f0 123.0f0 -123.0f0))

(defbenchmark vararg+[dd] (:group vararg+)
  (vararg2 #'+ 123.0d0 907.0d0))

(defbenchmark vararg+[dddd] (:group vararg+)
  (vararg4 #'+ 121.0d0 -9.0d0 897.0d0 182736.0d0))

(defbenchmark vararg+[dddddddd] (:group vararg+)
  (vararg8 #'+ 121.0d0 -9.0d0 897.0d0 182736.0d0 -291837.0d0 123987.0d0 123.0d0 -123.0d0))

(defbenchmark vararg+[fd] (:group vararg+)
  (vararg2 #'+ 123 907.0d0))

(defbenchmark vararg+[fsdf] (:group vararg+)
  (vararg4 #'+ 121 -9.0f0 897.0d0 182736))

(defbenchmark vararg+[fsdfsdfs] (:group vararg+)
  (vararg8 #'+ 121 -9.0f0 897.0d0 182736 -291837.0f0 123987.0d0 123 -123.0f0))

;;;; GENERIC ARITHMETIC

(defun generic+ (x y)
  (+ x y))

(defbenchmark generic+[fff] (:group generic+)
  (generic+ 13212 9283))

(defbenchmark generic+[ffb] (:group generic+)
  (generic+ 123 most-positive-fixnum))

(defbenchmark generic+[fbf] (:group generic+)
  (generic+ most-negative-fixnum #.(+ 123 most-positive-fixnum)))

(defbenchmark generic+[fbb] (:group generic+)
  (generic+ 123 #.(+ 1203981 most-positive-fixnum)))

(defbenchmark generic+[bbb] (:group generic+)
  (generic+ #.(+ 123 most-positive-fixnum)
            #.(* 2 most-positive-fixnum)))

(defbenchmark generic+[bbf] (:group generic+)
  (generic+ #.(+ most-positive-fixnum 1000)
            #.(- most-negative-fixnum 1000)))

(defbenchmark generic+[sss] (:group generic+)
  (generic+ 123.0f0 129387.0f0))

(defbenchmark generic+[fss] (:group generic+)
  (generic+ 123 129387.1f0))

(defbenchmark generic+[ddd] (:group generic+)
  (generic+ 123.9d0 129387.1d0))

(defbenchmark generic+[fdd] (:group generic+)
  (generic+ 123 129387.12d0))

(defbenchmark generic+[sdd] (:group generic+)
  (generic+ 123.1f0 129387.13d0))

(defbenchmark generic+[cfcfcf] (:group generic+)
  (generic+ #c(12 123) #c(987 231)))

(defbenchmark generic+[cscscs] (:group generic+)
  (generic+ #c(12.123f0 123.123f0) #c(987.987f0 231.231f0)))

(defbenchmark generic+[cdcdcd] (:group generic+)
  (generic+ #c(12.123d0 123.123d0) #c(987.987d0 231.231d0)))

;;;; SPECIALIZED ARITHMETIC

(defun fixnum+ (x y)
  (declare (fixnum x y))
  (+ x y))

(defbenchmark fixnum+ (:group specialized+)
  (fixnum+ 1239 1098))

(defun modular-fixnum+ (x y)
  (declare (fixnum x y))
  (logand most-positive-fixnum (+ x y)))

(defbenchmark modular-fixnum+ (:group specialized+)
  (modular-fixnum+ 1239 1098))

(defun complex-single+ (x y)
  (declare (type (complex single-float) x y))
  (+ x y))

(defbenchmark complex-single+ (:group specialized+)
  (complex-single+ #c(12.123f0 123.123f0) #c(987.987f0 231.231f0)))

(defun complex-double+ (x y)
  (declare (type (complex double-float) x y))
  (+ x y))

(defbenchmark complex-double+ (:group specialized+)
  (complex-double+ #c(12.123d0 123.123d0) #c(987.987d0 231.231d0)))

(defun single+ (x y)
  (declare (single-float x y))
  (+ x y))

(defbenchmark single+ (:group specialized+)
  (single+ 123.123f0 534.534f0))

(defun double+ (x y)
  (declare (double-float x y))
  (+ x y))

(defbenchmark double+ (:group specialized+)
  (double+ 411.1231d0 897.1231d0))

(defun double-sans-result+ (x y)
  (declare (double-float x y))
  (= 0.0d0 (+ x y)))

(defbenchmark double-sans-result+ (:group specialized+)
  (double-sans-result+ 123.123d0 9870.213d0))

(defun double-unsafe-sans-result+ (x y)
  (declare (double-float x y)
           (optimize (safety 0) (speed 3)))
  (= 0.0d0 (+ x y)))
(defbenchmark double-unsafe-sans-result+ (:group specialized+)
  (double-unsafe-sans-result+ 123.123d0 9870.213d0))

;;; This is a faintly ridiculous amount of work to get a "fair"
;;; comparison to benchmarks doing out-of-line calls, but seems about
;;; right -- for SBCL.
;;;
;;; For CCL at least this is a /huge/ pessimization, possibly due to
;;; the THROW?
;;;
;;; All this really does is goes to show that we need a decent
;;; non-micro benchmark for FP.
(declaim (notinline a-single-float))
(defun a-single-float ()
  (load-time-value 123.123f0))
(declaim (inline single-inline+))
(defun single-inline+ (x y)
  (declare (single-float x y))
  (+ x y))
(defbenchmark single-inline+ (:group specialized+
                              :let ((x (a-single-float))
                                    (y (a-single-float)))
                              :declare ((single-float x y)))
  (when (= 0.0f0 (setf x (single-inline+ x y)))
    (throw 'oops t)))

(declaim (notinline a-complex-single-float))
(defun a-complex-single-float ()
  (load-time-value (complex 534.123f0 123.123f0)))
(declaim (inline complex-single-inline+))
(defun complex-single-inline+ (x y)
  (declare (type (complex single-float) x y))
  (+ x y))
(defbenchmark complex-single-inline+ (:group specialized+
                                      :let ((x (a-complex-single-float))
                                            (y (a-complex-single-float)))
                                      :declare ((type (complex single-float) x y)))
  (when (= #c(0.0f0 0.0f0) (setf x (complex-single-inline+ x y)))
    (throw 'oops t)))

(declaim (notinline a-double-float))
(defun a-double-float ()
  (load-time-value 123.123d0))
(declaim (inline double-inline+))
(defun double-inline+ (x y)
  (declare (double-float x y))
  (+ x y))
(defbenchmark double-inline+ (:group specialized+
                              :let ((x (a-double-float))
                                    (y (a-double-float)))
                              :declare ((double-float x y)))
  (when (= 0.0d0 (setf x (double-inline+ x y)))
    (throw 'oops t)))

(declaim (notinline a-complex-double-float))
(defun a-complex-double-float ()
  (load-time-value (complex 534.123d0 123.123d0)))
(declaim (inline complex-double-inline+))
(defun complex-double-inline+ (x y)
  (declare (type (complex double-float) x y))
  (+ x y))
(defbenchmark complex-double-inline+ (:group specialized+
                                      :let ((x (a-complex-double-float))
                                            (y (a-complex-double-float)))
                                      :declare ((type (complex double-float) x y)))
  (when (= #c(0.0d0 0.0d0) (setf x (complex-double-inline+ x y)))
    (throw 'oops t)))

(declaim (notinline a-fixnum))
(defun a-fixnum ()
  1)
(declaim (inline fixnum-inline+))
(defun fixnum-inline+ (x y)
  (declare (fixnum x y))
  (+ x y))
(defbenchmark fixnum-inline+ (:group specialized+
                              :let ((x (a-fixnum))
                                    (y (a-fixnum)))
                              :declare ((fixnum x y)))
  (when (eql 0 (setf x (fixnum-inline+ x y)))
    (throw 'oops t)))
(defbenchmark modular-fixnum-inline+ (:group specialized+
                              :let ((x (a-fixnum))
                                    (y (a-fixnum)))
                              :declare ((fixnum x y)))
  (when (eql 0 (setf x (logand most-positive-fixnum (fixnum-inline+ x y))))
    (throw 'oops t)))

;;;; GENERIC FUNCTION CALLS

(defun gf-call.0.1 (a)
  a)
(defbenchmark gf-call.0.1 (:group gf-call)
  (gf-call.0.1 t)
  (gf-call.0.1 nil))

(defun gf-call.0.2 (a b)
  (declare (ignore a))
  b)
(defbenchmark gf-call.0.2 (:group gf-call)
  (gf-call.0.2 t nil)
  (gf-call.0.2 nil t))

(defun gf-call.0.5 (a b c d e)
  (declare (ignore b c d e))
  a)
(defbenchmark gf-call.0.5 (:group gf-call)
  (gf-call.0.5 t t t t t)
  (gf-call.0.5 nil nil nil nil nil))

(defgeneric gf-call.1.1 (a))
(defmethod gf-call.1.1 (a)
  a)
(defbenchmark gf-call.1.1 (:group gf-call)
  (gf-call.1.1 t)
  (gf-call.1.1 nil))

(defgeneric gf-call.1.5 (a b c d e))
(defmethod gf-call.1.5 (a b c d e)
  (declare (ignore b c d e))
  a)
(defbenchmark gf-call.1.5 (:group gf-call)
  (gf-call.1.5 t t t t t)
  (gf-call.1.5 nil nil nil nil nil))

(defgeneric gf-call.2b.1 (a))
(defmethod gf-call.2b.1 ((a cons))
  a)
(defmethod gf-call.2b.1 (a)
  a)
(defbenchmark gf-call.2b.1 (:group gf-call
                            :let ((x (cons t t))))
  (gf-call.2b.1 x)
  (gf-call.2b.1 t))

(defclass c1 ()
  ())
(defvar *c1* (make-instance 'c1))
(defclass c2 ()
  ())
(defvar *c2* (make-instance 'c2))
(defgeneric gf-call.2c.1 (a))
(defmethod gf-call.2c.1 ((a c1))
  a)
(defmethod gf-call.2c.1 ((a c2))
  a)
(defbenchmark gf-call.2c.1 (:group gf-call
                            :let ((c1 *c1*)
                                  (c2 *c2*)))
  (gf-call.2c.1 c1)
  (gf-call.2c.1 c2))

;;;; CONSTANT VALUE GENERICS

(defmacro define-constants (n)
  (let ((fun (intern (format nil "GET-~A-CONSTANT" n)))
        (test (intern (format nil "~A-CONSTANT-TEST" n)))
        (var (intern (format nil "*~A-CONSTANT-CLASSES*" n)))
        (classes nil))
    `(progn
       (defgeneric ,fun (x))
       ,@(loop for i from 1 upto n
               collect (let ((class (intern (format nil "CONSTANT-CLASS-~S" i))))
                         (push class classes)
                         `(progn
                            (defclass ,class () ())
                            (defmethod ,fun ((,class ,class))
                              ,(random most-positive-fixnum)))))
       (defvar ,var (mapcar #'make-instance
                            ',classes))
       (defun ,test (list)
         (dolist (elt list)
           (,fun elt)))
       (,test ,var)
       (,test ,var)
       (,test ,var)
       (defbenchmark ,test (:group gf-calls-misc
                            :let ((list ,var)))
         (,test list)))))

(define-constants 1)
(define-constants 2)
(define-constants 3)
(define-constants 4)
(define-constants 5)
(define-constants 6)
(define-constants 7)
(define-constants 8)
(define-constants 16)
(define-constants 32)
(define-constants 64)
(define-constants 128)
(define-constants 512)

;;; ...with 2 args
(defmacro define-constants/2 (n)
  (let ((fun (intern (format nil "GET-~A-CONSTANT/2" n)))
        (test (intern (format nil "~A-CONSTANT-TEST/2" n)))
        (var (intern (format nil "*~A-CONSTANT-TEST/2*" n)))
        (classes nil))
    `(progn
       (defgeneric ,fun (x y))
       ,@(loop for i from 1 upto n
               collect (let ((class1
                              (intern (format nil "CONSTANT/2-CLASS-~S.1" i)))
                             (class2
                              (intern (format nil "CONSTANT/2-CLASS-~S.2" i))))
                         (push (cons class1 class2) classes)
                         `(progn
                            (defclass ,class1 () ())
                            (defclass ,class2 () ())
                            (defmethod ,fun ((,class1 ,class1) (,class2 ,class2))
                              ,(random most-positive-fixnum)))))
       (defvar ,var
         (mapcar (lambda (pair)
                   (cons (make-instance (car pair))
                         (make-instance (cdr pair))))
                 '(,@classes)))
       (defun ,test (list)
         (dolist (pair list)
           (,fun (car pair) (cdr pair))))
       (defbenchmark ,test (:group gf-calls-misc
                            :let ((list ,var)))
         (,test list)))))

(define-constants/2 1)
(define-constants/2 2)
(define-constants/2 3)
(define-constants/2 4)
(define-constants/2 5)
(define-constants/2 6)
(define-constants/2 7)
(define-constants/2 8)
(define-constants/2 16)
(define-constants/2 32)
(define-constants/2 64)
(define-constants/2 128)
(define-constants/2 512)

;;;; SLOT ACCESSORS

(declaim (notinline opaque))
(defun opaque (x) x)

;;; N classes, 1 slot location, one accessor generic
(defmacro define-n-classes (n)
  (let ((slot (format-symbol *package* "N-CLASSES.~A.SLOT" n))
        (var (format-symbol *package* "*N-CLASSES.~A-INSTANCES*" n))
        (test (format-symbol *package* "N-CLASSES.~A-RUN" n)))
    `(progn
      ,@(loop for i from 1 upto n
              collect `(defclass ,(format-symbol *package* "N-CLASSES.~A-CLASS.~A" n i)
                           ()
                         ((,slot
                           :initform (random most-positive-fixnum)
                           :accessor ,slot))))
      (defvar ,var
        (loop for i from 1 upto ,n
                  collect
                 (make-instance (format-symbol *package* "N-CLASSES.~A-CLASS.~A" ,n i))))
      (defun ,test (list)
        (dolist (elt list)
          (opaque (,slot elt))
          (setf (,slot elt) 42)))
      (,test ,var)
      (,test ,var)
      (,test ,var)
      (defbenchmark ,(format-symbol *package* "N-CLASSES.~A" n) (:group slot-access
                                                                 :let ((list ,var)))
        (,test list)))))
(define-n-classes 1)
(define-n-classes 2)
(define-n-classes 3)
(define-n-classes 4)
(define-n-classes 5)
(define-n-classes 6)
(define-n-classes 7)
(define-n-classes 8)
(define-n-classes 16)
(define-n-classes 32)
(define-n-classes 128)

;;; N classes, 2 slot locations, 1 accessor
(defmacro define-n-classes/2-slots (n)
  (let ((slot (format-symbol *package* "~A-CLASS/2-SLOT-SLOT" n))
        (test (format-symbol *package* "~A-CLASS/2-SLOT-RUN" n))
        (var (format-symbol *package* "*~A-CLASS/2-SLOT-LIST*" n)))
    `(progn
       ,@(loop for i from 1 upto n
               collect `(defclass ,(format-symbol *package*
                                                  "~A-CLASS/2-SLOT.~A" n i)
                            ()
                          ,(if (oddp i)
                               `((,slot
                                  :initform (random most-positive-fixnum)
                                  :accessor ,slot)
                                 (dummy
                                  :initform (random most-positive-fixnum)))
                               `((dummy
                                  :initform (random most-positive-fixnum))
                                 (,slot
                                  :initform (random most-positive-fixnum)
                                  :accessor ,slot)))))
       (defvar ,var
         (loop for i from 1 upto ,n
               collect
                  (make-instance
                   (format-symbol *package*
                                          "~A-CLASS/2-SLOT.~A"
                                          ,n i))))
       (defun ,test (instances)
         (dolist (elt instances)
           (opaque (,slot elt))
           (setf (,slot elt) 42)))
       (,test ,var)
       (,test ,var)
       (,test ,var)
       (defbenchmark ,(format-symbol *package* "~A-CLASSES/2-SLOTS" n) (:group slot-access
                                                                        :let ((list ,var)))
         (,test list)))))
(define-n-classes/2-slots 2)
(define-n-classes/2-slots 3)
(define-n-classes/2-slots 4)
(define-n-classes/2-slots 5)
(define-n-classes/2-slots 6)
(define-n-classes/2-slots 7)
(define-n-classes/2-slots 8)
(define-n-classes/2-slots 32)
(define-n-classes/2-slots 128)
(define-n-classes/2-slots 512)

;;;; POSITION

(defvar *a-vector-t* (make-array 10000 :element-type t :initial-element nil))
(defvar *a-vector-bit-0* (make-array 10000 :element-type 'bit :initial-element 0))
(defvar *a-vector-bit-1* (make-array 10000 :element-type 'bit :initial-element 1))
(defvar *a-string* (make-array 10000 :element-type 'character :initial-element #\space))
(defvar *a-base-string* (make-array 10000 :element-type 'base-char :initial-element #\space))
(defvar *a-list* (make-list 10000 :initial-element nil))

;;; Generic

(defun generic-position (item seq from-end)
  (if from-end
      (position item seq :from-end t)
      (position item seq)))

(defbenchmark generic-position.simple-vector (:group generic-position)
  (generic-position t *a-vector-t* nil))

(defbenchmark generic-position.simple-vector.from-end (:group generic-position)
  (generic-position t *a-vector-t* t))

(defbenchmark generic-position.bit-vector.0 (:group generic-position)
  (generic-position 0 *a-vector-bit-1* nil))

(defbenchmark generic-position.bit-vector.0.from-end (:group generic-position)
  (generic-position 0 *a-vector-bit-1* t))

(defbenchmark generic-position.bit-vector.1 (:group generic-position)
  (generic-position 1 *a-vector-bit-0* nil))

(defbenchmark generic-position.bit-vector.1.from-end (:group generic-position)
  (generic-position 1 *a-vector-bit-0* t))

(defbenchmark generic-position.string (:group generic-position)
  (generic-position #\x *a-string* nil))

(defbenchmark generic-position.string.from-end (:group generic-position)
  (generic-position #\x *a-string* t))

(defbenchmark generic-position.base-string (:group generic-position)
  (generic-position #\x *a-base-string* nil))

(defbenchmark generic-position.base-string.from-end (:group generic-position)
  (generic-position #\x *a-base-string* t))

(defbenchmark generic-position.list (:group generic-position)
  (generic-position t *a-list* nil))

(defbenchmark generic-position.list.from-end (:group generic-position)
  (generic-position t *a-list* t))

;;; Specialized

(defbenchmark position.simple-vector (:group position)
  (declare (optimize speed))
  (position t (the simple-vector *a-vector-t*)))

(defbenchmark position.simple-vector.from-end (:group position)
  (declare (optimize speed))
  (position t (the simple-vector *a-vector-t*) :from-end t))

(defbenchmark position.bit-vector.0 (:group position)
  (declare (optimize speed))
  (position 0 (the simple-bit-vector *a-vector-bit-1*)))

(defbenchmark position.bit-vector.0.from-end (:group position)
  (declare (optimize speed))
  (position 0 (the simple-bit-vector *a-vector-bit-1*) :from-end t))

(defbenchmark position.bit-vector.1 (:group position)
  (declare (optimize speed))
  (position 1 (the simple-bit-vector *a-vector-bit-0*)))

(defbenchmark position.bit-vector.1.from-end (:group position)
  (declare (optimize speed))
  (position 1 (the simple-bit-vector *a-vector-bit-0*) :from-end t))

(defbenchmark position.string (:group position)
  (declare (optimize speed))
  (position #\x (the string *a-string*)))

(defbenchmark position.string.from-end (:group position)
  (declare (optimize speed))
  (position #\x (the string *a-string*) :from-end t))

(defbenchmark position.character-string (:group position)
  (declare (optimize speed))
  (position #\x (the (simple-array character (*)) *a-string*)))

(defbenchmark position.character-string.from-end (:group position)
  (declare (optimize speed))
  (position #\x (the (simple-array character (*)) *a-string*) :from-end t))

(defbenchmark position.base-string (:group position)
  (declare (optimize speed))
  (position #\x (the (simple-array base-char (*)) *a-base-string*)))

(defbenchmark position.base-string.from-end (:group position)
  (declare (optimize speed))
  (position #\x (the (simple-array base-char (*)) *a-base-string*) :from-end t))

(defbenchmark position.list (:group position)
  (declare (optimize speed))
  (position t (the list *a-list*)))

(defbenchmark position.list.from-end (:group position)
  (declare (optimize speed))
  (position t (the list *a-list*) :from-end t))

;;;; STRING-OUTPUT-STREAM

(defbenchmark string-output-stream.small (:group alloc)
  (with-output-to-string (s)
    (loop repeat 100
          do (write-char #\. s))))

(defbenchmark string-output-stream.medium (:group alloc)
  (let ((line (make-string 99 :initial-element #\.)))
    (with-output-to-string (s)
      (loop repeat 100
            do (write-line line s))))
  nil)

(defbenchmark string-output-stream.big (:group alloc)
  (let ((line (make-string 99 :initial-element #\.)))
    (with-output-to-string (s)
      (loop repeat 10000
            do (write-line line s)))))

;;;; MAP

(defun map-unknown (type f s1 s2)
  (map type f s1 s2))

(defun map-list (f s1 s2)
  (map 'list f s1 s2))

(defun map-vector (f s1 s2)
  (map 'vector f s1 s2))

(defun map-floats (f s1 s2)
  (map '(vector single-float) f s1 s2))

(defun arg-one (x y)
  (declare (ignore y))
  x)

(defvar *list10* (make-list 10 :initial-element 10))
(defvar *list100* (make-list 100 :initial-element 100))
(defvar *list1000* (make-list 1000 :initial-element 1000))

(defvar *vector10* (make-array 10 :initial-element 10))
(defvar *vector100* (make-array 100 :initial-element 100))
(defvar *vector1000* (make-array 1000 :initial-element 1000))

(defvar *floats10* (make-array 10 :element-type 'single-float :initial-element 10.0))
(defvar *floats100* (make-array 100 :element-type 'single-float :initial-element 100.0))
(defvar *floats1000* (make-array 1000 :element-type 'single-float :initial-element 1000.0))

(defbenchmark map.unknown.lists.10 (:group map)
  (map-unknown 'list #'arg-one
               *list10*
               *list10*))

(defbenchmark map.unknown.lists.100 (:group map)
  (map-unknown 'list #'arg-one
               *list100*
               *list100*))

(defbenchmark map.unknown.lists.1000 (:group map)
  (map-unknown 'list #'arg-one
               *list1000*
               *list1000*))

(defbenchmark map.unknown.vectors.10 (:group map)
  (map-unknown 'vector #'arg-one
               *vector10*
               *vector10*))

(defbenchmark map.unknown.vectors.100 (:group map)
  (map-unknown 'vector #'arg-one
               *vector100*
               *vector100*))

(defbenchmark map.unknown.vectors.1000 (:group map)
  (map-unknown 'vector #'arg-one
               *vector1000*
               *vector1000*))

(defbenchmark map.unknown.floats.10 (:group map)
  (map-unknown '(vector single-float)
               #'arg-one
               *floats10*
               *floats10*))

(defbenchmark map.unknown.floats.100 (:group map)
  (map-unknown '(vector single-float)
               #'arg-one
               *floats100*
               *floats100*))

(defbenchmark map.unknown.floats.1000 (:group map)
  (map-unknown '(vector single-float)
               #'arg-one
               *floats1000*
               *floats1000*))

(defbenchmark map.lists.10 (:group map)
  (map-list #'arg-one
               *list10*
               *list10*))

(defbenchmark map.lists.100 (:group map)
  (map-list #'arg-one
            *list100*
            *list100*))

(defbenchmark map.lists.1000 (:group map)
  (map-list #'arg-one
            *list1000*
            *list1000*))

(defbenchmark map.vectors.10 (:group map)
  (map-vector #'arg-one
              *vector10*
              *vector10*))

(defbenchmark map.vectors.100 (:group map)
  (map-vector #'arg-one
       *vector100*
       *vector100*))

(defbenchmark map.vectors.1000 (:group map)
  (map-vector #'arg-one
              *vector1000*
              *vector1000*))

(defbenchmark map.floats.10 (:group map)
  (map-floats #'arg-one
               *floats10*
               *floats10*))

(defbenchmark map.floats.100 (:group map)
  (map-floats #'arg-one
              *floats100*
              *floats100*))

(defbenchmark map.floats.1000 (:group map)
  (map-floats #'arg-one
               *floats1000*
               *floats1000*))

;;;; MAP-INTO

(defbenchmark map-into.list.10 (:group map-into)
  (map-into *list10* #'identity *list10*))

(defbenchmark map-into.list.100 (:group map-into)
  (map-into *list100* #'identity *list100*))

(defbenchmark map-into.list.1000 (:group map-into)
  (map-into *list1000* #'identity *list1000*))

(defbenchmark map-into.vector.10 (:group map-into)
  (map-into *vector10* #'identity *vector10*))

(defbenchmark map-into.vector.100 (:group map-into)
  (map-into *vector100* #'identity *vector100*))

(defbenchmark map-into.vector.1000 (:group map-into)
  (map-into *vector1000* #'identity *vector1000*))

(defbenchmark map-into.float.10 (:group map-into)
  (map-into *floats10* #'identity *floats10*))

(defbenchmark map-into.float.100 (:group map-into)
  (map-into *floats100* #'identity *floats100*))

(defbenchmark map-into.float.1000 (:group map-into)
  (map-into *floats1000* #'identity *floats1000*))

(defbenchmark map-into.lists.10 (:group map-into)
  (map-into *list10* #'arg-one
            *list10*
            *list10*))

(defbenchmark map-into.lists.100 (:group map-into)
  (map-into *list100* #'arg-one
            *list100*
            *list100*))

(defbenchmark map-into.lists.1000 (:group map-into)
  (map-into *list1000* #'arg-one
            *list1000*
            *list1000*))

(defbenchmark map-into.vectors.10 (:group map-into)
  (map-into *vector10* #'arg-one
            *vector10*
            *vector10*))

(defbenchmark map-into.vectors.100 (:group map-into)
  (map-into *vector100* #'arg-one
            *vector100*
            *vector100*))

(defbenchmark map-into.vectors.1000 (:group map-into)
  (map-into *vector1000* #'arg-one
            *vector1000*
            *vector1000*))

(defbenchmark map-into.floats.10 (:group map-into)
  (map-into *floats10* #'arg-one
            *floats10*
            *floats10*))

(defbenchmark map-into.floats.100 (:group map-into)
  (map-into *floats100* #'arg-one
            *floats100*
            *floats100*))

(defbenchmark map-into.floats.1000 (:group map-into)
  (map-into *floats1000* #'arg-one
            *floats1000*
            *floats1000*))
