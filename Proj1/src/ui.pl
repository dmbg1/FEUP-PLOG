:- consult('board.pl').

translate(empty, '.').
translate(purple,'P').
translate(green, 'G').
translate(white, 'W'). 

display_game(GameState) :- 
	getPlayerTurn(GameState, Player),
	getGSPlayer(GameState, Skull),
	getBoard(GameState, Board),
	printBoard(Board, 10), 	% 10 lines board,
	format('  ~*c', [41, 0'-]), nl,
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
 
inputPlayerMove(Ystart, Xstart, Yend, Xend) :-
	write('Input start coord move: '),
	read(StartCoord),
	write('Input end coord move: '),
	read(EndCoord),
	parseCoord(StartCoord, Ystart, Xstart),
	parseCoord(EndCoord, Yend, Xend)
.

inputGreenSkullMove(Ystart, Xstart, Yend, Xend, Done) :-
	write('Do you want to move a zombie(y/n)? '),
	read(Input),

	((	Input = y,
		inputPlayerMove(Ystart, Xstart, Yend, Xend),
		Done = true
		);(
		 Input = n, Done = false
	))
.



