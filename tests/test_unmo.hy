(import [unmo.bot [Unmo]]
        pytest)

(with-decorator (pytest.fixture)
  (defn unmo []
    (Unmo 'test)))

(defclass TestUnmo []
  (defn test-unmo-property-name [self unmo]
    (assert (= unmo.name "test")))

  (defn test-unmo-property-responder-name [self unmo]
    (assert (= unmo.responder-name "What")))

  (defn test-unmo-dialogue [self unmo]
    (assert (= (.dialogue unmo "テスト")
               "テストってなに？"))))
