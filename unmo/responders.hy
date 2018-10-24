(import [random [choice]]
        re
        [unmo.exceptions [DictionaryEmpty]]
        [unmo.morph [noun?]])
(require [unmo.utils [*]])

(defclass Responder []
  (prop name self._name)

  (defn --init-- [self name dictionary]
    (setv self._name name
          self._dictionary dictionary))

  (defn response [self &rest args]
    (raise NotImplementedError)))

(defclass WhatResponder [Responder]
  (defn response [self text &rest args]
    (-> "{text}ってなに？" (.format :text text))))

(defclass RandomResponder [Responder]
  (prop responses self._dictionary.random)

  (defn response [self &rest args]
    (try
      (choice self.responses)
      (except [e IndexError]
        (raise (DictionaryEmpty "ランダム辞書が空です。" e))))))

(defclass PatternResponder [Responder]
  (defn response [self text &rest args]
    (try
      (for-with-result [result (choice self._dictionary.random)]
                       [(, ptn responses) (.items self._dictionary.pattern)]
        (ap-when (re.search ptn text)
          (setv result (-> (choice responses) (.replace "%match%" (.group it 0))))))
      (except [e IndexError]
        (raise (DictionaryEmpty "パターン辞書が空です。" e))))))

(defclass TemplateResponder [Responder]
  (defn response [self text parts]
    (setv nouns (->> (filter (fn [x] (noun? #* x)) parts)
                     (map first)
                     (list))
          counter  (len nouns)
          key (str counter))
    (if (and (pos? counter)
             (in key self._dictionary.template))
      (let ((template (->> (get self._dictionary.template key)
                           (choice))))
        (for [noun nouns]
          (setv template (.replace template "%noun%" noun 1)))
        template)
      (try
        (choice self._dictionary.random)
        (except [e IndexError]
          (raise (DictionaryEmpty "ランダム辞書が空です。" e)))))))
