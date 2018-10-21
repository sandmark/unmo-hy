(import pytest
        json
        [unmo.bot [Bot]]
        [unmo.dictionary [Dictionary]])

(setv *TEST-RANDOM* ["aaa" "bbb" "ccc"])

(with-decorator (pytest.fixture)
  (defn testdic-nofile []
    (Dictionary "with-no-dict-file")))

(with-decorator (pytest.fixture)
  (defn testdic [tmp-path]
    (setv d (/ tmp-path "unmo"))
    (.mkdir d)
    (setv p (/ d "testdic.json"))

    (setv data {"random" *TEST-RANDOM*})
    (with [f (open p 'w)]
      (json.dump data f))
    (Dictionary p)))

(with-decorator (pytest.fixture)
  (defn unmo [testdic]
    (Bot 'test testdic.dicfile)))
