(import [unmo.main [prompt]]
        [unmo.bot [Bot]]
        pytest)

(with-decorator (pytest.fixture)
  (defn unmo []
    (Bot 'test)))

(defn test-prompt [unmo]
  (assert (= (prompt unmo)
             "test:What> ")))
