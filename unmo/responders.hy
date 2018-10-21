(import [random [choice]])
(require [unmo.utils [*]])

(defclass Responder []
  (prop name self._name)

  (defn --init-- [self name dictionary]
    (setv self._name name
          self._dictionary dictionary))

  (defn response [self &rest args]
    (raise NotImplementedError)))

(defclass WhatResponder [Responder]
  (defn response [self text]
    (-> "{text}ってなに？" (.format :text text))))

(defclass RandomResponder [Responder]
  (prop responses self._dictionary.random)

  (defn response [self &rest args]
    (try
      (choice self.responses)
      (except [e IndexError]
        "警告: ランダム辞書が空です。"))))

