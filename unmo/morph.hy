(import re
        [janome.tokenizer [Tokenizer]])
(require [unmo.macro [*]])

(defn-with-closure [[tokenizer (Tokenizer)]]
  (defn analyze [text]
    (->> (.tokenize tokenizer text)
         (map (fn [token] (, token.surface token.part-of-speech)))
         (list))))

(defn noun? [surface part]
  (cond [(= surface "ー") False]
        [True (->> part (re.match r"名詞,(一般|代名詞|固有名詞|サ変接続|形容動詞語幹)") bool)]))

(defn re-escape [s]
  (re.sub r"[(){}\[\].*?|^$\\+-]" r"\\\g<0>" s))
