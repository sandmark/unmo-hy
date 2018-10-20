(import [unmo.responders [Responder WhatResponder RandomResponder]]
        pytest)

(defclass Responder []
  (defn test-response-raises [self]
    (with (pytest.raises NotImplementedError)
      (.response (Responder 'test) "test"))))

(with-decorator (pytest.fixture)
  (defn what []
    (WhatResponder 'test)))

(defclass TestWhatResponder []
  (defn test-property-name [self what]
    (assert (= what.name "test")))

  (defn test-responder-says-what [self what]
    (setv text "テスト")
    (assert (= (.response what text) "テストってなに？"))))

(with-decorator (pytest.fixture)
  (defn random []
    (RandomResponder 'random)))

(defclass TestRandomResponder []
  (defn test-property-name [self random]
    (assert (= random.name 'random)))

  (defn test-response-randomly [self random]
    (setv responses RandomResponder.responses)
    (assert (in (.response random "test")
                responses))))
