(defmacro property [attr &rest body]
  "Declare `attr` as an instance property method.
   Usage:
     (property name self._name)"
  `(with-decorator property
     (defn ~attr [self]
       ~@body)))
