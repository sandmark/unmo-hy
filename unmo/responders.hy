(import [random [choice]])

(defclass Responder []
  (defn --init-- [self name]
    (setv self._name name))

  (defn response [self &rest args]
    (raise NotImplementedError))

  (with-decorator property
    (defn name [self] self._name)))

(defclass WhatResponder [Responder]
  (defn response [self text]
    (-> "{text}ってなに？" (.format :text text))))

(defclass RandomResponder [Responder]
  [responses ["今日はさむいね" "チョコたべたい" "きのう10円ひろった"]]

  (defn response [self &rest args]
    (choice self.responses)))
