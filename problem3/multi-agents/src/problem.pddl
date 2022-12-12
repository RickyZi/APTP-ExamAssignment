(define (problem problem_two) (:domain injured-people-scenario)
(:objects 

    l1 l2 l3 l4 l5 l6 - location
    alice bob mary dave jane peter frank - person

    f0 f1 f2 f3 f4 f5 - crate
    m0 m1 m2 m3 m4 m5 - crate
    food medicine - supply

    q1 q2 q3 q4 - quantity ; how many creates the carrier is holding (1, 2, 3, 4)
    
    agent1 - robot
    carr carr1 - carrier
    
)   

(:init
    
    (person_at alice l1)
    (person_at bob l2)
    (person_at mary l3)
    (person_at dave l4)
    (person_at jane l5)
    (person_at peter l6)
    (person_at frank l6)

    (crate_content f0 food) (crate_content f1 food) (crate_content f2 food) (crate_content f3 food) (crate_content f4 food) (crate_content f5 food) 
    (crate_content m0 medicine) (crate_content m1 medicine) (crate_content m2 medicine) (crate_content m3 medicine) (crate_content m4 medicine) (crate_content m4 medicine)

    (crate_at f0 depot) (crate_at f1 depot) (crate_at f2 depot) (crate_at f3 depot) (crate_at f4 depot) (crate_at f5 depot)
    (crate_at m0 depot) (crate_at m1 depot) (crate_at m2 depot) (crate_at m3 depot) (crate_at m4 depot) (crate_at m5 depot)

    (robot_at agent depot) (carrier_at carr depot) (has_carrier agent carr) 
    (free agent) (num_crates carr q0) ; agent and carrier "free" otherwise cannot load crates (closed world assumption)
    

    (robot_at agent1 depot) (carrier_at carr1 depot) (has_carrier agent1 carr1)
    (free agent1) (num_crates carr1 q0) 


    ; def relations between the diff "quantity of crates" carrier can hold
    (inc q0 q1) (inc q1 q2) (inc q2 q3) (inc q3 q4)
    (dec q4 q3) (dec q3 q2) (dec q2 q1) (dec q1 q0)

    ; ----------------------------------------------------------------------------
    ; def what crates the people need (close word assumption)

    ; alice only wants food 
    (needs alice food) (does_not_need alice medicine)

    ; bob only wants medicine
    (needs bob medicine) (does_not_need bob food)

    ; mary wants food and medicine 
    (needs mary food) (needs mary medicine)

    ; dave neither wants either food or medicine
    (does_not_need dave food) (does_not_need dave medicine)

    ; jane wants only food
    (needs jane food) (does_not_need jane medicine)

    ; peter only wants medicine
    (needs peter medicine) (does_not_need peter food)

    ; frank wants food and medicine
    (needs frank food) (needs frank medicine)

    ; -> the goal will be to reach the (does_not_need ?p ?res), meaning the person has obtained the desired crate

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

    ; jane wants only food
    (does_not_need jane food) (does_not_need jane medicine)

    ; peter wants only medicine
    (does_not_need peter food) (does_not_need peter medicine)

    ; frank wants food and medicine
    (does_not_need frank food) (does_not_need frank medicine)

    ; -----------------------------------------------------------------------
    ; additaional goal: make all robotc agents (and carriers) return to depot 
    (robot_at agent depot) (carrier_at carr depot)
    (robot_at agent1 depot) (carrier_at carr1 depot)

)
)

(:metric minimize (total-time))

)