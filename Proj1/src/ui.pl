translate(empty, '.').
translate(purple,'P').
translate(green, 'G').
translate(white, 'W'). 

capitalize(purple, 'Purple').
capitalize(white, 'White').

% Faz o display da board
display_game(GameState) :- 
	getPlayerTurn(GameState, Player),
	getGSPlayer(GameState, Skull),
	getBoard(GameState, Board),
	printPlayerTurn(Player),
	printBoard(Board, 10), 	% 10 lines board,
	format('  ~*c', [41, 0'-]), nl,
	printSkull(Skull),
	printPlayersPoints(GameState)
.

/* Desenha as linhas da board recebendo como argumentos a lista que contém as informações da board
necessárias ao desenho da mesma e o número de linhas a desenhar */
printLine([], 0).
printLine([H|T], N) :-
	translate(H, Transl),
	format('~*c| ~w ', [N*2, 0' , Transl]),
	printLine(T, 0)
.

% Faz o desenho da board com o auxílio do predicado anterior recebendo os mesmos argumentos
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


% Mostra o jogador com a Green Skull 
printSkull(HasSkull) :-
	capitalize(HasSkull, CappedSkull),
	write(CappedSkull),
	write(' has the Skull'),
	nl
.
	
% Mostra a vez do jogador 
printPlayerTurn(Player) :-
	capitalize(Player, CappedPlayer),
	 format('    ---------------~n    | ~w Turn |~n    ---------------~n', [CappedPlayer])
. 

% Mostra os pontos dos jogadores e dos zombies
printPlayersPoints(Game) :-
	calcPurplePoints(Game, Purple),
	calcWhitePoints(Game, White),
	calcGreenPoints(Game, Green),
	format('~nPoints:~n    Purple - ~w~n', [Purple]),
	format('    White - ~w~n', [White]),
	format('    Green - ~w~n~n', [Green])
.

% Clear Screen
cls :- 
	write('\33\[2J')
.

% Pede ao jogador as coordenadas de um movimento e recebe o input das mesmas 
inputPlayerMove(StartCoord, EndCoord) :-
	write('Input start coord move: '),
	read(StartCoord),
	write('Input end coord move: '),
	read(EndCoord),
	number(StartCoord), StartCoord < 100, StartCoord > 0, 
	number(EndCoord), EndCoord < 100, EndCoord > 0,
	nl
.

/* Informa ao jogador que ainda é possível mais uma captura e solicita a coordenada do salto disponível,
recebendo o seu input */
inputNextCapture(Game, Coord) :-
	cls,
	display_game(Game),
	write('There is still a capture available! '), nl, write('Input the available coord move (-1 to stay)'),
	read(Coord),
	nl
.

% Recebe input (y ou n) útil para registar a decisão do utilizador no movimento das peças verdes
inputGreenSkullMove(Input) :-
	write('Do you want to move a zombie (y/n)? '),
	read(Input),
	nl,
	(Input = y; Input = n)
.



