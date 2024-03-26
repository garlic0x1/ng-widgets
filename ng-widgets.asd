(asdf:defsystem "ng-widgets"
  :author "garlic0x1"
  :license "MIT"
  :depends-on (:alexandria :str :nodgui)
  :components ((:module "src"
                :components ((:file "package")
                             (:file "utils")
                             (:file "listbox")
                             (:file "prompt")
                             (:file "inspector")
                             ))))
