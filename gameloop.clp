(defrule makeanouncement
	?f <- (anounce (player ?p) (eventtype ?e) (num ?n))
	(card (id ?n) (name ?cardname))
	=>
	(printout t ?p " " ?e " " ?cardname crlf)
	(retract ?f)
)

(defrule choice-switch-new
	(playerchoice)
	(not (draw))
	(not (anounce))
	(not (discard))
	=>
	(focus PLAYERCHOICE)
)

(defrule discard-switch "Once end of turn upkeep is finished, switch focus"
	(not (draw))
	(not (anounce))
	?f <- (discard)
	=>
	(retract ?f)
	(focus DISCARD)
	)

(defrule endturn
	(not (draw))
	(not (anounce))
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
	(assert (discard))
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
;	(assert (anounce 
;		(player ?player) 
;		(num ?drawcard)
;		(eventtype "drew")))
)

(defrule playcard "Resolves the playing of a card"
	?f <- (play (id ?num))
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
	(assert (playerchoice))
	(assert (anounce 
		(player ?playername) 
		(num ?num)
		(eventtype "Played")))
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
	

(defrule reshuffle-player-deck "Reshuffles a player's discard pile into their hand"
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
	?d <- (deck (facedown-cards $?facedown) (faceup-cards $?faceup))
	=>
	(printout t "Startup" crlf)
	(retract ?f)
	(bind $?facedown 31)
	(loop-for-count (?i 32 106) do (bind $?facedown $?facedown ?i))
	(modify ?d (facedown-cards $?facedown))
	(if (= (random 1 2) 1)
		then 
			(bind ?startplayer ?n1) 
			(bind ?scndplayer ?n2)
		else 
			(bind ?startplayer ?n2) 
			(bind ?scndplayer ?n1))
	(assert (turn (player ?startplayer)))
	(modify ?p1 (discard 2))
	(modify ?p2 (discard 1))
	(printout t ?startplayer " will begin" crlf)
	(assert (draw (player ?startplayer) (num 3)))
	(assert (draw (player ?scndplayer) (num 5)))
	(assert (playerchoice))
)

(defrule update-tradepile
	?d <- (deck (facedown-cards $?facedown) (faceup-cards $?faceup))
	(test (< (length$ $?faceup) 5))
	(test (> (length$ $?facedown) 0))
	=>
	(bind ?index (random 1 (length$ $?facedown)))
	(bind ?id (nth$ ?index $?facedown))
	(modify ?d 
		(facedown-cards (delete-member$ $?facedown ?id))
		(faceup-cards $?faceup ?id))
;(assert (anounce (player "Trade Row") (eventtype "Adds") (num ?id)))
)
