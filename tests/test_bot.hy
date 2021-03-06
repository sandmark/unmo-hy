(import os
        [pathlib [PurePath]]
        pytest
        [unmo.bot [Bot]]
        [unmo.exceptions [DictionaryNotFound
                          DictionaryEmpty
                          BotDictionaryLoadError]]
        [fixtures [*]])

(defclass TestBot []
  (defn test-unmo-alerts-without-dictionary [self testdic-nofile]
    (with [e (pytest.raises BotDictionaryLoadError)]
      (assert (Bot 'test testdic-nofile.dicfile))))

  (defn test-unmo-save [self unmo]
    (setv dicfile (PurePath unmo._dictionary.dicfile))
    (setv initial-dict (with [f (open dicfile :encoding 'utf-8)] (.read f)))
    (.dialogue unmo "Hi, chatbot!")
    (.save unmo)
    (setv expected-dict (with [f (open dicfile :encoding 'utf-8)] (.read f)))
    (assert (> (len expected-dict) (len initial-dict))))

  (defn test-unmo-learn-when-dialogue [self unmo]
    (setv text "Hi, chatbot!")
    (setv expected-length (inc (len unmo._dictionary.random)))
    (.dialogue unmo text)
    (assert (= (len unmo._dictionary.random) expected-length))
    (assert (in text unmo._dictionary.random)))

  (defn test-unmo-dialogue-without-dictionary [self testdic-nofile]
    (try
      (setv bot (Bot 'test testdic-nofile.dicfile))
      (except [e BotDictionaryLoadError]
        (setv bot e.bot-instance)))
    (with [e (pytest.raises DictionaryEmpty)]
      (.dialogue bot "test")
      (assert (in "辞書が空です" e.message))))

  (defn test-unmo-property-name [self unmo]
    (assert (= unmo.name "test")))

  (defn test-unmo-property-responder-name [self unmo]
    (assert (= unmo.responder-name "Random"))))
