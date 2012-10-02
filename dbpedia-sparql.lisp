;;;; dbpedia-sparql.lisp

(in-package #:dbpedia-sparql)

;;; "dbpedia-sparql" goes here. Hacks and glory await!

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
  (let (titles ret)
    (push (nreverse
           (loop :for title :in (assoc-value (assoc-value results :HEAD)
                                             :VARS)
                 :collect title
                 :do (push (intern (upper-case title) :keyword) titles)))
          ret)
    (loop :for line :in (assoc-value (assoc-value results :RESULTS)
                                     :BINDINGS)
          :do
             (push (nreverse
                    (loop :for title :in titles
                          :collect (assoc-value (assoc-value line title)
                                                :VALUE)))
                   ret))
    (nreverse ret)))

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
