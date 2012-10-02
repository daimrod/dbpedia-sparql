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
  (loop :for code :across bytes
        :collect (code-char code) :into chars
        :finally (return
                   (concatenate 'string chars))))

(defun json->list (json)
  (json:decode-json-from-string json))

(defun make-better-list (results)
  (let (titles ret)
    (loop :for title :in (assoc-value (assoc-value results :HEAD)
                                      :VARS)
          :do (push title ret)
          :do (push (intern (upper-case title) :keyword) titles))
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
