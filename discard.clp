(defmodule DISCARD
	(import MAIN ?ALL))

(deftemplate choices
	(slot choicenum (type INTEGER))
	(slot cardname (type STRING)))

(defrule debugswitch "runs when entering DISCARD module"
	(declare (salience 100))
	(turn (player ?player))
	?p <- (player 
		(name ?player) 
		(discard ?d)
		(playertype ?ptype))
	=>
	(printout t crlf "In module DISCARD")
	(if (neq 0 ?d) then
		(printout t crlf ?player " must choose a card to discard" crlf)
		; the next statement should be replaced by a focus shift eventually
		(if (eq ?ptype HUMAN) then (assert (nextchoice 1)))
	else
		(printout t " - no discard necessary" crlf)
	)
	(printout t crlf)
	)

(defrule gatheroptions "Get the Name of a card id in HUMAN player's hand and assert choices fact containing it"
	(turn (player ?player))
	?nc <- (nextchoice ?next)
	?p <- (player (name ?player) (hand $?before ?c $?after) (playertype HUMAN))
	(card (id ?c) (name ?name))
	=>
	(printout t "In gatheroptions" crlf)
	(assert (choices (choicenum ?next) (cardname ?name)))
	(retract ?nc)
	(bind ?next (+ 1 ?next))
	(if (<= ?next (+ 1 (length$ $?before) (length$ $?after)))
	then
		(assert (nextchoice ?next))
	else
		(assert (choice -1))
	)
)

(defrule process_discard_choice "If choice is valid, assert it"
	?c <- (choice ?choice)
	?cs <- (choices (choicenum ?choice) (cardname ?cardname))
	(test (> ?choice 0))
	(turn (player ?player))
	?p <- (player (name ?player) (hand $?hand))
	(test (<= ?choice (length$ $?hand)))
	=>
	(retract ?cs)
	(assert (discard ?cardname))
)

(defrule process_discard_cleanup "retract remaining choice"
	(discard ?)
	?c <- (choices)
	=>
	(retract ?c)
)

(defrule process_discard "Do the bookkeeping corrisponding to a discard"
;	(not (choices))
	?dc <- (discard ?name)
	(card (name ?name) (id ?id))
	?p <- (player (name ?player) 
		(discardpile $?discards) 
		(hand $?before ?c $?after)
		(discard ?d&: (> ?d 0)))
	=>
	(assert (anounce (player ?player) (eventtype "discarded") (num ?id)))
	(retract ?dc)
	(modify ?p 
		(hand $?before $?after) 
		(discardpile ?id $?discards)
		(discard (- ?d 1)))
		)

(defrule begin-prompt-discard "catch that a player must discard"
	?c <- (choice ?choice)
	;(not (printchoice ?))
	(turn (player ?player)) 
	?p <- (player 
		(name ?player) 
		(hand $?hand)
		(playertype HUMAN))
		;(discard ?d&: (> ?d 0)))
	(test (or (< ?choice 1) (> ?choice (length$ $?hand))))
	=>
	(assert (printchoice 1))
	(printout t crlf ?player " must choose a card to discard" crlf)
	)

(defrule printchoices
	(turn (player ?player)) 
	?p <- (player (name ?player) (hand $?hand) (playertype HUMAN))
	?pc <- (printchoice ?cnum)
	(choices (choicenum ?cnum) (cardname ?name))
;	(test (<= ?cnum (length$ $?hand)))
	=>
	(printout t ?cnum ") " ?name crlf)
	(retract ?pc)
	(assert (printchoice (+ 1 ?cnum)))
)

(defrule promptchoice "Get the user's to choice a card to discard"
	?c <- (choice ?choice)
	(turn (player ?player)) 
	?p <- (player (name ?player) (hand $?hand) (playertype HUMAN))
	?pc <- (printchoice ?cnum)
	(test (> ?cnum (length$ $?hand)))
	=>
	(retract ?pc ?c)
	(assert (choice (read)))
	)
	
; **************************************************
; *    Rules for RANDOM players
; **************************************************
	
(defrule random-discard "discard routine for RANDOM player"
	(turn (player ?player)) 
	?p <- (player 
		(name ?player) 
		(hand $?hand)
		(playertype RANDOM) 
		(discard ?d&:(> ?d 0))
		(discardpile $?pile))
	=>
	(printout t crlf ?player " must randomly choose a card to discard" crlf)
	(bind ?idx (random 1 (length$ $?hand)))
	(bind ?choice (nth$ ?idx $?hand))
	(assert (anounce (player ?player) (eventtype "discarded") (num ?choice)))
	(modify ?p (discard (- ?d 1)) (hand (delete$ $?hand ?idx ?idx)))
	)

