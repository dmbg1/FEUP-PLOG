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

inputPlayerMove(StartCoord, EndCoord) :-
	write('Input start coord move: '),
	read(StartCoord),
	write('Input end coord move: '),
	read(EndCoord),
	number(StartCoord), StartCoord < 100, StartCoord > 0, 
	number(EndCoord), EndCoord < 100, EndCoord > 0,
	nl
.

inputNextCapture(Coord) :-
	write('There is still a capture available! '), nl, write('Input the available coord move (-1 to stay)'),
	read(Coord),
	nl,
	((EndCoord = -1, fail); (EndCoord \= -1))
.

inputGreenSkullMove(Input) :-
	write('Do you want to move a zombie(y/n)? '),
	read(Input),
	nl,
	(Input = y; Input = n)
.
inputGreenSkullMove(Input) :-
	write('Wrong answer, try again'), nl,
	inputGreenSkullMove(Input)
.



