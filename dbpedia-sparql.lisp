; Copyright (C) 2012 by Grégoire Jadi
; See the file LICENSE for copying permission.

(in-package #:dbpedia-sparql)

(defparameter *http-proxy-server* nil)  ; hostname only! no http://
(defparameter *http-proxy-port* 80)

(defun send-query (query)
  (drakma:http-request "http://dbpedia.org/sparql"
                       :method :get
                       :parameters
                       (list (cons "query" query)
                             (cons "format" "json"))
                       :proxy (unless (null *http-proxy-server*)
                                (list *http-proxy-server*
                                      *http-proxy-port*))))

(defun json->list (json)
  (json:decode-json-from-string json))

(defun make-better-list (results)
  (let (titles)
    (cons
     (setf titles
           (loop :for title :in (assoc-value (assoc-value results :HEAD)
                                             :VARS)
                 :collect title))
     (loop :for line :in (assoc-value (assoc-value results :RESULTS)
                                      :BINDINGS)
           :collect
           (loop :for title :in titles
                 :collect (assoc-value (assoc-value line
                                                    (intern
                                                     (upper-case title)
                                                     :keyword))
                                       :VALUE))))))

(defun query->list (query)
  (multiple-value-bind (ret code)
      (send-query query)
    (case code
      (200 (make-better-list
            (json->list
             (babel:octets-to-string ret))))
      (t ret))))

(defun upper-case (string)
  (map 'string #'char-upcase string))
