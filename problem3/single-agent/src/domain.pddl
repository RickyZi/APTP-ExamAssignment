    ; ----------------------------------------------------------------------------------------------------------------

; domain file for problem 3.3 (extension of problem 3.2) -> single agent version

; ----------------------------------------------------------------------------------------------------------------

(define (domain injured-people-scenario)

(:requirements :strips :typing :equality :durative-actions )

(:types 
    
    crate - object
    
    robot - object
    person - object
   
    place - object  ; intro place as a more generic type for location and warehouse (depot)
    location warehouse - place

    carrier - object
    crates_quantity - object; needed to def the carrier capacity (max 4 crates) and keep count of the num of crates loaded

    supply - object ; used to def the crate content -> i.e. food, medicine supplies

)

(:constants 
    agent - robot
    q0 - crates_quantity ; q0 = carrier empty, 0 crates      
    depot - warehouse ; in all problems the crates are located at the depot intially, so it is a sort of constant
)

(:predicates 
    
    ; (at ?obj - object ?pl - place) ; generic localization predicate

    ; localization of robots, people, crates abd carriers
    (robot_at ?r - robot ?pl - place)
    (person_at ?p - person ?pl - place)
    (crate_at ?c - crate ?pl - place)
    (carrier_at ?k - carrier ?pl - place) ; robotic agent moves together with the carrier (redundant?)

    ; check who has the crates, carrier or person
    (has_crate ?p - person ?c - crate) ; the person has a certain crate (medicine and/or food)
    (carrying ?k - carrier ?c - crate) ; carrier is carrying a certain crate

    ; keep track #crates carried by the carrier
    (num_crates ?k - carrier ?q - crates_quantity) ; num of crates carried by carrier

    ; def relat between loading / unloading crates 
    (inc ?n ?nn - quantity) ; n+1 = nn
    (dec ?n ?nn - quantity) ; n-1 = nn
    ; used to keep track of the num of crates loaded on the carrier

    (free ?r - robot) ; r free to grab a crate

    ; --------------------------------------------------------------
    ; new modeling of what supply people need and content of the crates to avoid using not in actions precondition
    
    (crate_content ?c - crate ?s - supply) ; def what's the content of the crate
    (needs ?p - person ?s - supply) ; person need a certain crate c (it may contain medicine, food, ....)
    (does_not_need ?p - person ?s - supply) ; person p doesn't need a certain crate c (containing food or medicine or ...)

)


;note: a robotic agent cannot pick up several crates at the same time
; same hp as in pb 3.2: agent can only load one crate at a time onto the carrier
(:durative-action load
    :parameters (?r - robot ?c - crate ?k - carrier ?wh - warehouse ?startq ?endq - crates_quantity)
    :duration (= ?duration 2)
    
    :condition (and 
        (at start (and 
            (robot_at ?r ?wh)
            (crate_at ?c ?wh)
            (carrier_at ?k ?wh)

            (inc ?startq ?endq) ; want to load a new crate, so increase the num of crates k is already holding (q0->q1, q1->q2, ...)
            (free ?r) ; agent must be free to grab a new crate to load onto carrier k
        ))
        (over all (and 
            (num_crates ?k ?startq) ; for all the duration of the action k has startq num of crates -> no other agent can load other crates onto k
        ))
    )
    
    :effect (and 
        (at start (and 
            (not (free ?r)) ; agent is holding a crate
        ))
        (at end (and 
            (carrying ?k ?c) ; crate loaded onto carrier 
            (not (crate_at ?c ?wh)) ; k is holding c -> c no more at depot
            (num_crates ?k ?endq) ; num of crates carried increase (i.e. q0 -> q1)
            (not (num_crates ?k ?startq)) 
            (free ?r) ; once crate loaded into carrier r return free
        ))
    )
)


(:durative-action unload
    :parameters (?r - robot ?c - crate ?s - supply ?p - person ?k - carrier ?l - location ?startq ?endq - crates_quantity)
    :duration (= ?duration 3) ; slightly more time due to interaction with person
    
    :condition (and 
        (at start (and 
            (robot_at ?r ?l)
            (carrier_at ?k ?l)
            (person_at ?p ?l)

            (dec ?startq ?endq)
            (carrying ?k ?c)
            (free ?r)
            (crate_content ?c ?s)
            (needs ?p ?s); give to person p the desired supply (food/medicine)
        ))
        (over all (and 
            (num_crates ?k ?startq) ; to avoid more than one crates to be unloaded at one time
        ))
    )
    :effect (and 
        (at start (and 
            (not (free ?r)) ; agent is holding the crate to deliver to person p
        ))
        (at end (and 
            (has_crate ?p ?c)
            (not (carrying ?k ?c))
            (does_not_need ?p ?s)
            (not (needs ?p ?s))
            (num_crates ?k ?endq)
            (not (num_crates ?k ?startq))
            (free ?r)
        ))
    )
)

(:durative-action move_to_deliver
    :parameters (?r - robot ?k - carrier ?src - place ?dst - location)  ; starting point is a place meaning the agent can start from anywhere on the map (depot or location)
    :duration (= ?duration 5)
    :condition (and 
        (at start (and 
            (robot_at ?r ?src)
            (carrier_at ?k ?src)
        ))
        (over all (and 
            (free ?r) ; agent holds a crate only for loading or unloading the carrier, in this case its just moving for delivering a crate so it's free
        ))
    )
    :effect (and 
        (at start (and 
            (not (robot_at ?r ?src))
            (not (carrier_at ?k ?src))
        ))
        (at end (and 
            (robot_at ?r ?dst)
            (carrier_at ?k ?dst)
        ))
    )
)

(:durative-action move_to_depot
    :parameters (?r - robot ?k - carrier ?src - place ?dst - warehouse) 
    :duration (= ?duration 5)
    :condition (and 
        (at start (and 
            (robot_at ?r ?src)
            (carrier_at ?k ?src)
        ))
        (over all (and 
            (num_crates ?k q0) ; check no other crates will be loaded/unloaded from carrier during exec of the action
        ))
    )
    :effect (and 
        (at start (and 
            (not (robot_at ?r ?src))
            (not (carrier_at ?k ?src))
        ))
        (at end (and 
            
            (robot_at ?r ?dst)
            (carrier_at ?k ?dst)
        ))
    )
)



)