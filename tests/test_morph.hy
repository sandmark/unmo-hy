(import [unmo.morph [analyze noun?]]
        [fixtures [*]])

(defclass TestMorph []
  (defn test-analyze [self janome-text janome-tokenized]
    (assert (= (analyze janome-text) janome-tokenized)))

  (defn test-noun [self janome-tokenized janome-nouns-bool]
    (for [(, pair expected) (zip janome-tokenized janome-nouns-bool)]
      (assert (= (noun? #* pair) expected))))

  (defn test-noun-ignore-hyphen [self]
    (assert (not (noun? "ー" "名詞,固有名詞")))))
