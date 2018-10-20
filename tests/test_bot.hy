(import [unmo.bot [Bot]]
        pytest)

(with-decorator (pytest.fixture)
  (defn unmo []
    (Bot 'test)))

(defclass TestBot []
  (defn test-unmo-property-name [self unmo]
    (assert (= unmo.name "test")))

  (defn test-unmo-property-responder-name [self unmo]
    (assert (= unmo.responder-name "Random")))

  ;; (defn test-unmo-dialogue [self unmo]
  ;;   (assert (= (.dialogue unmo "テスト")
  ;;              "テストってなに？")))
  )
