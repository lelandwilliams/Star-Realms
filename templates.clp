(deftemplate player
	(slot name (type STRING))
	(slot playertype (type SYMBOL))
	(multislot hand)
	(multislot discardpile)
	(multislot drawpile)
	(multislot bases)
	)

(deftemplate turn
	(slot player (type STRING))
	(slot discard (type INTEGER))
	(slot combat (type INTEGER))
	(slot scrap (type INTEGER))
	(slot trade (type INTEGER))
	)

(deftemplate deck
	(multislot facedown-cards)
	(multislot faceup-cards)
	(multislot explorers)
	)



