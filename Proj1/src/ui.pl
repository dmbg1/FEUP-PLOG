:- consult('board.pl').

translate(empty, '.').
translate(purple,'P').
translate(green, 'G').
translate(white, 'W'). 

capitalize(purple, 'Purple').
capitalize(white, 'White').

display_game(GameState) :- 
	getPlayerTurn(GameState, Player),
	getGSPlayer(GameState, Skull),
	getBoard(GameState, Board),
	printBoard(Board, 10), 	% 10 lines board,
	format('  ~*c', [41, 0'-]), nl,
	printSkull(Skull),
	printPlayerTurn(Player),
	printPlayersPoints(GameState)
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
	capitalize(HasSkull, CappedSkull),
	write(CappedSkull),
	write(' has the Skull'),
	nl
.
	
printPlayerTurn(Player) :-
	capitalize(Player, CappedPlayer),
	write(CappedPlayer),
	write('\'s Turn'),
	nl
. 

printPlayersPoints(Game) :-
	calcPurplePoints(Game, Purple),
	calcWhitePoints(Game, White),
	calcGreenPoints(Game, Green),
	format('~nPoints:~n    Purple - ~w~n', [Purple]),
	format('    White - ~w~n', [White]),
	format('    Zombies - ~w~n~n', [Green])
.

% ---

inputNumberOfCaptures(NCap) :-
	write('How many captures will you make in this play (0 for none)? '),
	read(NCap),
	nl
.
inputPlayerMove(Ystart, Xstart, Yend, Xend, NCap) :-
	inputNumberOfCaptures(NCap),
	((NCap \= 0, write('Capture '), write('1'), write(':'), nl); (NCap = 0)),
	write('Input start coord move: '),
	read(StartCoord),
	write('Input end coord move: '),
	read(EndCoord),
	nl,
	parseCoord(StartCoord, Ystart, Xstart),
	parseCoord(EndCoord, Yend, Xend)
.

inputNextCapture(Yend, Xend) :-
	write('Input end coord move (0 to restart play): '),
	read(EndCoord),
	nl,
	((EndCoord = 0, fail); (EndCoord \= 0)),
	parseCoord(EndCoord, Yend, Xend)
.

inputGreenSkullMove(Done) :-
	write('Do you want to move a zombie(y/n)? '),
	read(Input),
	((	Input = y, Done = true);
	 ( Input = n, Done = false)),
	nl
.
inputGreenSkullMove(Done) :-
	write('Wrong answer, try again'), nl,
	inputGreenSkullMove(Done)
.



