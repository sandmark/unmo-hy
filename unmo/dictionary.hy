(import json
        [unmo.exceptions [DictionaryNotFound]])
(require [unmo.utils [*]])

(defclass Dictionary []
  [default-dicfile "dic/dict.json"]

  (prop random self._random
        pattern self._pattern
        dicfile self._dicfile)

  (defn --init-- [self &optional filename]
    (setv self._dicfile (if filename filename Dictionary.default-dicfile))
    (try
      (with [f (open self._dicfile)]
        (setv data (json.load f)))
      (except [e FileNotFoundError]
        (setv data {"random" []
                    "pattern" {}})
        (raise (DictionaryNotFound self._dicfile self e)))
      (finally
        (setv self._random (get data "random"))
        (setv self._pattern (get data "pattern")))))

  (defn learn [self text]
    (unless (in text self._random)
      (.append self._random text))))
