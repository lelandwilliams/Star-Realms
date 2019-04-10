(deftemplate draw
	(slot player (type STRING))
	(slot num (type INTEGER))
)

(deftemplate drew "This fact triggers printing"
	(slot player (type STRING))
	(slot num (type INTEGER))
)

(defrule announce-draw
	?f <- (drew (player ?p) (num ?n))
	(card (id ?n) (name ?cardname))
	=>
	(printout t ?p " drew " ?cardname crlf)
	(retract ?f)
)

(defrule endturn
	(not (draw))
	?f <- (endturn)
	?t <- (turn (player ?player))
	?np <- (player 
		(name ?newplayer&~?player))
	?p <- (player
		(name ?player)
		(hand $?hand)
		(discardpile $?discards)
		(cardsplayed $?played)
		)
	=>
	(printout t crlf "    *** End of Turn ***" crlf )
	(retract ?f)
	(modify ?t (player ?newplayer) (combat 0) (scrap 0) (trade 0))
	(modify ?p
		(hand) (cardsplayed) (discardpile $?hand $?played $?discards))
	(assert (draw (player ?player) (num 5)))
)

(defrule draw
	?f <- (draw (player ?player) (num ?num))
	?p <- (player (name ?player) 
		(hand $?hand)
		(drawpile $?drawpile))
	(not (drew))
	(test (> (length$ $?drawpile) 0))
	=>
	(bind ?n (random 1 (length$ $?drawpile)))
	(bind ?drawcard (nth$ ?n $?drawpile))
	(modify ?p (hand $?hand ?drawcard) 
		(drawpile (delete$ $?drawpile ?n ?n)))
	(if (= ?num 1) 
		then (retract ?f) 
		else (modify ?f (num (- ?num 1))))
	(assert (drew (player ?player) (num ?drawcard)))
)

(defrule reshuffle
	?f <- (draw (player ?player) (num ?num))
	?p <- (player (name ?player) (discardpile $?discards) (drawpile $?drawpile))
	(test (= 0 (length$ $?drawpile)))
	=>
	(modify ?p (discardpile) (drawpile $?discards))
	(printout t  ?player " resuffles" crlf)
)

(defrule teststartrule
	?f <- (initial-fact)
	?p1 <- (player (name ?n1))
	?p2 <- (player (name ?n2&~?n1))
	=>
	(printout t "Startup" crlf)
	(retract ?f)
	(if (= (random 1 2) 1)
		then (bind ?startplayer ?n1) (bind ?scndplayer ?n2)
		else (bind ?startplayer ?n2) (bind ?scndplayer ?n1))
	(assert (turn (player ?startplayer)))
	(printout t "Player " ?startplayer " will begin" crlf)
	(assert (draw (player ?startplayer) (num 3)))
	(assert (draw (player ?scndplayer) (num 5)))
	(assert (endturn))
)

