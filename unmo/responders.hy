(import [random [choice]])

(defclass Responder []
  (defn __init__ [self name]
    (setv self._name name))

  (defn response [self text]
    (-> "{text}ってなに？" (.format :text text)))

  (with-decorator property
    (defn name [self] self._name)))

(defclass RandomResponder []
  [responses ["今日はさむいね" "チョコたべたい" "きのう10円ひろった"]]
  (defn --init-- [self name]
    (setv self._name name))

  (defn response [self _]
    (choice self.responses))

  (with-decorator property
    (defn name [self] self._name)))
