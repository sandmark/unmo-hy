(import [unmo.bot [Bot]])

(defn prompt [unmo]
  (.format "{name}:{responder}> "
           :name unmo.name
           :responder unmo.responder-name))

(defmain [args]
  (print "Unmo System prototype : proto")
  (setv proto (Bot 'proto))
  (while True
    (setv text (input "> "))
    (when (not text)
      (break))

    (setv response (.dialogue proto text))
    (-> (.format "{prompt}{response}"
                 :prompt (prompt proto)
                 :response response)
        (print))))
