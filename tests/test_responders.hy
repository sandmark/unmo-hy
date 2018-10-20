(import [unmo.responders [Responder]]
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
