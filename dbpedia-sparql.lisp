;;;; dbpedia-sparql.lisp

(in-package #:dbpedia-sparql)

;;; "dbpedia-sparql" goes here. Hacks and glory await!

(defun send-query (query)
  (drakma:http-request "http://dbpedia.org/sparql"
                     :method :get
                     :parameters
                     (list (cons "query" query)
                           (cons "format" "json"))))

(defun bytes->string (bytes)
  (map 'string #'code-char bytes))

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
  (let ((original-ret (send-query query)))
    (typecase original-ret
      ((simple-array (unsigned-byte 8))
       (make-better-list
        (json->list
         (bytes->string original-ret))))
      ((simple-array character)
       original-ret))))

(defun upper-case (string)
  (map 'string #'char-upcase string))
