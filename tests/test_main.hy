(import [unmo.main [Unmo prompt]]
        pytest)

(with-decorator (pytest.fixture)
  (defn unmo []
    (Unmo 'test)))

(defn test-prompt [unmo]
  (assert (= (prompt unmo)
             "test:What> ")))
