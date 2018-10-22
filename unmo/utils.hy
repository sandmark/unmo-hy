(defmacro ap-when [condition &rest body]
  (require [hy.extra.anaphoric [ap-if]])
  `(ap-if ~condition
     (do ~@body)
     '()))

(defmacro let [values &rest body]
  (setv var-names (list (map first  values))
        var-vals  (list (map second values)))
  `((fn [~@var-names] ~@body) ~@var-vals))

(defmacro for-with-result [result-bindings bindings &rest body]
  (let ((result        (first  result-bindings))
        (initial-value (second result-bindings)))
    `(let ((~result ~initial-value))
       (for ~bindings ~@body)
       ~result)))

(defmacro prop [&rest expr]
  "Declare instance properties.
   Usage:
     (prop title self._title
           votes self._votes)

   Expanded to:
     (with-decorator property
       (defn title [self]
         self._title))
     (with-decorator property
       (defn votes [self]
         self._votes))"
  (as-> (iter expr) it
        (zip it it)             ; loop with step 2
        (for-with-result [result '()] [(, attr body) it]
          (->> `(with-decorator property
                  (defn ~attr [self] ~body))
               (.append result)))
        (+ '(do) it)))
