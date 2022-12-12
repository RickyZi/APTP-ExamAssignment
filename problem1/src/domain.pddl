;domain file for the problem 3.1 of the assigment
;definition of the the injured people scenario

; ---------------------------------------------------

(define (domain injured-people-scenario)

(:requirements  :strips :typing :negative-preconditions :equality :disjunctive-preconditions) 

(:types 

    location - object
    robot - object
    person - object
    crate - object
    medicine food - crate ;crate content modelled in a generic way -> "expand" type crate as medicine or food (easier to add new kind of crate)
    
)

(:constants 
    agent - robot
    depot - location ; since it appears in all problem instances may also be considered as a const
)

(:predicates 

    ;(at ?obj - object ?l - location) ; generic

    ; localization of robots, people and crates (redundant but more intuitive)
    (robot_at ?r - robot ?l - location)
    (person_at ?p - person ?l - location)
    (crate_at ?c - crate ?l - location)

    (has_crate ?p - person ?c - crate) ; the person has a certain crate (medicine and/or food)
    (carrying ?r - robot ?c - crate) ; robot is carrying a certain  crate

    (free ?r - robot) ; the robot is not carrying any crate
)

; actions

; pick up a single crate and load it on the robotic agent, if it is at the same location as the crate
(:action load
    :parameters (?r - robot ?c - crate ?l - location)
    :precondition (and (crate_at ?c ?l) (robot_at ?r ?l) (not (carrying ?r ?c)) (free ?r)) 
    ; crate and robot must be at the same loc and robot must not be already carrying a crate
    ; since it can only pick up a single crate
    :effect (and (carrying ?r ?c) (not (free ?r)) (not (crate_at ?c ?l)))
)

; deliver a crate to a specific person who is at the same location
(:action unload
    :parameters (?r - robot ?c - crate ?p - person ?l - location)
    :precondition (and (carrying ?r ?c) (robot_at ?r ?l) (person_at ?p ?l)) ; r and p must be at the same location
    :effect (and (free ?r) (has_crate ?p ?c) (not (carrying ?r ?c)) ) ; resutl: p has c and r is now free (no more holding c)
)

;move to another location moving the loaded crate;
(:action move
    :parameters (?r - robot ?src ?dst - location)
    :precondition (and (robot_at ?r ?src) (not (= ?src ?dst))) ; src!= dst to actually move
    :effect (and (not (robot_at ?r ?src)) (robot_at ?r ?dst))
)

)