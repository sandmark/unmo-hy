(require [unmo.utils [*]])

(defclass DictionaryError [Exception])
(defclass DictionaryNotFound [DictionaryError]
  (prop dictionary-instance self._dictionary-instance)

  (defn --init-- [self filename instance cause]
    (.--init-- (super DictionaryNotFound self) (repr cause))
    (setv self.cause cause)
    (setv self._dictionary-instance instance)))

(defclass DictionaryEmpty [DictionaryError])

(defclass BotError [Exception])
(defclass BotDictionaryLoadError [BotError]
  (prop bot-instance self._bot-instance)

  (defn --init-- [self instance cause]
    (.--init-- (super BotDictionaryLoadError self) (repr cause))
    (setv self.cause cause)
    (setv self._bot-instance instance)))
