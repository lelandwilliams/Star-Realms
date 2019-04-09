(load cards.clp)
(load templates.clp)
(load gameloop.clp)

(defrule teststartrule
	?f <- (start)
	?p1 <- (player (name ?n1))
	?p2 <- (player (name ?n2&~?n1))
	=>
	(printout t "Startup" crlf)
	(retract ?f)
)

(deffacts testfacts
	(player
		(name "PlayerOne")
		(playertype RandomPlayer)
		(drawpile 1 2 3 4 5 6 7 8 9 10)
	)
	(player
		(name "PlayerTwo")
		(playertype RandomPlayer)
		(drawpile 11 12 13 14 15 16 17 18 19 20)
	)
	(deck
		(explorers 21 22 23 24 25 26 27 28 29 30)
	)
	(start)
)


		
