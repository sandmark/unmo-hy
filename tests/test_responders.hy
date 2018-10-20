(import [unmo.responders [Responder RandomResponder]]
        pytest)

(with-decorator (pytest.fixture)
  (defn responder []
    (Responder 'test)))

(defclass TestResponder []
  (defn test-responder-property-name [self responder]
    (assert (= responder.name "test")))

  (defn test-responder-says-what [self responder]
    (setv text "テスト")
    (assert (= (.response responder text) "テストってなに？"))))

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
