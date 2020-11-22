:- consult('game.pl').

startGame :-
	initial(GameState),
	display_game(GameState)
.

testValidMove :-
	initial(GameState),
	checkValidMove(GameState, 60, 61)
.

testMove :-
	initial(GameState),
	display_game(GameState),
	gameTurn(GameState, NGameState),
	display_game(NGameState),
	getPurplePoints(NGameState, PP),
	getWhitePoints(NGameState, WP),
	getZombiesPoints(NGameState, ZP),
	nl, write(PP), nl, write(WP), nl, write(ZP)
.
