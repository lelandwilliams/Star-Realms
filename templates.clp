(deftemplate player
	(slot name (type STRING))
	(slot playertype (type SYMBOL))
	(slot authority (type INTEGER) (default 50))
	(multislot hand)
	(multislot discardpile)
	(multislot drawpile)
	(multislot bases)
	)

(deftemplate turn
	(slot player (type STRING) (default ?NONE))
	(slot discard (type INTEGER) (default 0))
	(slot combat (type INTEGER) (default 0))
	(slot scrap (type INTEGER) (default 0))
	(slot trade (type INTEGER) (default 0))
	)

(deftemplate deck
	(multislot facedown-cards)
	(multislot faceup-cards)
	(multislot explorers)
	)



