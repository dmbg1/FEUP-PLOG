:- consult('board.pl').
:- consult('ui.pl').

startGame :-
	initial(GameState),
	[_, Player|_] = GameState,
	display_game(GameState, Player)
.

testValidMove :-
	initial(GameState),
	checkValidMove(GameState, 60, 61)
.

