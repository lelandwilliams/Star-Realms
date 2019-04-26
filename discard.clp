(defmodule DISCARD
	(import MAIN ?ALL))

(deftemplate choices
	(multislot ids (type INTEGER))
	(multislot cardname (type STRING)))

(defrule debugswitch "runs when entering DISCARD module"
	(declare (salience 100))
	(turn (player ?player))
;	(not (discard))
	?p <- (player 
		(name ?player) 
		(discard ?d)
		(playertype ?ptype))
	=>
	;(printout t crlf "In module DISCARD")
	(if (neq 0 ?d) then
		;(printout t crlf ?player " must choose a card to discard" crlf)
		; the next statement should be replaced by a focus shift eventually
		(if (eq ?ptype HUMAN) then (assert (nextchoice 1)))
		(assert (choices))
	else
		(printout t " - no discard necessary" crlf)
		(assert (playerchoice))
	)
)

(defrule gatheroptions "Get the Name of a card id in player's hand and add it  to choices fact"
	(turn (player ?player))
	?p <- (player (name ?player) (hand $?before ?id $?after))
	(card (id ?id) (name ?name))
	?c <- (choices (ids $?cardids) (cardname $?cardnames))
	(test (not (member$ ?id $?cardids)))
	=>
	(modify ?c (ids $?cardids ?id) (cardname $?cardnames ?name))
)

(defrule end-gatheroptions "When all cards have been added to options, promt for a choice"
	(not (choice))
	(turn (player ?player))
	?p <- (player (name ?player) (hand $?hand))
	?c <- (choices (ids $?cardids) (cardname $?cardnames))
	(test (= (length$ $?hand) (length$ $?cardnames)))
	=>
	(assert (choice -1))
	(printout t crlf ?player " must choose a card to discard" crlf)
	(loop-for-count (?n (length$  $?cardnames)) do
		(printout t ?n ") " (nth$ ?n $?cardnames) crlf))
)

(defrule process_discard_choice "If choice is valid, assert it"
	?c <- (choice ?choice)
	?cs <- (choices (cardname $?cardnames))
	(test (> ?choice 0))
	(test (<= ?choice (length$ $?cardnames)))
	=>
	(retract ?cs)
	(retract ?c)
	(assert (discard (nth$ ?choice $?cardnames)))
)

(defrule process_discard "Do the bookkeeping corrisponding to a discard"
	(turn (player ?player))
	?dc <- (discard ?name)
	(card (name ?name) (id ?id))
	?p <- (player (name ?player) 
		(discardpile $?discards) 
		(hand $?before ?id $?after)
		(discard ?d&: (> ?d 0)))
	=>
	(assert (anounce (player ?player) (eventtype "discarded") (num ?id)))
	(retract ?dc)
	(modify ?p 
		(hand $?before $?after) 
		(discardpile ?id $?discards)
		(discard (- ?d 1)))
)

(defrule promptchoice-human "Prompt a human to choose a card to discard"
	(choices)
	?c <- (choice ?choice)
	(turn (player ?player)) 
	?p <- (player (name ?player) (hand $?hand) (playertype HUMAN))
	(test (or (< ?choice 1) (> ?choice (length$ $?hand))))
	=>
	(retract ?c)
	(printout t "Choice -> ")
	(assert (choice (read)))
	)
	
; **************************************************
; *    Rules for RANDOM players
; **************************************************
	
(defrule random-discard "discard routine for RANDOM player"
	?c <- (choice ?choice)
	(turn (player ?player)) 
	?p <- (player 
		(name ?player) 
		(hand $?hand)
		(playertype RANDOM) 
		(discard ?d&:(> ?d 0))
		(discardpile $?pile))
	=>
	(retract ?c)
	(printout t crlf ?player " must randomly choose a card to discard" crlf)
	(bind ?idx (random 1 (length$ $?hand)))
	(bind ?choice (nth$ ?idx $?hand))
	(assert (anounce (player ?player) (eventtype "discarded") (num ?choice)))
	(modify ?p (discard (- ?d 1)) (hand (delete$ $?hand ?idx ?idx)))
	)

