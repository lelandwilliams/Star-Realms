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
	=>
	(printout t ?pname " authority: " ?auth)
	(printout t crlf)
	(retract ?f)
	(assert (done ?pname))
)

(defrule prompt-print-other-player "assert printplayer facts with name of different player than has been shown before"
	(done ?pname)
	(player (name ?p2))
	(test (neq ?pname ?p2))
	(not (done ?p2))
	=>
	(assert (printplayer ?p2))
)

(defrule begin-gather-traderow-cardnames
	(done ?pname1)
	(done ?pname2)
	(test (neq ?pname1 ?pname2))
	(not (gather))
	(not (done "TradeRow"))
	=>
	(assert (gather))
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
	(assert (done "TradeRow"))
	)

(defrule cleanup
	?f1 <- (done ?pname1)
	?f2 <- (done ?pname2)
	?f3 <- (done "TradeRow")
	(test (neq ?pname1 ?pname2))
	(test (neq ?pname1 "TradeRow"))
	(test (neq ?pname2 "TradeRow"))
	=>
	(retract ?f1 ?f2 ?f3))

		


	
