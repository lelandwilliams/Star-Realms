(defrule endturn
	?f <- (endturn)
	?t <- (turn (player ?player))
	(player (name ?newplayer&~?player))
	=>
	(printout t "*** End of Turn ***" crlf )
	(retract ?f)
	(modify ?t (player ?newplayer) (combat 0) (scrap 0) (trade 0))
)

	

	

