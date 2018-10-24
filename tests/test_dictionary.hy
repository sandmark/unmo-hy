(import os
        re
        pytest
        [unmo.dictionary [Dictionary]]
        [unmo.exceptions [DictionaryNotFound]]
        [unmo.morph [analyze]]
        [fixtures [*]])

(defclass TestDictionaryTemplate []
  (defn test-empty-template [self testdic-nofile]
    (assert (= testdic-nofile.template {})))

  (defn test-learn [self testdic-nofile janome-text-1 janome-nouns-1 janome-template-1]
    (setv parts (analyze janome-text-1)
          index (len janome-nouns-1))
    (.learn-template testdic-nofile janome-text-1 parts)
    (assert (in index testdic-nofile.template))
    (assert (= (get testdic-nofile.template index) [janome-template-1])))

  (defn test-learn-duplicated [self testdic-nofile janome-text-1 janome-nouns-1]
    (setv parts (analyze janome-text-1)
          index (len janome-nouns-1))
    (.learn-template testdic-nofile janome-text-1 parts)
    (setv expected (-> (get testdic-nofile.template index) len))
    (.learn-template testdic-nofile janome-text-1 parts)
    (assert (= (-> (get testdic-nofile.template index) len) expected))))

(defclass TestDictionarySave []
  (defn test-make-dirs [self tmp-path]
    (setv dicfile (/ tmp-path "unmo" "file.json"))
    (try
      (setv dictionary (Dictionary dicfile))
      (except [e DictionaryNotFound]
        (setv dictionary e.dictionary-instance)))
    (.save dictionary)
    (assert (os.path.exists dicfile)))

  (defn test-write-file [self testdic-nofile tmp-dicfile]
    (try
      (setv dictionary (Dictionary tmp-dicfile))
      (except [e DictionaryNotFound]
        (setv dictionary e.dictionary-instance)))
    (setv text "Hi, chatbot!"
          parts (analyze text))
    (.learn dictionary text parts)
    (.save dictionary)
    (setv dictionary (Dictionary tmp-dicfile))
    (assert (= (len dictionary.random) 1))
    (assert (in text dictionary.random)))

  (defn test-raises-dictionary-file-not-found [self]
    (with [(pytest.raises DictionaryNotFound)]
      (Dictionary "file-not-exists"))))

(defclass TestRandom []
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
    (.learn-random testdic-nofile text)
    (assert (in text testdic-nofile.random))
    (.learn-random testdic-nofile text)
    (assert (= (len testdic-nofile.random) 1))))

(defclass TestPattern []
  (defn test-pattern-without-dict-file [self testdic-nofile]
    (assert (= testdic-nofile.pattern {})))

  (defn test-pattern [self testdic]
    (assert (= testdic.pattern *TEST-PATTERN*)))

  (defn test-pattern-learn [self janome-text-1 janome-nouns-1 testdic-nofile]
    (.learn-pattern testdic-nofile janome-text-1 (analyze janome-text-1))
    (assert (= (len testdic-nofile.pattern) (len janome-nouns-1)))
    (for [noun janome-nouns-1]
      (assert (= (get testdic-nofile.pattern noun) [janome-text-1]))))

  (defn test-pattern-learn-another [self testdic-nofile
                                    janome-text-1 janome-nouns-1
                                    janome-text-2 janome-nouns-2]
    (.learn-pattern testdic-nofile janome-text-1 (analyze janome-text-1))
    (.learn-pattern testdic-nofile janome-text-2 (analyze janome-text-2))
    (for [noun janome-nouns-2]
      (assert (= (get testdic-nofile.pattern noun) [janome-text-1 janome-text-2]))))

  (defn test-pattern-learn-escape-re-literals [self testdic-nofile]
    (setv text "(")
    (.learn-pattern testdic-nofile text (analyze text))
    (assert (= (-> testdic-nofile.pattern (.keys) (list) (first))
               (re.escape text)))))
