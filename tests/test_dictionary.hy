(import pytest
        [unmo.dictionary [Dictionary]]
        [unmo.exceptions [DictionaryNotFound]]
        [fixtures [*]])

(defclass TestDictionary []
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

  (defn test-pattern-without-dict-file [self testdic-nofile]
    (assert (= testdic-nofile.pattern {})))

  (defn test-pattern [self testdic]
    (assert (= testdic.pattern *TEST-PATTERN*))))
