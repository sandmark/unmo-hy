(defclass DictionaryError [Exception])
(defclass DictionaryNotFound [DictionaryError])
(defclass DictionaryEmpty [DictionaryError])
