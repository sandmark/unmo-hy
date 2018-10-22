(import pytest
        [unmo.bot [Bot]]
        [fixtures [*]])

(defclass TestBot []
  (defn test-unmo-alerts-without-dictionary [self]
    (assert (Bot 'test)))

  (defn test-unmo-dialogue-without-dictionary [self]
    (setv bot (Bot 'test))
    (assert (.dialogue bot "Hi")))

  (defn test-unmo-property-name [self unmo]
    (assert (= unmo.name "test")))

  (defn test-unmo-property-responder-name [self unmo]
    (assert (= unmo.responder-name "Random"))))
