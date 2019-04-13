(defrule makeanouncement
	?f <- (anounce (player ?p) (eventtype ?e) (num ?n))
	(card (id ?n) (name ?cardname))
	=>
	(printout t ?p " " ?e " " ?cardname crlf)
	(retract ?f)
)

(defrule discard
	?t <- (turn (player ?player))
	?p <- (player (name ?player) (discard ?d&: (> ?d 0)))
	=> 
	(focus DISCARD)
	)

(defrule endturn
	(not (draw))
	?f <- (endturn)
	?c <- (choicelist)
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
	(modify ?c (choices))
)

(defrule draw
	?f <- (draw (player ?player) (num ?num))
	?p <- (player (name ?player) 
		(hand $?hand)
		(drawpile $?drawpile))
	(not (announce))
	(test (> (length$ $?drawpile) 0))
	=>
	(bind ?n (random 1 (length$ $?drawpile)))
	(bind ?drawcard (nth$ ?n $?drawpile))
	(modify ?p (hand $?hand ?drawcard) 
		(drawpile (delete$ $?drawpile ?n ?n)))
	(if (= ?num 1) 
		then (retract ?f) 
		else (modify ?f (num (- ?num 1))))
	(assert (anounce 
		(player ?player) 
		(num ?drawcard)
		(eventtype "Drew")))
)

(defrule playcard "Resolves the playing of a card"
	?f <- (play ?num)
	(card 
		(id ?num) 
		(name ?cardname) 
		(primary-auth ?auth)
		(primary-combat ?combat)
		(primary-destroy ?destroy)
		(primary-discard ?discard)
		(primary-draw ?draw)
		(primary-scrap ?scrap)
		(primary-trade ?trade)
		(primary-traderowscrap ?tradescrap)
		(primary-special ?has_special)
		)
	?t <- (turn 
		(player ?playername)
		(combat ?turn_combat)
		(trade ?turn_trade)
		)
	?p <- (player 
		(name ?playername)
		(authority ?player_auth)
		(hand $?before ?num $?after)
		(cardsplayed $?cardsplayed)
		)
	?op <- (player
		(name ~?playername)
		(discard ?opdiscard)
		)
	=>	
	(retract ?f)
	(modify ?t
		(combat (+ ?turn_combat ?combat))
		(trade (+ ?turn_trade ?trade))
		)
	(modify ?p
		(authority (+ ?auth ?player_auth))
		(hand $?before $?after)
		(cardsplayed $?cardsplayed ?num)
		)
	(modify ?op (discard (+ ?discard ?opdiscard)))
	(if (= 1 ?has_special) 
		then (assert (special (name ?cardname)))
		)
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

(defmodule DISCARD)
(import MAIN::?ALL)

(defrule debugswitch
	(declare (salience 100))
	=>
	(printout t crlf "In module DISCARD" crlf crlf)
)

(defrule gatheroptions
	(not (choice))
	(turn (player ?player))
	?p <- (player (name ?player) (discardpile $?discards) (hand $? ?c $?))
	?o <- (choicelist (choices $?choices))
	(card (id ?c) (name ?name))
	=>
	(modify ?o (choices ?name $?choices) (choicetype "Discard"))
	(assert choice (choicetype discard))
)

(defrule process_discard_choice
	?c <- (choice (choicetype discard) (choicenum ?choice))
	?cl <- (choicelist (choices $?choices))
	(test (> ?choice 0))
	(test (<= ?choice (length$ $?choices)))
	(bind ?name (nth ?choice ?choices))
	(card (name ?name) (id ?id))
	(turn (player ?player))
	?p <- (player (name ?player) 
		(hand $?handbefore ?id $?handafter)
		(discardpile $?discards) 
		(discard ?dnum))
		=>)

