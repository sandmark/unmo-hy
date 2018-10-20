(import [unmo.main [prompt]]
        [unmo.bot [Unmo]]
        pytest)

(with-decorator (pytest.fixture)
  (defn unmo []
    (Unmo 'test)))

(defn test-prompt [unmo]
  (assert (= (prompt unmo)
             "test:What> ")))
