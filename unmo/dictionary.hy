(import os
        json
        [pathlib [PurePath]]
        [unmo.exceptions [DictionaryNotFound]]
        [unmo.morph [noun? re-escape]])
(require [unmo.utils [*]])

(defclass Dictionary []
  [default-dicfile "dic/dict.json"]

  (prop random   self._random
        pattern  self._pattern
        template self._template
        dicfile  self._dicfile)

  (defn --init-- [self &optional filename]
    (setv self._dicfile (if filename filename Dictionary.default-dicfile))
    (try
      (with [f (open self._dicfile :encoding 'utf-8)]
        (setv data (json.load f)))
      (except [e FileNotFoundError]
        (setv data {"random" []
                    "pattern" {}
                    "template" {}})
        (raise (DictionaryNotFound self._dicfile self e)))
      (finally
        (setv self._random   (get data "random"))
        (setv self._pattern  (get data "pattern"))
        (setv self._template (get data "template")))))

  (defn learn [self text parts]
    (self.learn-random   text)
    (self.learn-pattern  text parts)
    (self.learn-template text parts))

  (defn learn-random [self text]
    (unless (in text self._random)
      (.append self._random text)))

  (defn learn-pattern [self text parts]
    (for [(, word part) parts]
      (when (noun? word part)
        (setv word (re-escape word))
        (if (in word self.pattern)
          (-> (get self.pattern word) (.append text))
          (assoc self._pattern word [text])))))

  (defn learn-template [self text parts]
    (setv (, template counter) (self.-build-template parts))
    (unless (in counter self.template)
      (assoc self.-template counter []))
    (when (self.-new-template? template counter)
      (.append (get self.-template counter) template)))

  (defn save [self]
    (setv data {"random"   self.random
                "pattern"  self.pattern
                "template" self.template})
    (unless (os.path.exists self.dicfile)
      (setv path (PurePath self.dicfile))
      (setv directory path.parent)
      (os.makedirs directory :exist-ok True))
    (with [f (open self.dicfile 'w :encoding 'utf-8)]
      (json.dump data f :ensure-ascii False :indent 2)))

  (defn -build-template [self parts]
    (setv template ""
          counter  0)
    (for [(, word part) parts]
      (when (noun? word part)
        (setv word    "%noun%"
              counter (inc counter)))
      (setv template (+ template word)))
    (, template counter))

  (defn -new-template? [self template counter]
    (setv templates (get self.template counter))
    (and (pos? counter)
         (not (in template templates)))))
