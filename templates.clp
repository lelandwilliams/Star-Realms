(deftemplate anounce "This fact triggers printing of an event"
	(slot player (type STRING))
	(slot eventtype (type STRING))
	(slot num (type INTEGER))
)

(deftemplate draw
	(slot player (type STRING))
	(slot num (type INTEGER))
)

(deftemplate player
	(slot name (type STRING))
	(slot playertype (type SYMBOL))
	(slot authority (type INTEGER) (default 50))
	(slot discard (type INTEGER) (default 0))
	(multislot hand)
	(multislot discardpile)
	(multislot drawpile)
	(multislot bases)
	(multislot cardsplayed)
	)

(deftemplate turn
	(slot player (type STRING) (default ?NONE))
	(slot combat (type INTEGER) (default 0))
	(slot scrap (type INTEGER) (default 0))
	(slot trade (type INTEGER) (default 0))
	)

(deftemplate deck
	(multislot facedown-cards)
	(multislot faceup-cards)
	(multislot explorers)
	)

(deftemplate special "a sentinal showing the triggering of a card's special ability"
	(slot name))


(export ?ALL)
