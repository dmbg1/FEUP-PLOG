:- dynamic(skull/1).

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

skull(purple).

changeSkull(New) :-
	skull(Current),
	Current == purple,
	New = green,
	retract(skull(purple)),
	assert(skull(green))
.

changeSkull(New) :-
	skull(Current),
	Current == green,
	New = purple,
	retract(skull(green)),
	assert(skull(purple))
.

translate(empty, '.').
translate(purple,'P').
translate(green, 'G').
translate(white, 'W'). 

display_game(GameState,_Player) :- 
	initial(GameState),
	printBoard(GameState, 10), 	% 10 lines board
	nl,
	skull(HasSkull),
	printSkull(HasSkull)
.

printBoard([H|T], N) :-
	N1 is N-1,
	printLine(H, N),
	write('|'),
	nl,
	printBoard(T, N1)
.
printBoard([],0).

printLine([H|T], N) :-
	translate(H, Transl),
	format('~*c| ~w ', [N*2, 0 , Transl]),
	printLine(T, 0)
.
printLine([], 0).

printSkull(HasSkull) :-
	write(HasSkull),
	write(' has the Skull')
.
	
