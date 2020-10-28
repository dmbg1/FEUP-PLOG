:- dynamic(skull/1).
:- dynamic(turn/1).

initial([         	               [empty],
							    [empty, empty],
						    [green, empty, green],
					    [green, empty, empty, green],
			        [empty, empty, green, empty, empty],
		        [empty, empty, green, green, empty, empty],
	        [purple, empty, empty, green, empty, empty, white],
	    [purple, purple, empty, empty, empty, empty, white, white],
  	[purple, purple, purple, empty, empty, empty, white, white, white],
[purple, purple, purple, purple, empty, empty, white, white, white, white]]
).

skull('Purple').

changeSkull(New) :-
	skull(Current),
	Current == 'Purple',
	New = 'Green',
	retract(skull('Purple')),
	assert(skull('Green'))
.

changeSkull(New) :-
	skull(Current),
	Current == 'Green',
	New = 'Purple',
	retract(skull('Green')),
	assert(skull('Purple'))
.

turn('Purple').

changeTurn(New) :-
	turn(Current),
	Current == 'Purple',
	New = 'Green',
	retract(turn('Purple')),
	assert(turn('Green'))
.

changeTurn(New) :-
	turn(Current),
	Current == 'Green',
	New = 'Purple',
	retract(turn('Green')),
	assert(turn('Purple'))
.

translate(empty, '.').
translate(purple,'P').
translate(green, 'G').
translate(white, 'W'). 

display_game(GameState, Player) :- 
	initial(GameState),
	printBoard(GameState, 10), 	% 10 lines board
	nl,
	skull(HasSkull),
	printSkull(HasSkull),
	turn(Player),
	printPlayerTurn(Player)
.

printBoard([H|T], N) :-
	N1 is N-1,
	printLine(H, N1),
	write('|'),
	nl,
	printBoard(T, N1)
.
printBoard([],0).

printLine([H|T], N) :-
	translate(H, Transl),
	format('~*c| ~w ', [N*2, 0' , Transl]),
	printLine(T, 0)
.
printLine([], 0).

printSkull(HasSkull) :-
	write(HasSkull),
	write(' has the Skull'),
	nl
.
	
printPlayerTurn(Player) :-
	write(Player),
	write(' Turn:'),
	nl
.