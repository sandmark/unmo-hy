(import [random [choice]])
(require [unmo.utils [*]])

(defclass Responder []
  (property name self._name)

  (defn --init-- [self name]
    (setv self._name name))

  (defn response [self &rest args]
    (raise NotImplementedError)))

(defclass WhatResponder [Responder]
  (defn response [self text]
    (-> "{text}ってなに？" (.format :text text))))

(defclass RandomResponder [Responder]
  [responses ["今日はさむいね" "チョコたべたい" "きのう10円ひろった"]]

  (defn response [self &rest args]
    (choice self.responses)))
