; ----------------------------------------------------------------------------------------------------------------

; pb 3.2 (extension of pb 3.1) [SOLUTION WITH FLUENTS]

; ----------------------------------------------------------------------------------------------------------------



(define (domain injured-people-scenario)

(:requirements :strips :typing :negative-preconditions :equality :disjunctive-preconditions :fluents)

(:types 

    person - object
    
    place - object
    location warehouse - place ; warehouse is used to def the depot as a constant 
                               ; (since all the cretes are located at the depot in all problem instances)
    robot - object
    crate - object
    medicine food - crate 

    carrier - object ; added separate type for carrier

)

(:constants 
   
    agent - robot  ; we use a separate type for robotic agents, which currently happens to have a single member in all problem instances.
    
    depot - warehouse ; in each problem the crates are positioned at the depot -> each problem must have a depot where crates are stored, so its a constant
)

(:predicates 

    ; localzation of robots, people, crates and carriers
    (robot_at ?r - robot ?pl - place)
    (person_at ?p - person ?pl - place)
    (crate_at ?c - crate ?pl - place)
    (carrier_at ?k - carrier ?pl - place) ; supposed robot and carrier move together (the robot is the one controlling the carrier)

    (has_crate ?p - person ?c - crate)
    (carrying ?k - carrier ?c - crate) ; carrier k is holding crate c

)

(:functions

    (num_crates_carrier ?k - carrier) ; keep track of how many crates the carrier k is holding (max 4)
   
)


; pick up a single crate and load it on the robotic agent, if it is at the same location as the crate
; note: all the crates are located at the depot (warehouse) -> r, c, k must all be at the same loc wh
(:action load
    :parameters (?r - robot ?c - crate ?k - carrier ?wh - warehouse)
    :precondition (and (crate_at ?c ?wh) (robot_at ?r ?wh) (carrier_at ?k ?wh) (not (carrying ?k ?c)) 
                   (< (num_crates_carrier ?k) 4) ) ; check if #crates < capacity -> possible to load crate
    :effect (and (carrying ?k ?c) (not (crate_at ?c ?wh)) (increase (num_crates_carrier ?k) 1))
)

; deliver a crate to a specific person who is at the same location (generic location l)
(:action unload
    :parameters (?r - robot ?c - crate ?p - person ?l - location ?k - carrier)
    :precondition (and (carrying ?k ?c) (robot_at ?r ?l) (carrier_at ?k ?l) (person_at ?p ?l) (> (num_crates_carrier ?k) 0)) ; if #crates > 0 
    :effect (and (has_crate ?p ?c) (not (carrying ?k ?c)) (decrease (num_crates_carrier ?k) 1))
)

;move to another location moving the loaded crate;
; it may also start from the depot at the beginning -> so it starts from a place (more generic, includes bot loc and wh) and arrives at a certain location dst
(:action move_to_deliver
    :parameters (?r - robot ?k - carrier ?src - place ?dst - location) ; place because it may start from the depot
    :precondition (and (robot_at ?r ?src) (carrier_at ?k ?src) (not (= ?src ?dst)) )
    :effect (and (not (robot_at ?r ?src)) (not (carrier_at ?k ?src) ) (robot_at ?r ?dst) (carrier_at ?k ?dst))
)


; carrier moves back to depot when num_crates = 0 (empty), strating from a certain location
; need to def depot as a specific location -> modelled as a const of type warehouse 
; so it'll be possible to extend the problem with other warehouse if needed
(:action move_to_depot
    :parameters (?r - robot ?k - carrier ?src - location ?dst - warehouse)
    :precondition (and (robot_at ?r ?src) (carrier_at ?k ?src) (= (num_crates_carrier ?k) 0)) ; if #crates = 0 go back to depot
    :effect (and (not (robot_at ?r ?src)) (not (carrier_at ?k ?src)) (robot_at ?r ?dst) (carrier_at ?k ?dst))
)


)