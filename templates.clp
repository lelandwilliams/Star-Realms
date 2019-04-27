(deftemplate anounce "This fact triggers printing of an event"
	(slot player (type STRING))
	(slot eventtype (type STRING))
	;(slot num (type INTEGER))
	(slot num)
)

(deftemplate draw
	(slot player (type STRING))
	(slot num (type INTEGER))
)

(deftemplate choicelist " A place to list all of a player's choices"
	(multislot choices (type STRING))
	(multislot choicetype (type STRING))
	(multislot card_ids (type INTEGER))
)

(deftemplate endturn "a sentinal that a player has chosen to end their turn")

(deftemplate finalchoice " A place to list all of a player's choices"
	(multislot choice (type STRING))
	(multislot choicetype (type STRING))
)

(deftemplate gameover "a sentinal that the game is now over")
(deftemplate gamestatus "a sentinal to switch to module GAMESTATUS")

(deftemplate play "a template for the card chosen by a player ot play"
	(slot id (type INTEGER))
)

(deftemplate player
	(slot name (type STRING))
	(slot playertype (type SYMBOL))
	(slot authority (type INTEGER) (default 50))
	(slot discard (type INTEGER) (default 0))
	(multislot hand)
	(multislot discardpile)
	(multislot drawpile)
	(multislot outposts)
	(multislot bases)
	(multislot cardsplayed)
	)

(deftemplate playerchoice "a sentinal to switch to module PLAYERCHOICE")

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


