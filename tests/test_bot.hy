(import pytest
        [unmo.bot [Bot]]
        [unmo.exceptions [DictionaryNotFound
                          DictionaryEmpty
                          BotDictionaryLoadError]]
        [fixtures [*]])

(defclass TestBot []
  (defn test-unmo-alerts-without-dictionary [self]
    (with [e (pytest.raises BotDictionaryLoadError)]
      (assert (Bot 'test))))

  (defn test-unmo-dialogue-without-dictionary [self]
    (try
      (setv bot (Bot 'test))
      (except [e BotDictionaryLoadError]
        (setv bot e.bot-instance)))
    (with [e (pytest.raises DictionaryEmpty)]
      (.dialogue bot "test")
      (assert (in "辞書が空です" e.message))))

  (defn test-unmo-property-name [self unmo]
    (assert (= unmo.name "test")))

  (defn test-unmo-property-responder-name [self unmo]
    (assert (= unmo.responder-name "Random"))))
