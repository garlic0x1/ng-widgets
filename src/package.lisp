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
   :listbox*-delete-all
   ;; inspector.lisp
   :inspector
   :inspector-value
   :inspector-swap
   ;; prompt.lisp
   :prompt
   :prompt-value
   :prompt-swap
   :file-prompt))
