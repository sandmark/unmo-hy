(import pytest
        [unmo.main [prompt]]
        [fixtures [*]])

(defn test-prompt [unmo]
  (assert (= (prompt unmo)
             (-> "{name}:{responder}> "
                 (.format :name unmo.name
                          :responder unmo.responder-name)))))
