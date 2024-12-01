;; FIXME: Figure out why the readtable is always different in the reader macro
;; TODO: Do I have to use named-readtables in order to figure this out?

(defpackage :named-reader-macros
  (:use :cl :alexandria :named-readtables)
  (:local-nicknames (:s :serapeum))
  (:export #:set-named-reader-macro
           #:define-named-reader-macro))

(in-package :named-reader-macros)

(defparameter *readtable-dict* (s:dict *readtable* (s:dict)))

(defvar *current-macro-char*)

(defun get-or-create-macro-table ()
  "Find a macro table for the current `*readtable*' in `*readtable-dict*'.
If `*readtable*' is not a key in `*readtable-dict*', adds it and returns a
new hashtable."
  (let* ((table-hash (named-readtables:readtable-name *readtable*))
         (macro-table (gethash table-hash *readtable-dict*)))
    (unless macro-table
      (setf macro-table (s:dict))
      (setf (gethash table-hash *readtable-dict*) macro-table))
    macro-table))

(defun read-named-reader-macro (stream char arg)
  (let* ((macro-name (read stream))
         (macro-table (get-or-create-macro-table))
         (macro (gethash macro-name macro-table)))
    (if (and macro (functionp macro))
        ;; Call the identified macro on the arguments
        (funcall macro stream char arg)
      (cerror "Generate NIL for this form"
              "Found ~A when looking for named-reader-macro ~A in read-table named ~A (readtable ~A)."
              macro macro-name
              (named-readtables:readtable-name *readtable*) *readtable*))))

(defun set-named-reader-macro (name func)
  (if func
      (setf (gethash name (get-or-create-macro-table)) func)
      (remhash name (get-or-create-macro-table))))

(defmacro define-named-reader-macro (name (stream char arg) &body body)
  `(prog1
       (defun ,name (,stream ,char ,arg)
         ,@body)
     (set-named-reader-macro ',name #',name)))

(export '(read-named-reader-macro set-named-reader-macro define-named-reader-macro) *package*)

(set-dispatch-macro-character #\# #\_ 'read-named-reader-macro)

;;; Example usage:
;; (define-named-reader-macro read-with-hello (stream char arg)
;;   (declare (ignore char arg))
;;   (format nil "hello ~A!" (read stream)))
