(import pytest
        json
        [unmo.bot [Bot]]
        [unmo.responders [WhatResponder
                          RandomResponder
                          PatternResponder
                          TemplateResponder]]
        [unmo.dictionary [Dictionary]]
        [unmo.exceptions [DictionaryNotFound]])

(setv *TEST-RANDOM*    ["aaa" "bbb" "ccc"]
      *TEST-PATTERN*   {"チョコ(レート)?" ["%match%おいしいよね"]
                        "こんにちは" ["おはよう" "こんにちは" "こんばんは"]}
      *TEST-TEMPLATE*  {2 ["%noun%って%noun%だよね"]
                        3 ["%noun%は%noun%の%noun%です" "この間%noun%に行ったら%noun%の%noun%に会ったよ"]})

(with-decorator (pytest.fixture)
  (defn janome-text-1 [] "あたしは平和なプログラムの女の子です。"))

(with-decorator (pytest.fixture)
  (defn janome-text-2 [] "女の子のプログラムで平和なのはあたしです。"))

(with-decorator (pytest.fixture)
  (defn janome-nouns-1 [] ["あたし" "平和" "プログラム" "女の子"]))

(with-decorator (pytest.fixture)
  (defn janome-nouns-2 [] ["女の子" "プログラム" "平和" "あたし"]))

(with-decorator (pytest.fixture)
  (defn janome-tokenized-1 []
    [(, "あたし"    "名詞,代名詞,一般,*")
     (, "は"       "助詞,係助詞,*,*")
     (, "平和"     "名詞,形容動詞語幹,*,*")
     (, "な"       "助動詞,*,*,*")
     (, "プログラム" "名詞,サ変接続,*,*")
     (, "の"       "助詞,連体化,*,*")
     (, "女の子"    "名詞,一般,*,*")
     (, "です"     "助動詞,*,*,*")
     (, "。"       "記号,句点,*,*")]))

(with-decorator (pytest.fixture)
  (defn janome-nouns-bool-1 [] [True False True False True False True False False]))

(with-decorator (pytest.fixture)
  (defn janome-template-1 [] "%noun%は%noun%な%noun%の%noun%です。"))

(with-decorator (pytest.fixture)
  (defn janome-template-2 [] "%noun%って%noun%だよね"))

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

    (setv data {"random"   *TEST-RANDOM*
                "pattern"  *TEST-PATTERN*
                "template" *TEST-TEMPLATE*})
    (with [f (open p 'w :encoding 'utf-8)]
      (json.dump data f :ensure-ascii False :indent 2))
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

(with-decorator (pytest.fixture)
  (defn template [testdic]
    (TemplateResponder 'template testdic)))
