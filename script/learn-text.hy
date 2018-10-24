#!/usr/bin/env hy

(import [tqdm [tqdm]]
        [unmo.dictionary [Dictionary]]
        [unmo.exceptions [DictionaryNotFound]]
        [unmo.morph [analyze]])

(defn readfile [filename]
  (with [f (open filename :encoding 'utf-8)]
    (-> (.read f)
        (.replace "\n" "")
        (.replace "。" "。\n")
        (.replace "　" "")
        (.replace "「" "")
        (.split "」")
        (->> (.join "\n")))))

(defmain [&rest args]
  (try
    (setv dictionary (Dictionary))
    (except [e DictionaryNotFound]
      (setv dictionary e.dictionary-instance)))
  (.save dictionary)
  (for [line (-> (second args) (readfile) (.split "\n") (tqdm))]
    (.learn dictionary line (analyze line)))
  (.save dictionary))
