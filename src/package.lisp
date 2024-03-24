(uiop:define-package :ng-widgets
  (:use :cl :alexandria :nodgui)
  (:export
   ;; listbox.lisp
   :listbox*
   :listbox*-get
   :listbox*-append
   :listbox*-insert
   :listbox*-push
   :listbox*-value
   ;; inspector.lisp
   :inspector
   :inspector-swap
   ))
