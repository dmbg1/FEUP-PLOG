:- consult('board.pl').

play :-
	initial(GameState),
	[_, Player|_] = GameState,
	display_game(GameState, Player)
.