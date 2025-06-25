;; steps for the algorithm
;; 1. Initializing a random population of individuals
;; 2. Finding fitness of an individual 
;; 3. Selecting the parent  
;; 4. crossing over the parents  
;; 5. mutate

;; INITIALIZATION

;; initialize population and put it in the atomic space
!(bind! population (
(0 1 0 0 1 1)
(1 0 1 1 0 1) 
(1 1 1 0 0 0)
(0 0 1 1 1 1)))

;; FINDING FITNESS
;; function to find fitness of an individual from the population
(= (get-fitness ()) 0)
(= (get-fitness $list) (
    + (car-atom $list) (get-fitness (cdr-atom $list))
))


;; SELECTION PROCESS
;;function to calculate total fitness
(= (total-fitness $population) (
    if (== $population ())
        0
        (+ (get-fitness (car-atom $population)) (total-fitness (cdr-atom $population)))
))

!(add-reduct &self (total (let $x (total-fitness population) $x)))

; !("total fitness")
; !(match &self (total $x) $x)

;; function to reverse the tuple
(= (reverse $list $acc) (
    if (== $list ())
        $acc
        (let* (
            ($current (car-atom $list))
            ($rest (cdr-atom $list))
            ($new-acc (cons-atom $current $acc))
        ) 
        (reverse $rest $new-acc)
    ))
)



;;Implement individual probability 
(= (individual-probability $individual $total-fitness)
   (if (== $total-fitness 0)
       0.0
       (/ (* (get-fitness $individual) 1.0) (* $total-fitness 1.0))))

; !("Individual probability")
; !(individual-probability (1 0 0 0 1 1) 14)


;; implementing probability wheel 
(= (wheel $population $acc)
   (if (== $population ())
       $acc  
       (wheel 
           (cdr-atom $population)  
           (cons-atom 
               (individual-probability (car-atom $population) (match &self (total $x) $x)) 
               $acc)))) 


!(add-reduct &self (proba-wheel (let $x (wheel population ()) $x)))

; !("The notorious wheel")
; !(match &self (proba-wheel $x) $x)

;; functoin to implement the cumulative wheel
(= (cumulative-wheel $probability-wheel $runningSum $acc)
    (if (== $probability-wheel ())
        $acc
        (cumulative-wheel (cdr-atom $probability-wheel) (+ $runningSum (car-atom $probability-wheel)) (cons-atom (+ $runningSum (car-atom $probability-wheel)) $acc))
    )
)


; !(cumulative-wheel (match &self (proba-wheel $x) $x) 0 () )

!(add-reduct &self (final-wheel (let $x (reverse (cumulative-wheel (match &self (proba-wheel $x) $x) 0 ()) ()) $x)))

; !("The final version")
; !(match &self (final-wheel $x) $x)


;; implement function to find the index
(= (find-index $list $val)
    (if (== $list ())
        0
        (let ($head $tail) (decons-atom $list) 
        (if (>= $head $val)
            0
            (+ 1 (find-index $tail $val))))))

;; function to find a potential parent
(= (get-parent)
    (let $x (match &self (final-wheel $y) (find-index $y (random-float &rng 0 1))) (index-atom population $x))
)

;; mutation


;;CROSSING OVER

;; function to find the first half of a parent
(= (get-first-half $list $acc $temp) (
    let* (
        ($current (car-atom $list))
        ($rest (cdr-atom $list))
        ($new-acc (cons-atom $current $acc))
        ($new-temp (+ $temp 1))
    )
    (if (== $new-temp 3)
        $new-acc
        (get-first-half $rest $new-acc $new-temp)
    )
))

;; function to find the second half of a parent
(= (get-second-half $list $acc $temp) (
    let* (
        ($current (car-atom $list))
        ($rest (cdr-atom $list))
        ($new-temp (+ $temp 1))
        ($new-acc (if (>= $temp 3) (cons-atom $current $acc) ()))
    )
    (if (== $new-temp 6) 
        $new-acc
        (get-second-half $rest $new-acc $new-temp)
    )
))

;; function to perform crossing over
(= (crossover $parent1 $parent2) (
    let* (
        ($parent1-left (get-first-half $parent1 () 0))
        ($parent1-right (get-second-half $parent1 () 0))
        ($parent2-left (get-first-half $parent2 () 0))
        ($parent2-right (get-second-half $parent2 () 0))
        ($child1 (union-atom $parent1-left $parent2-right))
        ($child2 (union-atom $parent2-left $parent1-right))
    )
    ($child1 $child2)
))



; !("child1 and child2 from parent1 and parent2")
; !(crossover (get-parent) (get-parent))

;; MUATATION

;; function to mutate an offspring
(= (muatate $bit)
    (if (== $bit 0) 1 0)
)
