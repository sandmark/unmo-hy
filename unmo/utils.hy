(import [collections [defaultdict]])

(defn map-dict [f dic]
  (-> (map (fn [kv] (f #* kv)) (.items dic))
      (dict)))

(defn dict-all [dic]
  (defn f [key value]
    (if (= (type value) defaultdict)
      (, key (map-dict f value))
      (, key value)))
  (map-dict f dic))
