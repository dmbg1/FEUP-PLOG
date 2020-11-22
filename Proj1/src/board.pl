:- use_module(library(lists)).

% [Green Skull, Turn, Board, PurpleEatenPoints, WhiteEatenPoints, ZombieEatenPoints, PurpleCoords, WhiteCoords, ZombieCoords]
/*
initial([ purple, purple,
		         	               [[empty],
							    [empty, empty],
						    [green, empty, green],
					    [green, empty, empty, green],
			        [empty, empty, green, empty, empty],
		        [empty, empty, green, green, empty, empty],
	        [purple, empty, empty, green, empty, empty, white],
	    [purple, purple, empty, empty, empty, empty, white, white],
  	[purple, purple, purple, empty, empty, empty, white, white, white],
[purple, purple, purple, purple, empty, empty, white, white, white, white]],
0,  
0, 
0,
[60, 70, 71, 80, 81, 82, 90, 91, 92, 93],	% Purple Coords
[66, 76, 77, 86, 87, 88, 96, 97, 98, 99],   % White Coords
[20, 30, 22, 33, 42, 52, 53, 63]			% Zombie Coords
]  

% Digito das unidades indica o numero da peça dentro da linha = X
% Digito das dezenas indica a linha = Y
% 	Assim tem-se uma espécie de (x, y)
).
*/
initial([ purple, purple,
		         	               [[empty],
							    [empty, empty],
						    [green, empty, green],
					    [green, empty, empty, green],
			        [empty, empty, green, empty, empty],
		        [empty, empty, green, green, empty, empty],
	        [empty, empty, empty, green, empty, empty, white],
	    [empty, empty, empty, empty, empty, empty, white, white],
  	[empty, empty, empty, white, white, white, empty, white, white],
[empty, empty, empty, empty, empty, empty, purple, empty, white, white]],
0,  
0, 
0,
[95],	% Purple Coords
[66, 76, 77, 86, 87, 88, 96, 97, 98, 99],   % White Coords
[20, 30, 22, 33, 42, 52, 53, 63]			% Zombie Coords
]  

% Digito das unidades indica o numero da peça dentro da linha = X
% Digito das dezenas indica a linha = Y
% 	Assim tem-se uma espécie de (x, y)
).


getGSPlayer(Game, GS) :-
	nth0(0, Game, GS)
.
getPlayerTurn(Game, Turn) :-
	nth0(1, Game, Turn)
.
getBoard(Game, Board) :-
	nth0(2, Game, Board)
.

setPiece(Piece, GameStateOld,GameStateNew, Y, X) :-
	[Gs, Player, Board, PP, WP, ZP | T] = GameStateOld,
	nth0(Y, Board, Row, TmpBoard),
	nth0(X, Row, _, TmpRow),
	nth0(X, NewRow, Piece, TmpRow),
	nth0(Y, NewBoard, NewRow, TmpBoard),
	GameStateNew = [Gs, Player, NewBoard, PP, WP, ZP | T]
.

purpleEaten(GameOld, GameNew) :-
	[GS, Turn, Board, PP, WP, ZP | T] = GameOld,
	W1 is WP + 1,
	Z1 is ZP + 1,
	GameNew = [GS, Turn, Board, PP, W1, Z1 | T]
.
whiteEaten(GameOld, GameNew) :-
	[GS, Turn, Board, PP, WP, ZP | T] = GameOld,
	P1 is PP + 1,
	Z1 is ZP + 1,
	GameNew = [GS, Turn, Board, P1, WP, Z1 | T]
.
zombieEaten(GameOld, GameNew) :-
	[GS, Turn, Board, PP, WP, ZP | T] = GameOld,
	P1 is PP + 1,
	W1 is WP + 1,
	GameNew = [GS, Turn, Board, P1, W1, ZP | T]
.

parseCoord(Coord, Y, X) :-
	X is Coord rem 10,
	Y is div(Coord, 10)	
.

checkValidCoord(Y, X) :-
	X >= 0,
	X =< Y
.

content(Game, Y, X, Content) :-
	nth0(2, Game, Board),
	nth0(Y, Board, Line),
	nth0(X, Line, Content)
.


freeValidMove(StartY, StartX, EndY, EndX) :-
	EndY - StartY =:= -1,
	EndX - StartX =:= -1
.
freeValidMove(StartY, StartX, EndY, EndX) :-
	EndY - StartY =:= -1,
	EndX - StartX =:= 0
.
freeValidMove(StartY, StartX, EndY, EndX) :-
	EndY - StartY =:= 0,
	EndX - StartX =:= -1
.
freeValidMove(StartY, StartX, EndY, EndX) :-
	EndY - StartY =:= 0,
	EndX - StartX =:= 1
.
freeValidMove(StartY, StartX, EndY, EndX) :-
	EndY - StartY =:= 1,
	EndX - StartX =:= 0
.
freeValidMove(StartY, StartX, EndY, EndX) :-
	EndY - StartY =:= 1,
	EndX - StartX =:= 1
.

capturedCoord(StartY, StartX, EndY, EndX, MidY, MidX) :-
	EndY - StartY =:= -2,
	EndX - StartX =:= -2,
	MidY is StartY - 1,
	MidX is StartX - 1
.
capturedCoord(StartY, StartX, EndY, EndX, MidY, MidX) :-
	EndY - StartY =:= -2,
	EndX - StartX =:= 0,
	MidY is StartY - 1,
	MidX is StartX
.
capturedCoord(StartY, StartX, EndY, EndX, MidY, MidX) :-
	EndY - StartY =:= 0,
	EndX - StartX =:= -2,
	MidY is StartY,
	MidX is StartX - 1
.
capturedCoord(StartY, StartX, EndY, EndX, MidY, MidX) :-
	EndY - StartY =:= 0,
	EndX - StartX =:= 2,
	MidY is StartY,
	MidX is StartX + 1
.
capturedCoord(StartY, StartX, EndY, EndX, MidY, MidX) :-
	EndY - StartY =:= 2,
	EndX - StartX =:= 0,
	MidY is StartY + 1,
	MidX is StartX
.
capturedCoord(StartY, StartX, EndY, EndX, MidY, MidX) :-
	EndY - StartY =:= 2,
	EndX - StartX =:= 2,
	MidY is StartY + 1,
	MidX is StartX + 1
.

captureValidMove(Game, StartY, StartX, EndY, EndX) :-
	capturedCoord(StartY, StartX, EndY, EndX, MidY, MidX),
	content(Game, MidY, MidX, Content),
	Content \= empty
.


checkValidMove(Game, StartY, StartX, EndY, EndX, PieceColor, Capture) :-
	checkValidCoord(StartY, StartX),
	checkValidCoord(EndY, EndX),
	content(Game, StartY, StartX, StartContent),
	StartContent = PieceColor,
	content(Game, EndY, EndX, EndContent),
	EndContent = empty,
	freeValidMove(StartY, StartX, EndY, EndX),
	Capture = false
.

checkValidMove(Game, StartY, StartX, EndY, EndX, PieceColor, Capture) :-
	checkValidCoord(StartY, StartX),
	checkValidCoord(EndY, EndX),
	content(Game, StartY, StartX, StartContent),
	StartContent = PieceColor,
	content(Game, EndY, EndX, EndContent),
	EndContent = empty,
	captureValidMove(Game, StartY, StartX, EndY, EndX),
	Capture = true
.

countPurpleOnEdge([], 0, 0).
countPurpleOnEdge(Coords, Nr, Length) :-
	[Coord | Rest] = Coords,
	countPurpleOnEdge(Rest, NrRest, Len),
	Length is Len + 1,
	parseCoord(Coord, Y, X),
	((Y = X,
		Nr is NrRest + 2);
	(Y \= X,
		Nr is NrRest))
.
calcPurplePoints(Game, Points) :-
	[_, _, _, EatenPoints, _, _, Coords | _ ] = Game,
	countPurpleOnEdge(Coords, EdgePoints, _),
	Points is EatenPoints + EdgePoints
.

countWhiteOnEdge([], 0, 0).
countWhiteOnEdge(Coords, Nr, Length) :-
	[Coord | Rest] = Coords,
	countWhiteOnEdge(Rest, NrRest, Len),
	Length is Len + 1,
	parseCoord(Coord, _, X),
	((X = 0,
		Nr is NrRest + 2);
	(X \= 0,
		Nr is NrRest))
.
calcWhitePoints(Game, Points) :-
	[_, _, _, _, EatenPoints, _, _, Coords | _ ] = Game,
	countWhiteOnEdge(Coords, EdgePoints, _),
	Points is EatenPoints + EdgePoints
.

countGreenOnEdge([], 0, -1).
countGreenOnEdge(Coords, Nr, Length) :-
	[Coord | Rest] = Coords,
	countGreenOnEdge(Rest, NrRest, Len),
	Length is Len + 1,
	parseCoord(Coord, Y, _),
	((Y = 9,
		Nr is NrRest + 2);
	(Y \= 9,
		Nr is NrRest))
.
calcGreenPoints(Game, Points) :-
	[_, _, _, _, _, EatenPoints, _, _, Coords] = Game,
	countGreenOnEdge(Coords, EdgePoints, _),
	Points is EatenPoints + EdgePoints
.

checkEndGame(Game) :-
	[_, _, _, _, _, _, PCoords, WCoords, ZCoords] = Game,
	countPurpleOnEdge(PCoords, PEdgePoints, PLength),
	countWhiteOnEdge(WCoords, WEdgePoints, WLength),
	countGreenOnEdge(ZCoords, ZEdgePoints, ZLength),
	PLength \= 0,
	WLength \= 0,
	ZLength \= 0,
	PEdgePoints =\= 2 * PLength,
	WEdgePoints =\= 2 * WLength,
	ZEdgePoints =\= 2 * ZLength

.
