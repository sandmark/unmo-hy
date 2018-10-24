(import [random [choice randrange]]
        [unmo.responders [WhatResponder
                          RandomResponder
                          PatternResponder]]
        [unmo.dictionary [Dictionary]]
        [unmo.exceptions [DictionaryError
                          DictionaryNotFound
                          BotDictionaryLoadError]]
        [unmo.morph [analyze]])
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
              self._responders {:what   (WhatResponder     'What    self._dictionary)
                                :random (RandomResponder   'Random  self._dictionary)
                                :pattern (PatternResponder 'Pattern self._dictionary)}
              self._responder (get self._responders :random)))))

  (defn dialogue [self text]
    (setv chance (randrange 0 100)
          parts (analyze text))
    (cond [(in chance (range 0 59))  (setv self._responder (get self._responders :pattern))]
          [(in chance (range 60 89)) (setv self._responder (get self._responders :random))]
          [True                      (setv self._responder (get self._responders :what))])

    (try
      (setv response (.response self._responder text parts))
      (except [] (raise))
      (finally
        (.learn self._dictionary text parts)))
    response)

  (defn save [self]
    (self._dictionary.save)))
