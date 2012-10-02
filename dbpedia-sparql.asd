; Copyright (C) 2012 by Grégoire Jadi
; See the file LICENSE for copying permission.

(asdf:defsystem #:dbpedia-sparql
  :serial t
  :description "dbpedia-sparql"
  :depends-on (#:drakma
               #:cl-json
               #:alexandria
               #:babel)
  :components ((:file "package")
               (:file "dbpedia-sparql")))

