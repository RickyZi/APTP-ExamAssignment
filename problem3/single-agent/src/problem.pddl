(define (problem problem_two) (:domain injured-people-scenario)
(:objects 

    l1 l2 l3 l4 - location
    alice bob mary dave - person

    f0 f1 f2 f3 - crate
    m0 m1 m2 m3 - crate

    q1 q2 q3 q4 - crates_quantity ; how many creates the carrier is holding (1, 2, 3, 4)

    carr0 - carrier
    food medicine - supply
)

(:init
    
    (person_at alice l1)
    (person_at bob l2)
    (person_at mary l3)
    (person_at dave l4)

    (crate_content f0 food) (crate_content f1 food) (crate_content f2 food) (crate_content f3 food)
    (crate_content m0 medicine) (crate_content m1 medicine) (crate_content m2 medicine) (crate_content m3 medicine)

    (crate_at f0 depot) (crate_at f1 depot) (crate_at f2 depot) (crate_at f3 depot)
    (crate_at m0 depot) (crate_at m1 depot) (crate_at m2 depot) (crate_at m3 depot)

    (robot_at agent depot)
    (carrier_at carr0 depot)

    (num_crates carr0 q0) ; carrier "free" otherwise cannot laod crates (closed world assumption)

    ; def relations between the diff "quantity of crates" carrier can hold
    (inc q0 q1) (inc q1 q2) (inc q2 q3) (inc q3 q4)
    (dec q4 q3) (dec q3 q2) (dec q2 q1) (dec q1 q0)

    (free agent) ; agent needs to be free in order to load/unload crates (closed world assumption)

    ; def what crates the people need (close word assumption)

    ; alice only wants food 
    (needs alice food) (does_not_need alice medicine)

    ; bob only wants medicine
    (needs bob medicine) (does_not_need bob food)

    ; mary wants food and medicine 
    (needs mary food) (needs mary medicine)

    ; dave neither wants either food or medicine

    (does_not_need dave food) (does_not_need dave medicine)


    ; NOTE: the goal will be to reach the (does_not_need ?p ?res), meaning the person has obtained the desired supply crate

)

(:goal (and

    ; OPTIC DOESN'T SUPPORT DISJUNCTIVE PRECOND

    ; alice only wants food 
    (does_not_need alice food) (does_not_need alice medicine) 
    
    ; bob only wants medicine
    (does_not_need bob food) (does_not_need bob medicine)

    ; mary wants food and medicine
    (does_not_need mary food) (does_not_need mary medicine)

    ; dave doesn't want anything
    (does_not_need dave food) (does_not_need dave medicine)

    ; ---------------------------------------------------------------------------------
    ; additional goal: make robot agent (and carrier) go back to depot for new delivery
    (robot_at agent depot)  (carrier_at carr0 depot)
)
)

(:metric minimize (total-time))

)