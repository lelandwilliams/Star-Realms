(defmodule DISCARD
	(import MAIN ?ALL))

(deftemplate choices
	(slot choicenum (type INTEGER))
	(slot cardname (type STRING)))

(defrule debugswitch
	(declare (salience 100))
	(TRUE)
	=>
	(printout t crlf "In module DISCARD" crlf crlf)
	(assert (nextchoice 1))
)

(defrule gatheroptions
	(not (choice))
	(turn (player ?player))
	?nc <- (nextchoice ?next)
	?p <- (player (name ?player) 
		(discardpile $?discards) 
		(hand $?before ?c $?after)
		(discard ?d&: (> ?d 0)))
	(card (id ?c) (name ?name))
	=>
	(assert (choices (choicenum ?next) (cardname ?name)))
	(retract ?nc)
	(bind ?next (+ 1 ?next))
	(if (<= ?next (+ 1 (length$ $?before) (length$ $?after)) 
	then
		(assert (nextchoice (+ 1 ?next)))
	else
		(assert (choice -1))
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

(defrule process_discard
	(not (choices))
	?dc <- (discard ?name)
	(card (name ?name) (id ?id))
	?p <- (player (name ?player) 
		(discardpile $?discards) 
		(hand $?before ?c $?after)
		(discard ?d&: (> ?d 0)))
	=>
	(assert (anounce (player ?player) (eventtype "Discarded") (num ?id)))
	(retract ?dc)
	(modify ?p 
		(hand $?before $?after) 
		(discardpile ?id $?discards)
		(discard (- ?d 1)))
		)


