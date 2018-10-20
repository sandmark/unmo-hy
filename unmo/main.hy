(defclass Responder []
  (defn __init__ [self name]
    (setv self._name name))

  (defn response [self text]
    (-> "{text}ってなに？" (.format :text text)))

  (with-decorator property
    (defn name [self] self._name)))

(defclass Unmo []
  (defn __init__ [self name]
    (setv self._name name)
    (setv self._responder (Responder 'What)))

  (defn dialogue [self text]
    (.response self._responder text))

  (with-decorator property
    (defn name [self]
      self._name))

  (with-decorator property
    (defn responder-name [self]
      self._responder.name)))

(defn prompt [unmo]
  (.format "{name}:{responder}> "
           :name unmo.name
           :responder unmo.responder-name))
