(import [collections [defaultdict]]
        [unmo.utils [dict-all]])
(require [unmo.macro [*]])

(defclass Markov []
  [ENDMARK   "%END%"
   CHAIN_MAX 30]

  (prop dic (dict-all self.-dic))

  (defn --init-- [self]
    (setv self.-dic (defaultdict (fn [] (defaultdict (fn [] []))))
          self.-starts (defaultdict (fn [] 0))))

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
    (assoc self.-starts prefix1 (inc (get self.-starts prefix1)))))
