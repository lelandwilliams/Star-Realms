(defmodule PLAYERCHOICE
	(import MAIN ?ALL))

(defrule onswitch "Do this upon switching"
	(declare (salience 100))
	=>
	(printout t "In Module PLAYERCHOICE" crlf)
	(assert (choicelist (choices) (choicetype) (card_ids)))
)

(defrule addcombatchoice "Add blowing things up to list of choices"
	(turn (player ?player) (combat ?combat&:(> ?combat 0)))
	?cl <- (choicelist (choices $?choices) (choicetype $?choicetypes))
	=>
	(modify ?cl (choices ?choices ?combat) (choicetype "Combat"))
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

(defrule outputchoices "print full list of choices to screen"
	(declare (salience -10))
	(turn (player ?player))
	?cl <- (choicelist (choices $?choices) (choicetype $?choicetypes))
	=>
	(printout t ?player " Choose an action" crlf)
	(loop-for-count (?n (length$ ?choices)) do
		(printout t ?n ") " (nth$ ?n $?choicetypes) " " (nth$ ?n $?choices) crlf))

)
