(import pytest
        [fixtures [*]]
        [unmo.markov [Markov]])

(defclass TestMarkov []
  (defn test-data-structure [self markov markov-sentence-1 markov-sentence-2 markov-dic]
    (.add-sentence markov markov-sentence-1)
    (.add-sentence markov markov-sentence-2)
    (assert (= markov.dic markov-dic)))

  (defn test-generate [self markov]
    (.add-sentence markov (analyze "ペンのインクは黒"))
    (setv sentence (.generate markov "ペン"))
    (assert (in "黒" sentence))))
