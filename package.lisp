; Copyright (C) 2012 by Grégoire Jadi
; See the file LICENSE for copying permission.

(defpackage #:dbpedia-sparql
  (:use #:cl
        #:alexandria)
  (:export #:query->list)
  (:nicknames :db-sparql))

