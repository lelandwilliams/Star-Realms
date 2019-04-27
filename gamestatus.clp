; **************************************************
; *		   gamestatus.clp                  * 
; *                                                *
; * This module only prints out the current game   *
; * status. It does not alter game state at all    *
; *                                                *
; **************************************************

(defmodule GAMESTATUS
	(import MAIN ?ALL))

(deftemplate gather
	(multislot cardnames))

(defrule onswitch "Do this upon switching"
	;(declare (salience 100))
	(turn (player ?player1))
	?f <- (gamestatus)
	=>
	(assert (printplayer ?player1))
	(printout t crlf "*** Game Status ***" crlf)
	(printout t ?player1 "'s turn" crlf)
	(retract ?f)
	)

(defrule printplayer "Print player info"
	?f <- (printplayer ?pname)
	(player 
		(name ?pname)
		(authority ?auth)
		(playertype ?ptype)
		)
	(player (name ?otherplayer))
	(test (neq ?otherplayer ?pname))
	(turn (player ?curplayer))
	=>
	(retract ?f)
	(printout t ?pname " authority: " ?auth)
	(printout t crlf)
	(if (eq ?pname ?curplayer) 
		then (assert (printplayer ?otherplayer))
		else (assert (gather)))
)

(defrule gather-traderow-cardnames
	?f <- (gather (cardnames $?cards))
	(deck (faceup-cards $? ?id $?))
	(card (id ?id) (name ?cname))
	(test (not (member$ ?cname $?cards)))
	=>
	(modify ?f (cardnames $?cards ?cname))
	)

(defrule print-traderow
	?f <- (gather (cardnames $?cards))
	(deck (faceup-cards $?fucards))
	(test (= (length$ $?cards) (length$ $?fucards)))
	=>
	(printout t "Trade Row has:")
	(loop-for-count (?i 1 (length$ $?cards))
		(printout t "   " (nth$ ?i $?cards) crlf))
	(retract ?f)
;	(assert (done "TradeRow"))
	)

(defrule cleanup
	?f1 <- (done ?pname1)
	?f2 <- (done ?pname2)
	?f3 <- (done "TradeRow")
	(test (neq ?pname1 ?pname2 "TradeRow"))
	=>
	(retract ?f1 ?f2 ?f3)
)

		


	
