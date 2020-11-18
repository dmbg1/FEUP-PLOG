initial([ 'Purple', 'Purple',
		         	               [empty],
							    [empty, empty],
						    [green, empty, green],
					    [green, empty, empty, green],
			        [empty, empty, green, empty, empty],
		        [empty, empty, green, green, empty, empty],
	        [purple, empty, empty, green, empty, empty, white],
	    [purple, purple, empty, empty, empty, empty, white, white],
  	[purple, purple, purple, empty, empty, empty, white, white, white],
[purple, purple, purple, purple, empty, empty, white, white, white, white],
[P, 101, 102, 103, 104, 91, 92, 93, 81, 82, 71],
[W, 107, 108, 109, 110, 99, 98, 97, 88, 87, 77],
[G, 31, 33, 41, 44, 53, 63, 64, 74]
]
).

changeSkull(GameStateOld, GameStateNew) :-
	[Skull|Board] = GameStateOld,
	Skull == 'Purple',
	SkullNew = 'Green',
	GameStateNew = [SkullNew|Board]
.

changeSkull(GameStateOld, GameStateNew) :-
	[Skull|Board] = GameStateOld,
	Skull == 'Green',
	SkullNew = 'Purple',
	GameStateNew = [SkullNew|Board]
.

changeTurn(GameStateOld, GameStateNew) :-
	[Gs, Turn|Board] = GameStateOld,
	Turn == 'Purple',
	NewTurn = 'Green',
	GameStateNew =[Gs, NewTurn|Board]
.

changeTurn(GameStateOld, GameStateNew) :-
	[Gs, Turn|Board] = GameStateOld,
	Turn == 'Green',
	NewTurn = 'Purple',
	GameStateNew =[Gs, NewTurn|Board]
.

translate(empty, '.').
translate(purple,'P').
translate(green, 'G').
translate(white, 'W'). 

display_game(GameState, Player) :- 
	[Skull, _|Board] = GameState,
	printBoard(Board, 10), 	% 10 lines board
	printSkull(Skull),
	printPlayerTurn(Player)
.


printBoard(_, 0).
printBoard([H|T], N) :-
	N1 is N-1,
	printLine(H, N1),
	write('|'),
	nl,
	printBoard(T, N1)
.

printLine([], 0).
printLine([H|T], N) :-
	translate(H, Transl),
	format('~*c| ~w ', [N*2, 0' , Transl]),
	printLine(T, 0)
.

printSkull(HasSkull) :-
	write(HasSkull),
	write(' has the Skull'),
	nl
.
	
printPlayerTurn(Player) :-
	write(Player),
	write('\'s Turn'),
	nl
.