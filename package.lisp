;;;; package.lisp

(defpackage #:dbpedia-sparql
  (:use #:cl
        #:alexandria)
  (:export #:query->list)
  (:nicknames :db-sql))

