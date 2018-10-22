(import pytest
        [unmo.responders [Responder]]
        [fixtures [*]])

(defclass Responder []
  (defn test-response-raises [self]
    (with (pytest.raises NotImplementedError)
      (.response (Responder 'test) "test"))))

(defclass TestWhatResponder []
  (defn test-property-name [self what]
    (assert (= what.name "test")))

  (defn test-responder-says-what [self what]
    (setv text "テスト")
    (assert (= (.response what text) "テストってなに？"))))

(defclass TestRandomResponder []
  (defn test-property-name [self random]
    (assert (= random.name 'random)))

  (defn test-response-randomly [self random testdic]
    (assert (in (.response random "test")
                testdic.random))))

(defclass TestPatternResponder []
  (defn test-response-match [self pattern]
    (assert (= (.response pattern "テストチョコテスト") "チョコおいしいよね"))
    (assert (= (.response pattern "テストチョコレートテスト")
               "チョコレートおいしいよね")))

  (defn test-response-multiple [self pattern testdic]
    (assert (in (.response pattern "テストこんにちはテスト")
                (get *TEST-PATTERN* "こんにちは")))))
