(defclass DictionaryError [Exception])
(defclass DictionaryFileNotFound [DictionaryError])
(defclass DictionaryEmpty [DictionaryError])
