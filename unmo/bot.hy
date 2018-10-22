(import [random [choice]]
        [unmo.responders [WhatResponder
                          RandomResponder]]
        [unmo.dictionary [Dictionary]]
        [unmo.exceptions [DictionaryNotFound BotDictionaryLoadError]])
(require [unmo.utils [*]])

(defclass Bot []
  (prop name self._name
        responder-name self._responder.name)

  (defn --init-- [self name &optional dicfile]
    (try
      (setv self._dictionary (Dictionary (if dicfile dicfile Dictionary.default-dicfile)))
      (except [e DictionaryNotFound]
        (setv self._dictionary e.dictionary-instance)
        (raise (BotDictionaryLoadError e.dictionary-file self e)))
      (finally
        (setv self._name name
              self._responders {:what   (WhatResponder   'What   self._dictionary)
                                :random (RandomResponder 'Random self._dictionary)}
              self._responder (get self._responders :random)))))

  (defn dialogue [self text]
    (setv key (-> (self._responders.keys) (list) (choice))
          self._responder (get self._responders key))
    (.response self._responder text)))
