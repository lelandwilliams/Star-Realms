# Star Realms
## Implementing the Star Realms base game using a rule-based system

Rule-based (expert) systems are rather like a fish tank, where the rules are fish, swimming around 
looking for the correct food. The food are 'facts' that meet the rules criteria. Once a rule finds an appropriate fact
to work on, it processes the fact, often altering the fact landscape.

For Star Realms, the facts are:
* The card definitions: name, effects, etc.
* the game state: player HP (authority), whose turn it is, and so on.
* the turn state: whcih phase it is, which card effects are resolved/unresolved, etc

The expert system used is CLIPS, which was developed by and for NASA, and is open source.
