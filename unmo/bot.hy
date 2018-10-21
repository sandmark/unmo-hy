(import [random [choice]]
        [unmo.responders [WhatResponder
                          RandomResponder]]
        [unmo.dictionary [Dictionary]])
(require [unmo.utils [*]])

(defclass Bot []
  (property name self._name)
  (property responder-name self._responder.name)

  (defn __init__ [self name &optional [dicfile Dictionary.dicfile]]
    (setv self._dictionary (Dictionary dicfile)
          self._name name
          self._responders {:what   (WhatResponder   'What   self._dictionary)
                            :random (RandomResponder 'Random self._dictionary)}
          self._responder (get self._responders :random)))

  (defn dialogue [self text]
    (setv key (-> (self._responders.keys) (list) (choice))
          self._responder (get self._responders key))
    (.response self._responder text)))
