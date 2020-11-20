:- consult('game.pl').

startGame :-
	initial(GameState),
	getPlayerTurn(GameState, Player),
	display_game(GameState, Player)
.

testValidMove :-
	initial(GameState),
	checkValidMove(GameState, 60, 61)
.

testMove :-
	initial(GameState),
	getPlayerTurn(GameState, Player),
	display_game(GameState, Player),
	gameTurn(GameState, NGameState, Player),
	getPlayerTurn(NGameState, NPlayer),
	display_game(NGameState, NPlayer)
.

