(require [unmo.utils [*]])

(defclass DictionaryError [Exception])
(defclass DictionaryNotFound [DictionaryError]
  (prop dictionary-instance self._dictionary-instance
        dictionary-file     self._dictionary-file)

  (defn --init-- [self filename instance cause]
    (.--init-- (super DictionaryNotFound self) (repr cause))
    (setv self.cause cause)
    (setv self._dictionary-instance instance)
    (setv self._dictionary-file filename)))

(defclass DictionaryEmpty [DictionaryError]
  (prop message self._message)

  (defn --init-- [self message cause]
    (.--init-- (super DictionaryEmpty self) (repr cause))
    (setv self.cause cause)
    (setv self._message message)))

(defclass BotError [Exception])
(defclass BotDictionaryLoadError [BotError]
  (prop bot-instance    self._bot-instance
        dictionary-file self._dictionary-file)

  (defn --init-- [self filename instance cause]
    (.--init-- (super BotDictionaryLoadError self) (repr cause))
    (setv self.cause cause)
    (setv self._bot-instance instance)
    (setv self._dictionary-file filename)))
