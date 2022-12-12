; ----------------------------------------------------------------------------------------------------------------

; domain file for problem 3.2 (extension of problem 3.1) [SOLUTION WITH MATH PREDICATES]

; ----------------------------------------------------------------------------------------------------------------

(define (domain injured-people-scenario)

(:requirements  :strips :typing :negative-preconditions :equality :disjunctive-preconditions)

(:types 
    person - object
    crate - object
    medicine food - crate ;crate content modelled in a generic way -> "expand" type crate as medicine or food (easier to add new kind of crate)
    robot - object
    
    ; introduced place as a more generic type for location and warehouse (depot)
    place - object
    location warehouse - place
    
    carrier - object
    quantity - object; needed to def the carrier capacity (max 4 crates) and keep count of the num of crates loaded
)


(:constants 
    agent - robot
    q0 - quantity ; q0 = carrier empty, 0 crates      
    depot - warehouse ; in all problems the crates are located at the depot intially, so it is a sort of constant
)

; interpretation of problem 2 -> there is a robotic agent on top of a carrier that controls how it moves and how many crates it carries.
; so robot and carrier actually moves together. the robot is the one in charge of moving and loading/unloading the carrier

(:predicates 
    
    ;(at ?obj - object ?pl - place) ; generic localization predicate

    ; localization of robots, people, crates abd carriers
    (robot_at ?r - robot ?pl - place)
    (person_at ?p - person ?pl - place)
    (crate_at ?c - crate ?pl - place)
    (carrier_at ?k - carrier ?pl - place) 

    (has_crate ?p - person ?c - crate) ; the person has a certain crate (medicine and/or food)
    (carrying ?k - carrier ?c - crate) ; carrier is carrying a certain  crate
    
    ; keep track #crates carried by the carrier
    (num_crates ?k - carrier ?q - quantity) ; num of crates carried by carrier

    (inc ?n ?nn - quantity) ; n+1 = nn
    (dec ?n ?nn - quantity) ; n-1 = nn
    ; used to keep track of the num of crates loaded on the carrier

)


; the robotic agent can load up to four crates onto a carrier, which all must be at the same location;
; hp: robotic agent can pick up one crate at a time. 
; i.e. q0 -> q1 (load 1 crate), q1 -> q2 (load 2 crates), q2 -> q3, q3 -> q4, q4 = max capacity
; init all crates are located at the depot (warehouse)

(:action load
    :parameters (?r - robot ?c - crate ?k - carrier ?wh - warehouse ?startq ?endq - quantity) 
    ; the robot load a certain num of crates (endq) on the carrier that may be holding some crates (starq)
    :precondition (and (crate_at ?c ?wh) (robot_at ?r ?wh) (carrier_at ?k ?wh) (not (carrying ?k ?c)) ; make sure it can load crate
        (inc ?startq ?endq) ; should be true if num of crates holded by carrier increase (endq > startq --> more crates than before)
        (num_crates ?k ?startq) ; check carrier already holding starting num of crates (i.e. starting from q0, q1, q2, ...)
    ) 
    :effect (and (carrying ?k ?c) (not (crate_at ?c ?wh)) (num_crates ?k ?endq) (not (num_crates ?k ?startq))) ; carrier is now holding q2 crates
)

; the robotic agent can unload one or more crates from the carrier to a location where it is
; also here the robotic agent unloads one crate at a time (q4 -> q3, q3->q2, ...)
(:action unload
    :parameters (?r - robot ?c - crate ?k - carrier ?p - person ?l - location ?startq ?endq - quantity)
    :precondition (and (carrying ?k ?c) (robot_at ?r ?l) (person_at ?p ?l) (carrier_at ?k ?l) 
    (dec ?startq ?endq) ; startq > endq --> less crates than before (unload)
    (num_crates ?k ?startq))
    :effect (and (has_crate ?p ?c) (not (carrying ?k ?c)) (num_crates ?k ?endq) (not (num_crates ?k ?startq))) ; resutl: p has c and r is now free (no more holding c)
)

; the robotic agent can move the carrier to a location where there are people needing supplies
; the robotic agent may continue moving the carrier to another location, unloading additional crates, and so
;  on, and does not have to return to the depot until after all crates on the carrier have been delivered

; it may also start from the depot at the beginning -> so it starts from a place (more generic, includes bot loc and wh) and arrives at a certain location dst
(:action move_to_deliver
    :parameters (?r - robot ?k - carrier ?src - place ?dst - location)
    :precondition (and (robot_at ?r ?src) (carrier_at ?k ?src) (not (= ?src ?dst)) (not (num_crates ?k q0))) ; if carrier not empty -> keep moving!
    :effect (and (robot_at ?r ?dst) (not (robot_at ?r ?src)) (carrier_at ?k ?dst) (not (carrier_at ?k ?src)))
)


; only when num_crates = 0 (carrier empty) it should return to the depot
; carrier moves back to depot when num_crates = 0 (empty), strating from a certain location
; need to def depot as a specific location -> modelled as a const of type warehouse 
; so it'll be possible to extend the problem with other warehouse if needed
(:action move_to_depot
    :parameters (?r - robot ?k - carrier ?src - location ?dst - warehouse)
    :precondition (and (robot_at ?r ?src) (carrier_at ?k ?src) 
                    (num_crates ?k q0)) ; if #crates = 0 (q0) go back to depot
    :effect (and (robot_at ?r ?dst) (not (robot_at ?r ?src)) (carrier_at ?k ?dst) (not (carrier_at ?k ?src)))
)

)