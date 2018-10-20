(defclass Responder []
  (defn __init__ [self name]
    (setv self._name name))

  (defn response [self text]
    (-> "{text}ってなに？" (.format :text text)))

  (with-decorator property
    (defn name [self] self._name)))
