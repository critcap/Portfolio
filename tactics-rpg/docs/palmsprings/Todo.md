- Refactor Character:
	- [ ] rename actor -> pawn
	- [ ] add signal for updating direction into pawn
	- [ ] move animation stuff into new character sprite controller
		- [ ] refactor animations
			- 1 named animation which describes what to do e.g. "walk", 		
			"attack", "swim" or "cast". But the animation it self is empty.
			- 2 animations with suffix _south, _north; which hold the real animation data and are managed by the new character sprite controller. 