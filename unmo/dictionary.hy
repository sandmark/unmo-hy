(import json
        [unmo.exceptions [DictionaryNotFound]])
(require [unmo.utils [*]])

(defclass Dictionary []
  [dicfile "dic/dict.json"]

  (prop random self._random
        pattern self._pattern
        dicfile self._dicfile)

  (defn --init-- [self &optional [dicfile dicfile]]
    (setv self._dicfile dicfile)
    (try
      (with [f (open dicfile)]
        (setv data (json.load f)))
      (except [e FileNotFoundError]
        (setv data {"random" []
                    "pattern" {}})
        (raise (DictionaryNotFound dicfile self e)))
      (finally
        (setv self._random (get data "random"))
        (setv self._pattern (get data "pattern"))))))
