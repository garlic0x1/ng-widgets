(in-package :ng-widgets)

(defwidget prompt (frame)
  ((value
    :initarg :value
    :initform ""
    :accessor prompt-value)
   (command
    :initarg :command
    :initform nil
    :accessor prompt-command)
   (completion
    :initarg :completion
    :initform (lambda (val) (list val))
    :accessor prompt-completion))
  ((listbox listbox
            :grid '(0 0 :sticky :nsew :columnspan 2))
   (entry entry
          :grid '(1 0 :sticky :nsew)
          :text (prompt-value self))
   (button button
           :grid '(1 1 :sticky :nsew)
           :text "Ok"
           :command (lambda () (funcall (prompt-command self) (prompt-value self)))))

  (grid-rowconfigure self 0 :weight 1)
  (grid-rowconfigure self 1 :minsize 32)
  (grid-columnconfigure self 0 :weight 2)
  (grid-columnconfigure self 1 :minsize 64)

  (prompt-update-list self)

  (setf (command (listbox self))
        (lambda (indices)
          (when-let ((index (car indices)))
            (let ((value (nth index
                              (listbox-all-values
                               (listbox self)))))
              (prompt-swap self value)))))

  (bind entry "<Tab>"
    (lambda (e)
      (declare (ignore e))
      (when-let ((item (car (listbox-all-values (listbox self)))))
        (prompt-swap self item))
      (focus (entry self))
      (set-cursor-index (entry self) :end)))

  (bind entry "<Return>"
    (lambda (e)
      (declare (ignore e))
      (funcall (prompt-command self) (prompt-value self))))

  (bind entry "<Key>"
    (lambda (e)
      (declare (ignore e))
      (prompt-swap self (text (entry self))))))

(defun prompt-swap (self value)
  (setf (prompt-value self) value
        (text (entry self)) value)
  (prompt-update-list self))

(defun prompt-update-list (self)
  (listbox-delete (listbox self) 0 (listbox-size (listbox self)))
  (listbox-insert (listbox self)
                  0
                  (funcall (prompt-completion self)
                           (text (entry self)))))

(defwidget file-prompt (prompt)
  ((path
    :initarg :path
    :initform (namestring (user-homedir-pathname))
    :accessor file-prompt-path))
  ()
  (setf (prompt-completion self)
        (lambda (path)
          (let ((dir (namestring (uiop:pathname-directory-pathname path))))
            (remove-if-not (curry #'str:starts-with-p path)
                           (mapcar #'namestring
                                   (append (uiop:subdirectories dir)
                                           (uiop:directory-files dir)))))))

  (prompt-swap self (file-prompt-path self))

  (bind (entry self) "<BackSpace>"
    (lambda (e)
      (declare (ignore e))
      (let* ((path (prompt-value self))
             (dir (namestring
                   (uiop:pathname-directory-pathname
                    (if (str:ends-with-p "/" path)
                        (str:substring 0 (1- (length path)) path)
                        path)))))
        (prompt-swap self dir)))))
