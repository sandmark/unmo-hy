(import pytest
        [unmo.responders [Responder]]
        [unmo.exceptions [DictionaryEmpty]]
        [unmo.morph [analyze]]
        [fixtures [*]])

(defclass Responder []
  (defn test-response-raises [self]
    (with [(pytest.raises NotImplementedError)]
      (.response (Responder 'test) "test"))))

(defclass TestWhatResponder []
  (defn test-property-name [self what]
    (assert (= what.name "test")))

  (defn test-responder-says-what [self what]
    (setv text "テスト")
    (assert (= (.response what text) "テストってなに？"))))

(defclass TestRandomResponder []
  (defn test-raise-error-without-dictionary [self testdic-nofile]
    (setv random (RandomResponder 'test testdic-nofile))
    (with [e (pytest.raises DictionaryEmpty)]
      (.response random "")
      (assert (= "ランダム辞書が空です。" e.message))))

  (defn test-property-name [self random]
    (assert (= random.name 'random)))

  (defn test-response-randomly [self random testdic]
    (assert (in (.response random "test")
                testdic.random))))

(defclass TestPatternResponder []
  (defn test-raises-with-empty-dictionary [self testdic-nofile]
    (setv pattern (PatternResponder 'test testdic-nofile))
    (with [e (pytest.raises DictionaryEmpty)]
      (.response pattern "")
      (assert (= "パターン辞書が空です。" e.message))))

  (defn test-response-match [self pattern]
    (assert (= (.response pattern "テストチョコテスト") "チョコおいしいよね"))
    (assert (= (.response pattern "テストチョコレートテスト")
               "チョコレートおいしいよね")))

  (defn test-response-multiple [self pattern testdic]
    (assert (in (.response pattern "テストこんにちはテスト")
                (get *TEST-PATTERN* "こんにちは"))))

  (defn test-response-with-re-literals [self pattern testdic]
    (setv invalid-pattern "("
          parts (analyze invalid-pattern))
    (.learn testdic invalid-pattern parts)
    (assert (= (.response pattern invalid-pattern) invalid-pattern))))

(defclass TestTemplateResponder []
  (defn test-response-with-two-nouns [self template]
    (setv text "君は私"
          parts (analyze text)
          response (.response template text parts))
    (assert (or (= response "君って私だよね")
                (= response "私って君だよね")))))

(defclass TestMarkovResponder []
  (defn test-response [self markov-responder testdic]
    (setv text "私はプログラムの女の子です。"
          parts (analyze text))
    (.learn testdic text parts)
    (assert (in "プログラム" (.response markov-responder text parts)))))
