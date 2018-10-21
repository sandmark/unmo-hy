(import pytest
        [unmo.dictionary [Dictionary]]
        [fixtures [*]])

(defclass TestDictionary []
  (defn test-random-without-dict-file [self testdic-nofile]
    (assert (empty? testdic-nofile.random)))

  (defn test-random [self testdic]
    (assert (not (empty? testdic.random)))
    (assert (= (len testdic.random)
               (len TEST_RANDOM)))
    (for [text testdic.random]
      (assert (in text TEST_RANDOM)))))
