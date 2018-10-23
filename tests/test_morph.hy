(import [unmo.morph [analyze noun?]]
        [fixtures [*]])

(defclass TestMorph []
  (defn test-analyze [self janome-text-1 janome-tokenized-1]
    (assert (= (analyze janome-text-1) janome-tokenized-1)))

  (defn test-noun [self janome-tokenized-1 janome-nouns-bool-1]
    (for [(, pair expected) (zip janome-tokenized-1 janome-nouns-bool-1)]
      (assert (= (noun? #* pair) expected))))

  (defn test-noun-ignore-hyphen [self]
    (assert (not (noun? "ー" "名詞,固有名詞")))))
