(import json)
(require [unmo.utils [*]])

(defclass Dictionary []
  [dicfile "dic/dict.json"]

  (property random self._random)
  (property dicfile self._dicfile)

  (defn --init-- [self &optional [dicfile dicfile]]
    (setv self._dicfile dicfile)
    (try
      (with [f (open dicfile)]
        (setv data (json.load f)))
      (except [e FileNotFoundError]
        (-> "警告: 辞書ファイル '{}' の読み込みに失敗しました。" (.format dicfile) (print))
        (setv data {"random" []})))
    (setv self._random (get data "random"))))
