:- consult('game.pl').

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


main :-
    format('    ---------------~n    | GREEN SKULL |~n    ---------------~n', []),
    format('       Main Menu~nChoose an option:~n1 - Play~n2 - Settings~n3 - Instructions~n4 - Exit~n', []),
    read(Input),
    ((Input = 1, 
        play,
		main);
    (Input = 2, 
		format('Settings not implemented~n', []),
		main);
	(Input = 3, 
		format('Your objective is to have more points than the other player and the zombies.~nNote that the zombies can win the game too.~n~n', []),
		format('Each captured piece of a player gives both opponents 1 point.~nWhen the game ends, each piece at the opposite side of the initial display gives that player 2 points.~n',[]),
		format('Zombies score the same way as players.~n~nThe player who possesses the skull controls the zombies. If that player captures a piece, using or not using the zombies, he loses the skull.~n~n',[]),
		format('A position\'s coordinate has the following structure:~n  -It is a 2 digit number~n  -The most significant digit represents the number of the position\'s line. It goes from 0 to 9~n',[]),
		format('  -The unit digit represents the position within that line. Since the board is a triangle, the range of values varies from line to line~n~n',[]),
		format('A piece can move to an empty adjacent space, or it can capture an adjacent piece by jumping over it.~nMultiple piece captures are allowed.~n~n',[]),
		main);
    (Input = 4);
    (format('Not an option, try again...~n', []), main))
.

