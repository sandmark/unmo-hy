(import [unmo.responders [RandomResponder]])
(require [unmo.utils [*]])

(defclass Bot []
  (property name self._name)
  (property responder-name self._responder.name)

  (defn __init__ [self name]
    (setv self._name name)
    (setv self._responder (RandomResponder "Random")))

  (defn dialogue [self text]
    (.response self._responder text)))
