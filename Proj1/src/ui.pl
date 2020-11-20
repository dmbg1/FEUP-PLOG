translate(empty, '.').
translate(purple,'P').
translate(green, 'G').
translate(white, 'W'). 

display_game(GameState, Player) :- 
	[Skull, _|Board] = GameState,
	printBoard(Board, 10), 	% 10 lines board,
	format('  ~*c', [10*5-9, 0'-]), nl,
	write('    A B C D E F G H I J K L M N O P Q R S'), nl, nl,
	printSkull(Skull),
	printPlayerTurn(Player)
.

printLine([], 0).
printLine([H|T], N) :-
	translate(H, Transl),
	format('~*c| ~w ', [N*2, 0' , Transl]),
	printLine(T, 0)
.

printBoard([], 0).
printBoard([H|T], N) :-
	N1 is N-1,
	N2 is 9-N1,	% For line coordinate display
	format('~*c~*c', [N*2, 0' , 4*N2+5, 0'-]), nl,
	write(N2), write(' '),
	printLine(H, N1),
	write('|'),nl,
	printBoard(T, N1)
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
 
inputPlayerMove(Game, StartCoord, EndCoord) :-
	write('Input start coord move: '),
	read(StartCoord),
	write('Input start end move: '),
	read(EndCoord),
	checkValidMove(Game, StartCoord, EndCoord)

.



