;;;; dbpedia-sparql.asd

(asdf:defsystem #:dbpedia-sparql
  :serial t
  :description "Describe dbpedia-sparql here"
  :author "Your Name <your.name@example.com>"
  :license "Specify license here"
  :depends-on (#:drakma
               #:cl-json
               #:alexandria)
  :components ((:file "package")
               (:file "dbpedia-sparql")))

