; **************************************************
; *		   testfacts.clp                   * 
; *		 by Leland Williams                * 
; *                                                *
; * This file defines the players and the explorer *
; * pile in the deck. The explore pile ought to be *
; * defined elsewhere.                             *
; *                                                *
; **************************************************

(deffacts testfacts
	(player
		(name "HAL")
		(playertype RANDOM)
		(drawpile 1 2 3 4 5 6 7 8 9 10)
	)
	(player
		(name "Ash")
		(playertype RANDOM)
		(drawpile 11 12 13 14 15 16 17 18 19 20)
	)
	(deck
		(explorers 21 22 23 24 25 26 27 28 29 30)
	)
)
	
