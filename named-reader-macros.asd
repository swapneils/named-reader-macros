(defsystem :named-reader-macros
  :serial t
  :license "MIT"
  :description "A utility to assign extended names to reader macros."
  :author "Swapneil Singh"
  :version "0.0.1"
  :depends-on ("alexandria"
               "serapeum"
               "named-readtables")
  :components ((:file "named-reader-macros")))
