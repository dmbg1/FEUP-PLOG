:- consult('board.pl').

play :-
	initial(GameState),
	turn(Player),
	display_game(GameState, Player)
.