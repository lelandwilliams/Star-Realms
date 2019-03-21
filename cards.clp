(deftemplate card
	(slot name (type STRING) (default ?NONE))
	(slot id (type INTEGER) (default ?NONE))
	(slot color (type SYMBOL) (default none))
	(slot cost (type INTEGER) (default 0))
	(slot type (type SYMBOL) (default ship))
	(slot defense (type INTEGER) (default 0))
	;(slot copy (type INTEGER) (default ?NONE))

	(slot primary-auth (type INTEGER) (default 0))
	(slot primary-combat (type INTEGER) (default 0))
	(slot primary-destroy (type INTEGER) (default 0))
	(slot primary-discard (type INTEGER) (default 0))
	(slot primary-draw (type INTEGER) (default 0))
	(slot primary-scrap (type INTEGER) (default 0))
	(slot primary-trade (type INTEGER) (default 0))
	(slot primary-traderowscrap (type INTEGER) (default 0))
	(slot primary-special (type INTEGER) (default 0))
	(multislot primary-abilities)

	(slot ally-auth (type INTEGER) (default 0))
	(slot ally-combat (type INTEGER) (default 0))
	(slot ally-destroy (type INTEGER) (default 0))
	(slot ally-discard (type INTEGER) (default 0))
	(slot ally-draw (type INTEGER) (default 0))
	(slot ally-scrap (type INTEGER) (default 0))
	(slot ally-trade (type INTEGER) (default 0))
	(slot ally-traderowscrap (type INTEGER) (default 0))
	(multislot ally-abilities)

	(slot scrap-auth (type INTEGER) (default 0))
	(slot scrap-combat (type INTEGER) (default 0))
	(slot scrap-destroy (type INTEGER) (default 0))
	(slot scrap-discard (type INTEGER) (default 0))
	(slot scrap-draw (type INTEGER) (default 0))
	(slot scrap-scrap (type INTEGER) (default 0))
	(slot scrap-trade (type INTEGER) (default 0))
	(slot scrap-traderowscrap (type INTEGER) (default 0))
	(multislot scrap-abilities)
)

(deffacts cardfacts
	(card (name "Scout") (id 1) (primary-trade 1))
	(card (name "Scout") (id 2) (primary-trade 1))
	(card (name "Scout") (id 3) (primary-trade 1))
	(card (name "Scout") (id 4) (primary-trade 1))
	(card (name "Scout") (id 5) (primary-trade 1))
	(card (name "Scout") (id 6) (primary-trade 1))
	(card (name "Scout") (id 7) (primary-trade 1))
	(card (name "Scout") (id 8) (primary-trade 1))
	(card (name "Viper") (id 9) (primary-combat 1))
	(card (name "Viper") (id 10) (primary-combat 1))
	
	(card (name "Scout") (id 11) (primary-trade 1))
	(card (name "Scout") (id 12) (primary-trade 1))
	(card (name "Scout") (id 13) (primary-trade 1))
	(card (name "Scout") (id 14) (primary-trade 1))
	(card (name "Scout") (id 15) (primary-trade 1))
	(card (name "Scout") (id 16) (primary-trade 1))
	(card (name "Scout") (id 17) (primary-trade 1))
	(card (name "Scout") (id 18) (primary-trade 1))
	(card (name "Viper") (id 19) (primary-combat 1))
	(card (name "Viper") (id 20) (primary-combat 1))
	
	(card (name "Explorer") (id 21) (primary-trade 2) 
		(cost 2) (scrap-combat 2))
	(card (name "Explorer") (id 22) (primary-trade 2) 
		(cost 2) (scrap-combat 2))
	(card (name "Explorer") (id 23) (primary-trade 2) 
		(cost 2) (scrap-combat 2))
	(card (name "Explorer") (id 24) (primary-trade 2) 
		(cost 2) (scrap-combat 2))
	(card (name "Explorer") (id 25) (primary-trade 2) 
		(cost 2) (scrap-combat 2))
	(card (name "Explorer") (id 26) (primary-trade 2) 
		(cost 2) (scrap-combat 2))
	(card (name "Explorer") (id 27) (primary-trade 2) 
		(cost 2) (scrap-combat 2))
	(card (name "Explorer") (id 28) (primary-trade 2) 
		(cost 2) (scrap-combat 2))
	(card (name "Explorer") (id 29) (primary-trade 2) 
		(cost 2) (scrap-combat 2))
	(card (name "Explorer") (id 30) (primary-trade 2) 
		(cost 2) (scrap-combat 2))

	(card (name "Blob Fighter") (id 31) (color green)
		(cost 1) (primary-combat 3) (ally-draw 1))
	(card (name "Blob Fighter") (id 32) (color green)
		(cost 1) (primary-combat 3) (ally-draw 1))
	(card (name "Blob Fighter") (id 33) (color green)
		(cost 1) (primary-combat 3) (ally-draw 1))

	(card (name "Federation Shuttle") (id 34) (color blue)
		(cost 1) (primary-trade 2) (ally-auth 4))
	(card (name "Federation Shuttle") (id 35) (color blue)
		(cost 1) (primary-trade 2) (ally-auth 4))
	(card (name "Federation Shuttle") (id 36) (color blue)
		(cost 1) (primary-trade 2) (ally-auth 4))

	(card (name "Imperial Fighter") (id 37) (color yellow)
		(cost 1) (primary-combat 2) (ally-combat 2))
	(card (name "Imperial Fighter") (id 38) (color yellow)
		(cost 1) (primary-combat 2) (ally-combat 2))
	(card (name "Imperial Fighter") (id 39) (color yellow)
		(cost 1) (primary-combat 2) (ally-combat 2))

	(card (name "Trade Bot") (id 40) (color red) (cost 1)
		(primary-trade 1) (primary-scrap 1) (ally-combat 2))
	(card (name "Trade Bot") (id 41) (color red) (cost 1)
		(primary-trade 1) (primary-scrap 1) (ally-combat 2))
	(card (name "Trade Bot") (id 42) (color red) (cost 1)
		(primary-trade 1) (primary-scrap 1) (ally-combat 2))

	(card (name "Battle Pod") (id 43) (color green) (cost 2)
		(primary-combat 4) (primary-traderowscrap 1) (ally-combat 2))
	(card (name "Battle Pod") (id 44) (color green)(cost 2)
		(primary-combat 4) (primary-traderowscrap 1) (ally-combat 2))

	(card (name "Corvette") (id 45) (color yellow) (cost 2)
		(primary-combat 1) (primary-draw 1) (ally-combat 2))
	(card (name "Corvette") (id 46) (color yellow) (cost 2)
		(primary-combat 1) (primary-draw 1) (ally-combat 2))

	(card (name "Cutter") (id 47) (color blue) (cost 2)
		(primary-trade 2) (primary-auth 4) (ally-combat 4))
	(card (name "Cutter") (id 48) (color blue) (cost 2)
		(primary-trade 2) (primary-auth 4) (ally-combat 4))
	(card (name "Cutter") (id 49) (color blue) (cost 2)
		(primary-trade 2) (primary-auth 4) (ally-combat 4))

	(card (name "Missile Bot") (id 50) (color red) (cost 2)
		(primary-combat 2) (primary-scrap 1) (ally-combat 2))
	(card (name "Missile Bot") (id 51) (color red) (cost 2)
		(primary-combat 2) (primary-scrap 1) (ally-combat 2))
	(card (name "Missile Bot") (id 52) (color red) (cost 2)
		(primary-combat 2) (primary-scrap 1) (ally-combat 2))

	(card (name "Trade Pod") (id 53) (color green) (cost 2)
		(primary-trade 3) (ally-combat 2))
	(card (name "Trade Pod") (id 53) (color green) (cost 2)
		(primary-trade 3) (ally-combat 2))
	(card (name "Trade Pod") (id 53) (color green) (cost 2)
		(primary-trade 3) (ally-combat 2))
	
	(card (name "Battle Station") (id 54) (type outpost) (cost 3)
		(color red) (defense 5) (scrap-combat 5))
	(card (name "Battle Station") (id 55) (type outpost) (cost 3)
		(color red) (defense 5) (scrap-combat 5))

	(card (name "Blob Wheel") (id 56) (type base) (cost 3)
		(color green) (defense 5) (primary-combat 1)
		(scrap-trade 3))
	(card (name "Blob Wheel") (id 57) (type base) (cost 3)
		(color green) (defense 5) (primary-combat 1)
		(scrap-trade 3))
	(card (name "Blob Wheel") (id 58) (type base) (cost 3)
		(color green) (defense 5) (primary-combat 1)
		(scrap-trade 3))


	(card (name "Embassy Yacht") (id 59) (cost 3)
		(color blue) (primary-auth 3) (primary-trade 2)
		(primary-special 1))
	(card (name "Embassy Yacht") (id 60) (cost 3)
		(color blue) (primary-auth 3) (primary-trade 2)
		(primary-special 1))

	(card (name "Imperial Frigate") (id 61) (cost 3)
		(color yellow) (primary-combat 4) (primary-discard 1)
		(ally-combat 2) (scrap-draw 1))
	(card (name "Imperial Frigate") (id 62) (cost 3)
		(color yellow) (primary-combat 4) (primary-discard 1)
		(ally-combat 2) (scrap-draw 1))
	(card (name "Imperial Frigate") (id 63) (cost 3)
		(color yellow) (primary-combat 4) (primary-discard 1)
		(ally-combat 2) (scrap-draw 1))

	(card (name "Ram") (id 64) (cost 3)
		(color green) (primary-combat 5) (ally-combat 2)
		(scrap-trade 3))
	(card (name "Ram") (id 65) (cost 3)
		(color green) (primary-combat 5) (ally-combat 2)
		(scrap-trade 3))

	(card (name "Supply Bot") (id 66) (cost 3)
		(color red) (primary-trade 2) (primary-scrap 1)
		(ally-combat 2))
	(card (name "Supply Bot") (id 66) (cost 3)
		(color red) (primary-trade 2) (primary-scrap 1)
		(ally-combat 2))
	(card (name "Supply Bot") (id 66) (cost 3)
		(color red) (primary-trade 2) (primary-scrap 1)
		(ally-combat 2))

	(card (name "Survey Ship") (id 67) (cost 3)
		(color yellow) (primary-trade 1) (primary-draw 1)
		(scrap-discard 1))
	(card (name "Survey Ship") (id 68) (cost 3)
		(color yellow) (primary-trade 1) (primary-draw 1)
		(scrap-discard 1))
	(card (name "Survey Ship") (id 69) (cost 3)
		(color yellow) (primary-trade 1) (primary-draw 1)
		(scrap-discard 1))

	(card (name "Trading Post") (id 70) (type outpost) (cost 3)
		(defense 4) (color blue) (primary-special 1) (scrap-combat 3))
	(card (name "Trading Post") (id 71) (type outpost) (cost 3)
		(defense 4) (color blue) (primary-special 1) (scrap-combat 3))

	(card (name "Barter World") (id 72) (type base) (cost 4)
		(defense 4) (color blue) (primary-special 1) (scrap-combat 5))
	(card (name "Barter World") (id 73) (type base) (cost 4)
		(defense 4) (color blue) (primary-special 1) (scrap-combat 5))

	(card (name "Blob Destroyer") (id 74) (cost 4)
		(color green) (primary-combat 6) (ally-destroy 1))
	(card (name "Blob Destroyer") (id 75) (cost 4)
		(color green) (primary-combat 6) (ally-destroy 1))

	(card (name "Freighter") (id 76) (cost 4)
		(color blue) (primary-trade 4) (primary-special 1))
	(card (name "Freighter") (id 77) (cost 4)
		(color blue) (primary-trade 4) (primary-special 1))

	(card (name "Patrol Mech") (id 78) (cost 4)
		(color red) (primary-special 1) (ally-scrap 1))
	(card (name "Patrol Mech") (id 79) (cost 4)
		(color red) (primary-special 1) (ally-scrap 1))

	(card (name "Recycling Station") (id 80) (cost 4) (type outpost)
		(defense 4) (color yellow) (primary-special 1)) 
	(card (name "Recycling Station") (id 81) (cost 4) (type outpost)
		(defense 4) (color yellow) (primary-special 1)) 

	(card (name "Space Station") (id 82) (cost 4) (type outpost)
		(defense 4) (color yellow) (primary-combat 2)
		(ally-combat 2) (scrap-trade 4))
	(card (name "Space Station") (id 83) (cost 4) (type outpost)
		(defense 4) (color yellow) (primary-combat 2)
		(ally-combat 2) (scrap-trade 4))

	(card (name "Stealth Needle") (id 84) (cost 4) 
		(color red) (primary-special 1))

	(card (name "Battle Mech") (id 85) (cost 5)
		(color red) (primary-combat 4) (primary-scrap 1)
		(ally-draw 1))

	(card (name "Defense Center") (id 86) (type outpost) (cost 5)
		(color blue) (primary-special 1) (ally-combat 2))

	(card (name "Mech World") (id 87) (type outpost) (cost 5)
		(defense 6) (primary-special 1))
)

