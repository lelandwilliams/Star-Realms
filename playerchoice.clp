(defmodule PLAYERCHOICE
	(import MAIN ?ALL))

(defrule onswitch "Do this upon switching"
	(declare (salience 100))
	?f <- (playerchoice)
	=>
	(retract ?f)
	;(printout t "In Module PLAYERCHOICE" crlf)
	(printout t crlf)
	(assert (choicelist (choices) (choicetype) (card_ids)))
)

(defrule addcombatchoice "Add hurting things up to list of choices"
	(turn (player ?curplayer) (combat ?combat&:(> ?combat 0)))
	?cl <- (choicelist (choices $?choices) (choicetype $?choicetypes))
	(player (name ?pname) (outposts $?outposts))
	(test (not (member$ "Combat" $?choicetypes)))
	(test (not (eq ?curplayer ?pname)))
	(test (eq 0 (length$ $?outposts)))
	=>
	(modify ?cl (choices ?choices ?combat) (choicetype "Combat"))
)


(defrule addcombatchoice-outpost "Add destroying an outpost to list of choices"
	(turn (player ?curplayer) (combat ?combat&:(> ?combat 0)))
	?cl <- (choicelist (choices $?choices) (choicetype $?choicetypes))
	(player (name ?pname) (outposts $? ?id $?))
	(card (id ?id) (defense ?defense))
	(test (not (member$ "Combat" $?choicetypes)))
	(test (not (eq ?curplayer ?pname)))
	(test (<= ?defense ?combat))
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
	(printout t ?player ": choose an action" crlf)
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

(defrule resolve-buy "process the choice to buy a card"
	?t <- (turn (player ?player) (trade ?trade))
	?fc <- (finalchoice (choice ?cardname) (choicetype "Buy"))
	?p <- (player (name ?player) (discardpile $?discards))
	(card (name ?cardname) (id ?id) (cost ?cost))
	?d <- (deck (faceup-cards $?before ?id $?after))
	(test (<= ?cost ?trade))
	=>
	(retract ?fc)
	(modify ?t (trade (- ?trade ?cost)))
	(modify ?p (discardpile ?id $?discards))
	(modify ?d (faceup-cards $?before $?after))
	(assert (anounce  (player ?player) (eventtype "buys") (num ?id)))
)

(defrule resolve-buy-explorer "process the choice to buy an explorer"
	?t <- (turn (player ?player) (trade ?trade))
	?fc <- (finalchoice (choice ?cardname) (choicetype "Buy"))
	?p <- (player (name ?player) (discardpile $?discards))
	(card (name ?cardname) (id ?id) (cost ?cost))
	?d <- (deck (explorers ?id $?rest))
	(test (<= ?cost ?trade))
	=>
	(retract ?fc)
	(modify ?t (trade (- ?trade ?cost)))
	(modify ?p (discardpile ?id $?discards))
	(modify ?d (explorers $?rest))
	(assert (anounce  (player ?player) (eventtype "buys") (num ?id)))
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

(defrule resolve-combat "blow something up"
	?fc <- (finalchoice  (choicetype "Combat"))
	=>
	(retract ?fc)
	(focus COMBAT)
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



