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
