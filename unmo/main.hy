(import [unmo.bot [Bot]]
        [unmo.exceptions [BotDictionaryLoadError DictionaryEmpty]])

(defn prompt [unmo]
  (.format "{name}:{responder}> "
           :name unmo.name
           :responder unmo.responder-name))

(defmain [args]
  (print "Unmo System prototype : proto")
  (try
    (setv proto (Bot 'proto))
    (except [e BotDictionaryLoadError]
      (-> "警告: 辞書ファイル '{}' の読み込みに失敗しました。空の辞書を使用します。"
          (.format e.dictionary-file)
          (print))
      (setv proto e.bot-instance)))
  (while True
    (setv text (input "> "))
    (when (not text)
      (break))

    (try
      (setv response (.dialogue proto text))
      (-> (.format "{prompt}{response}"
                   :prompt (prompt proto)
                   :response response)
          (print))
      (except [e DictionaryEmpty]
        (-> "警告: {}" (.format e.message) print))))
  (.save proto))
