(defmodule PLAYERCHOICE
	(import MAIN ?ALL))

(defrule onswitch "Do this upon switching"
	(declare (salience 100))
	?f <- (playerchoice)
	=>
	(retract ?f)
	(printout t "In Module PLAYERCHOICE" crlf)
	(assert (choicelist (choices) (choicetype) (card_ids)))
)

(defrule addcombatchoice "Add blowing things up to list of choices"
	(turn (combat ?combat&:(> ?combat 0)))
	?cl <- (choicelist (choices $?choices) (choicetype $?choicetypes))
	(test (not (member$ "Combat" $?choicetypes)))
	=>
	(modify ?cl (choices ?choices ?combat) (choicetype "Combat"))
)

(defrule addbuychoice "Add the choice of buying a card"
	(turn (trade ?trade&:(> ?trade 0)))
	(deck (faceup-cards $? ?id $?))
	(card (id ?id) (name ?cardname) (cost ?cost&:(<= ?cost ?trade)))
	?cl <- (choicelist 
		(choices $?choices) 
		(choicetype $?choicetypes)
		(card_ids $?cardids))
	(test (not (member$ ?id $?cardids)))
	=>
	(modify ?cl 
		(choices $?choices ?cardname) 
		(choicetype $?choicetypes "Buy")
		(card_ids $?cardids ?id))
)

(defrule addexplorerchoice "Add the choice of buying an explorer"
	(turn (trade ?trade&:(> ?trade 0)))
	(deck (explorers ?id $?))
	(card (id ?id) (name ?cardname) (cost ?cost&:(<= ?cost ?trade)))
	?cl <- (choicelist 
		(choices $?choices) 
		(choicetype $?choicetypes)
		(card_ids $?cardids))
	(test (not (member$ ?id $?cardids)))
	=>
	(modify ?cl 
		(choices $?choices ?cardname) 
		(choicetype $?choicetypes "Buy")
		(card_ids $?cardids ?id))
)


(defrule addcardchoice "Add playing a card to list of choices"
	(turn (player ?player))
	(player (name ?player) (hand $? ?id $?))
	(card (id ?id) (name ?cardname))
	?cl <- (choicelist 
		(choices $?choices) 
		(choicetype $?choicetypes)
		(card_ids $?cardids))
	(test (not (member$ ?id $?cardids)))
	=>
	(modify ?cl 
		(choices $?choices ?cardname) 
		(choicetype $?choicetypes "Play")
		(card_ids $?cardids ?id))
)

(defrule finalizedchoices "add one last choice to choices"
	(declare (salience -10))
	(turn (player ?player))
	?cl <- (choicelist (choices $?choices) (choicetype $?choicetypes))
	(not (prompt $?))
	=>
	(modify ?cl (choices $?choices "") (choicetype $?choicetypes "End Turn"))
	(assert (prompt))
)

(defrule promptchoice "print full list of choices to screen and request choice"
	(turn (player ?player))
	?cl <- (choicelist (choices $?choices) (choicetype $?choicetypes))
	?f <- (prompt)
	=>
	(printout t ?player " Choose an action" crlf)
	(loop-for-count (?n (length$ ?choices)) do
		(printout t ?n ") " (nth$ ?n $?choicetypes) " " (nth$ ?n $?choices) crlf))
	(retract ?f)
	(assert (prompt -1))
)

(defrule resolvechoice "process a valid choice into a update directive"
	?cl <- (choicelist (choices $?choices) (choicetype $?choicetypes))
	?f <- (prompt ?n)
	(test (> ?n 0))
	(test (<= ?n (length$ ?choices)))
	(turn (player ?player))
	(player (name ?player) (hand $?hand))
	=>
	(assert (finalchoice 
		(choice (nth$ ?n $?choices))
		(choicetype (nth$ ?n $?choicetypes))))
	(retract ?f)
	(retract ?cl)
)

(defrule resolve-cardplay "process the choice to play a card"
	(turn (player ?player))
	?fc <- (finalchoice (choice ?cardname) (choicetype "Play"))
	?p <- (player (name ?player) (hand $? ?id $?))
	(card (name ?cardname) (id ?id))
	=>
	(retract ?fc)
	(assert (play (id ?id)))
	;(assert (playerchoice))
)

(defrule resolve-endturn "process the choice to end the turn"
	?fc <- (finalchoice (choice ?cardname) (choicetype "End Turn"))
	=>
	(retract ?fc)
	(assert (endturn))
)

(defrule prompthuman
	(turn (player ?player))
	(player (name ?player) (playertype HUMAN))
	?cl <- (choicelist (choices $?choices) (choicetype $?choicetypes))
	?f <- (prompt ?val)
	(test (or (< ?val 0) (> ?val (length$ $?choices))))
	=>
	(retract ?f)
	(printout t "Choice -> ")
	(assert (prompt (read)))
)

(defrule promptrandomplayer
	(turn (player ?player))
	(player (name ?player) (playertype RANDOM))
	?cl <- (choicelist (choices $?choices) (choicetype $?choicetypes))
	?f <- (prompt ?val)
	(test (or (< ?val 1) (> ?val (length$ $?choices))))
	=>
	(retract ?f)
	(assert (prompt (random 0 (length$ $?choices))))
)



