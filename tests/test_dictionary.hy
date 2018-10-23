(import pytest
        [unmo.dictionary [Dictionary]]
        [unmo.exceptions [DictionaryNotFound]]
        [fixtures [*]])

(defclass TestDictionary []
  (defn test-save [self testdic-nofile tmp-dicfile]
    (try
      (setv dictionary (Dictionary tmp-dicfile))
      (except [e DictionaryNotFound]
        (setv dictionary e.dictionary-instance)))
    (setv text "Hi, chatbot!")
    (.learn dictionary text)
    (.save dictionary)
    (setv dictionary (Dictionary tmp-dicfile))
    (assert (= (len dictionary.random) 1))
    (assert (in text dictionary.random)))

  (defn test-raises-dictionary-file-not-found [self]
    (with [(pytest.raises DictionaryNotFound)]
      (Dictionary "file-not-exists")))

  (defn test-random-without-dict-file [self testdic-nofile]
    (assert (empty? testdic-nofile.random)))

  (defn test-random [self testdic]
    (assert (not (empty? testdic.random)))
    (assert (= (len testdic.random)
               (len *TEST-RANDOM*)))
    (for [text testdic.random]
      (assert (in text *TEST-RANDOM*))))

  (defn test-random-learn [self testdic-nofile]
    (assert (empty? testdic-nofile.random))
    (setv text "Hi, chatbot.")
    (.learn testdic-nofile text)
    (assert (in text testdic-nofile.random))
    (.learn testdic-nofile text)
    (assert (len testdic-nofile.random) 1))

  (defn test-pattern-without-dict-file [self testdic-nofile]
    (assert (= testdic-nofile.pattern {})))

  (defn test-pattern [self testdic]
    (assert (= testdic.pattern *TEST-PATTERN*))))
