(import [copy [copy]]
        [random [choice]])
(require [unmo.macro [*]])

(defclass Markov []
  [ENDMARK   "%END%"
   CHAIN_MAX 30]

  (prop dic     self.-dic
        starts  self.-starts)

  (defn --init-- [self &optional [dic {}] [starts {}]]
    (setv self.-dic    (copy dic)
          self.-starts (copy starts)))

  (defn add-sentence [self parts]
    (when (self.-nouns3? parts)
      (setv parts (copy parts)
            prefix1 (-> (.pop parts 0) (first))
            prefix2 (-> (.pop parts 0) (first)))
      (self.-add-start prefix1)

      (for [(, suffix _) parts]
        (self.-add-suffix prefix1 prefix2 suffix)
        (setv prefix1 prefix2
              prefix2 suffix))
      (self.-add-suffix prefix1 prefix2 Markov.ENDMARK)))

  (defn -nouns3? [self parts]
    (>= (len parts) 3))

  (defn -add-suffix [self prefix1 prefix2 suffix]
    (-> self.-dic (.setdefault prefix1 {}) (.setdefault prefix2 []) (.append suffix)))

  (defn -add-start [self prefix1]
    (setv counter (-> self.-starts (.get prefix1 0)))
    (assoc self.-starts prefix1 (inc counter)))

  (defn generate [self word]
    (when self._dic
      (setv prefix1 (if (and (in word self._dic) (get self._dic word))
                      word
                      (-> self.-starts (.keys) (list) (choice)))
            prefix2 (-> self._dic (.get prefix1 {}) (.keys) (list) (choice))
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
