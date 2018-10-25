(import [collections [defaultdict]]
        [random [choice]]
        [unmo.utils [dict-all]])
(require [unmo.macro [*]])

(defclass Markov []
  [ENDMARK   "%END%"
   CHAIN_MAX 30]

  (prop dic    (dict-all self.-dic)
        starts (dict-all self.-starts))

  (defn --init-- [self &optional [dic {}] [starts {}]]
    (setv self.-dic (defaultdict (fn [] (defaultdict (fn [] []))) dic)
          self.-starts (defaultdict (fn [] 0) starts)))

  (defn add-sentence [self parts]
    (when (self.-nouns3? parts)
      (setv prefix1 (-> (first parts)  (first))
            prefix2 (-> (second parts) (first)))
      (self.-add-start prefix1)

      (for [(, suffix _) parts]
        (self.-add-suffix prefix1 prefix2 suffix)
        (setv prefix1 prefix2
              prefix2 suffix))
      (self.-add-suffix prefix1 prefix2 Markov.ENDMARK)))

  (defn -nouns3? [self parts]
    (>= (len parts) 3))

  (defn -add-suffix [self prefix1 prefix2 suffix]
    (as-> (get self.-dic prefix1) it
          (get it prefix2)
          (.append it suffix)))

  (defn -add-start [self prefix1]
    (assoc self.-starts prefix1 (inc (get self.-starts prefix1))))

  (defn generate [self word]
    (when self._dic
      (setv prefix1 (if (get self._dic word) word (-> self.-starts (.keys) (list) (choice)))
            prefix2 (-> (get self._dic prefix1) (.keys) (list) (choice))
            words   [prefix1 prefix2])
      (for [_ (range Markov.CHAIN_MAX)]
        (setv suffix (-> (get self._dic prefix1) (get prefix2) (choice)))
        (when (self.-end? suffix)
          (break))
        (.append words suffix)
        (setv prefix1 prefix2
              prefix2 suffix))
      (.join "" words)))

  (defn -end? [self word]
    (= word Markov.ENDMARK)))
