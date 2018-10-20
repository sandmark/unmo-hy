(import [unmo.responders [RandomResponder]])

(defclass Bot []
  (defn __init__ [self name]
    (setv self._name name)
    (setv self._responder (RandomResponder "Random")))

  (defn dialogue [self text]
    (.response self._responder text))

  (with-decorator property
    (defn name [self]
      self._name))

  (with-decorator property
    (defn responder-name [self]
      self._responder.name)))
