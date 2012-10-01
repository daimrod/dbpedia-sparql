;;;; dbpedia-sparql.asd

(asdf:defsystem #:dbpedia-sparql
  :serial t
  :description "dbpedia-sparql"
  :depends-on (#:drakma
               #:cl-json
               #:alexandria)
  :components ((:file "package")
               (:file "dbpedia-sparql")))

