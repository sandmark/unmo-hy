(import [random [choice]]
        [unmo.responders [WhatResponder
                          RandomResponder]]
        [unmo.dictionary [Dictionary]]
        [unmo.exceptions [DictionaryNotFound]])
(require [unmo.utils [*]])

(defclass Bot []
  (prop name self._name
        responder-name self._responder.name)

  (defn --init-- [self name &optional dicfile]
    (setv self._dictionary
          (try
            (Dictionary (if dicfile dicfile Dictionary.default-dicfile))
            (except [e DictionaryNotFound]
              e.dictionary-instance)))
    (setv self._name name
          self._responders {:what   (WhatResponder   'What   self._dictionary)
                            :random (RandomResponder 'Random self._dictionary)}
          self._responder (get self._responders :random)))

  (defn dialogue [self text]
    (setv key (-> (self._responders.keys) (list) (choice))
          self._responder (get self._responders key))
    (.response self._responder text)))
