(import pytest
        json
        [unmo.bot [Bot]]
        [unmo.responders [WhatResponder
                          RandomResponder]]
        [unmo.dictionary [Dictionary]])

(setv *TEST-RANDOM* ["aaa" "bbb" "ccc"]
      *TEST-PATTERN* [{"pattern" "チョコ(レート)?"
                       "phrases" ["%match%おいしいよね"]}
                      {"pattern" "こんにちは"
                       "phrases" ["おはよう" "こんにちは" "こんばんは"]}])

(with-decorator (pytest.fixture)
  (defn testdic-nofile []
    (Dictionary "with-no-dict-file")))

(with-decorator (pytest.fixture)
  (defn testdic [tmp-path]
    (setv d (/ tmp-path "unmo"))
    (.mkdir d)
    (setv p (/ d "testdic.json"))

    (setv data {"random" *TEST-RANDOM*
                "pattern" *TEST-PATTERN*})
    (with [f (open p 'w)]
      (json.dump data f))
    (Dictionary p)))

(with-decorator (pytest.fixture)
  (defn unmo [testdic]
    (Bot 'test testdic.dicfile)))

(with-decorator (pytest.fixture)
  (defn what [testdic]
    (WhatResponder 'test testdic)))

(with-decorator (pytest.fixture)
  (defn random [testdic]
    (RandomResponder 'random testdic)))
