(define (problem problem_one) (:domain injured-people-scenario)
(:objects 
    
    l1 l2 l3 l4 - location
    alice bob mary dave - person

    f0 f1 f2 f3 - food
    m0 m1 m2 m3 - medicine
)

(:init
    
    (person_at alice l1)
    (person_at bob l2)
    (person_at mary l2)
    (person_at dave l4)

    (crate_at f0 depot) (crate_at f1 depot) (crate_at f2 depot)
    (crate_at m0 depot) (crate_at m1 depot) (crate_at m2 depot)

    (robot_at agent depot)

    (free agent) ; needed otherwise agent cannot load crates (closed world assumption)
)

(:goal (and

    ;Alice wants only food
    (or (has_crate alice f0) (has_crate alice f1) (has_crate alice f2))

    ; bob wants only medicine
    (or (has_crate bob m0) (has_crate bob m1) (has_crate bob m2))

    ; mary wants food and medicine
    (or (has_crate mary f0) (has_crate mary f1) (has_crate mary f2))
    (or (has_crate mary m0) (has_crate mary m1) (has_crate mary m2))

    ; dave doesn't want neither food or medicine
    (not (or (has_crate dave f0) (has_crate dave f1) (has_crate dave f2)))
    (not (or (has_crate dave m0) (has_crate dave m1) (has_crate dave m2)))

    ;; ------------------------------------------------------------------------
    ;; additional goal: make agent return to depot to be ready for new delivery
    (robot_at agent depot)

    ;; ------------------------------------------------------------------------

    ;; alternative solution using existential quantifiers

    ;; Alice only needs food
    ;(exists (?cf - food) (has_crate alice ?cf)) 

    ;; bob only needs medicine
    ;(exists (?cm - medicine) (has_crate bob ?cm))

    ;; mary needs both food and medicine
    ;(exists (?cf - food) (has_crate mary ?cf))
    ;(exists (?cm - medicine) (has_crate mary ?cm))
    
    ;; dave doesn't need food or medicine
    ;(not (exists (?cf - food) (has_crate dave ?cf)))
    ;(not (exists (?cm - medicine) (has_crate dave ?cm)))
)
)

)
