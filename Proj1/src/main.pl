:- consult('game.pl').


gameLoop(GameOld) :-
	display_game(GameOld),
	gameTurn(GameOld, GameNew),
	checkEndGame(GameNew),
	gameLoop(GameNew)
.

play :-
	initial(GameState),
	gameLoop(GameState)
.

testValidMove :-
	initial(GameState),
	checkValidMove(GameState, 60, 61)
.

testMove :-
	initial(GameState),
	display_game(GameState),
	gameTurn(GameState, NGameState),
	display_game(NGameState)
.
