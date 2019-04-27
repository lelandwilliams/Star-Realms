; **************************************************
; *		   combat.clp                      * 
; *                                                *
; * This module only is called from GAMESTATUS     *
; * It handles player combat.			   *
; *                                                *
; **************************************************

(defmodule COMBAT
	(import MAIN ?ALL))

(deftemplate gather
	(multislot names)
	(multislot ids)
	(slot gathertype)
)

; **************************************************
; *      First see if there are any outposts 
; *      in the way.
; **************************************************

(defrule gather-outposts-begin "There's outposts, so handle those"
	(not (gather))
	(not (prompt))
	(not (getprompt))
	(turn (player ?curplayer))
	(player (name ?otherplayer) (outposts $? ?))
	(test (neq ?curplayer ?otherplayer))
	=>
	(assert (gather (gathertype outposts)))
)

(defrule gather-outposts
	(not (prompt))
	(not (getprompt))
	?f <- (gather (gathertype outposts) (names $?names) (ids $?ids))
	(turn (player ?curplayer) (combat ?combat))
	(player (name ?otherplayer) (outposts $? ?id $?))
	(test (neq ?curplayer ?otherplayer))
	(test (not (member$ ?id $?ids)))
	(card (id ?id) (defense ?defense) (name ?cname))
	=>
	(if (<= ?defense ?combat) then (bind $?names (create$ $?names ?cname)))
	(bind $?ids (create$ $?ids $id))
	(modify ?f (names $?names) (ids $?ids))
)

(defrule gather-outposts-finish
	(not (prompt))
	(not (getprompt))
	(gather (gathertype outposts) (ids $?ids))
	(turn (player ?curplayer))
	(player (name ?otherplayer) (outposts $?outposts))
	(test (neq ?curplayer ?otherplayer))
	(test (= (length$ $?outposts) (length$ $?ids)))
	=>
	(assert (prompt -1))
)

; **************************************************
; *      If not outposts, look for bases
; **************************************************

(defrule gather-bases-begin "There's no outposts, so look for other bases"
	(not (gather))
	(not (prompt))
	(not (getprompt))
	(turn (player ?curplayer))
	(player (name ?otherplayer) (bases $?bases))
	(test (eq 0 (length$ $?bases)))
	=>
	(assert (gather (gathertype bases)))
)

(defrule gather-bases "Added blowupable bases to gather"
	(not (prompt))
	(not (getprompt))
	?f <- (gather (gathertype bases) (names $?names) (ids $?ids))
	(turn (player ?curplayer) (combat ?combat))
	(player (name ?otherplayer) (bases $? ?id $?))
	(test (neq ?curplayer ?otherplayer))
	(test (not (member$ ?id $?ids)))
	(card (id ?id) (defense ?defense) (name ?cname))
	=>
	(if (<= ?defense ?combat) then (bind $?names (create$ $?names ?cname)))
	(bind $?ids (create$ $?ids $id))
	(modify ?f (names $?names) (ids $?ids))
)

(defrule gather-bases-finish "All bases considered, so prompt player"
	(not (prompt ?))
	(not (getprompt))
	?f <- (gather (gathertype bases) (ids $?ids) (names $?names))
	(turn (player ?curplayer))
	(player (name ?otherplayer) (bases $?bases))
	(test (neq ?curplayer ?otherplayer))
	(test (eq (length$ $?bases) (length$ $?ids)))
	(test (not (member$ "Opponent" $?names)))
	=>
	(assert (prompt -1))
	(modify ?f (names $?names "Opponent"))
)

; **************************************************
; *      Prompt the player
; **************************************************

(defrule printoptions "Show what the options are"
	(turn (player ?name))
	(gather  (names $?names))
	?f <- (prompt ?val)
	(test (or (< ?val 1) (> ?val (length$ $?names))))
	=>
	(printout t crlf ?name ": Choose your target" crlf)
	(loop-for-count (?i 1 (length$ $?names))
		(printout t ?i ") " (nth$ ?i $?names) crlf))
	(assert (getprompt))
	(retract ?f)
)

(defrule prompt-the-human
	?f <- (getprompt)
	(turn (player ?name))
	(player (name ?name) (playertype HUMAN))
	=>
	(retract ?f)
	(printout t "Choice -> ")
	(assert (prompt (read)))
)

(defrule prompt-the-random-bot
	?f <- (getprompt)
	(turn (player ?name))
	(player (name ?name) (playertype RANDOM))
	(gather  (names $?names))
	=>
	(retract ?f)
	(if (= 1 (length$ $?names)) 
	then
		(assert (prompt 1))
	else
		(assert (prompt (random 1 (length$ $?names)))))
)
		
; **************************************************
; *      Resolve player choice
; **************************************************

(defrule destroy-outpost
	?f <- (gather (gathertype outpost) (names $?names))
	?p <- (prompt ?val)
	(test (> 0 ?val))
	(test (>= (length$ $?names) ?val))
	?t <- (turn (player ?curplayer) (combat ?combat))
	?op <- (player 
		(name ?otherplayer) 
		(outposts $?before ?id $?after) 
		(discardpile $?discards))
	(test (neq ?curplayer ?otherplayer))
	(card (name ?cardname) (defense ?defense) (id ?id))
	(test (eq ?cardname (nth$ ?val $?names)))
	=>
	(modify ?op (outposts $?before $?after) (discardpile ?id $?discards))
	(modify ?t (combat (- ?combat ?defense)))
	(retract ?f)
	(retract ?p)
	(assert (anounce (player ?curplayer) (eventtype "destroyed") (num ?id)))
	(return)
)

(defrule destroy-base
	?f <- (gather (gathertype base) (names $?names))
	?p <- (prompt ?val)
	(test (> 0 ?val))
	(test (>= (length$ $?names) ?val))
	?t <- (turn (player ?curplayer) (combat ?combat))
	?op <- (player 
		(name ?otherplayer) 
		(bases $?before ?id $?after) 
		(discardpile $?discards))
	(test (neq ?curplayer ?otherplayer))
	(card (name ?cardname) (defense ?defense) (id ?id))
	(test (eq ?cardname (nth$ ?val $?names)))
	=>
	(modify ?op (bases $?before $?after) (discardpile ?id $?discards))
	(modify ?t (combat (- ?combat ?defense)))
	(retract ?f)
	(retract ?p)
	(assert (anounce (player ?curplayer) (eventtype "destroyed") (num ?id)))
	(return)
)

(defrule hurt-opponent
	?f <- (gather (names $?names))
	?p <- (prompt ?val)
	(test (< 0 ?val))
	(test (<= ?val (length$ $?names)))
	?t <- (turn (player ?curplayer) (combat ?combat))
	?op <- (player 
		(name ?otherplayer) 
		(authority ?auth))
	(test (neq ?curplayer ?otherplayer))
	(test (eq "Opponent" (nth$ ?val $?names)))
	=>
	(modify ?t (combat 0))
	(retract ?f)
	(retract ?p)
	(modify ?op (authority (- ?auth ?combat)))
	(assert (anounce (player ?curplayer) (eventtype "hurt opponent") (num ?combat)))
	(return)
)

(defrule test-response
	?p <- (prompt ?val)
	=>
	(printout t "player chose " ?val crlf)
	)

