(import pytest
        json
        [unmo.bot [Bot]]
        [unmo.responders [WhatResponder
                          RandomResponder
                          PatternResponder]]
        [unmo.dictionary [Dictionary]]
        [unmo.exceptions [DictionaryNotFound]])

(setv *TEST-RANDOM* ["aaa" "bbb" "ccc"]
      *TEST-PATTERN* {"チョコ(レート)?" ["%match%おいしいよね"]
                      "こんにちは" ["おはよう" "こんにちは" "こんばんは"]})

(with-decorator (pytest.fixture)
  (defn tmp-dicfile [tmp-path]
    (setv directory (/ tmp-path "unmo"))
    (.mkdir directory)
    (/ directory "tmpdic.json")))

(with-decorator (pytest.fixture)
  (defn testdic-nofile []
    (try
      (Dictionary "with-no-dict-file")
      (except [e DictionaryNotFound]
        e.dictionary-instance))))

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

(with-decorator (pytest.fixture)
  (defn pattern [testdic]
    (PatternResponder 'pattern testdic)))
