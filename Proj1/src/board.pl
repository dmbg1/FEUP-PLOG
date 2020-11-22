:- use_module(library(lists)).

% [Green Skull, Turn, Board, PurplePoints, WhitePoints, ZombiePoints]

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
0]  

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
getPurplePoints(Game, PurplePoints) :-
	nth0(3, Game, PurplePoints)
.
getWhitePoints(Game, WhitePoints) :-
	nth0(4, Game, WhitePoints)
.
getZombiesPoints(Game, ZombiesPoints) :-
	nth0(5, Game, ZombiesPoints)
.

purpleEaten(GameOld, GameNew) :-
	[GS, Turn, Board, PP, WP, ZP] = GameOld,
	W1 is WP + 1,
	Z1 is ZP + 1,
	GameNew = [GS, Turn, Board, PP, W1, Z1]
.
whiteEaten(GameOld, GameNew) :-
	[GS, Turn, Board, PP, WP, ZP] = GameOld,
	P1 is PP + 1,
	Z1 is ZP + 1,
	GameNew = [GS, Turn, Board, P1, WP, Z1]
.
zombieEaten(GameOld, GameNew) :-
	[GS, Turn, Board, PP, WP, ZP] = GameOld,
	P1 is PP + 1,
	W1 is WP + 1,
	GameNew = [GS, Turn, Board, P1, W1, ZP]
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
	StartContent == PieceColor,
	content(Game, EndY, EndX, EndContent),
	EndContent == empty,
	freeValidMove(StartY, StartX, EndY, EndX),
	Capture = false
.

checkValidMove(Game, StartY, StartX, EndY, EndX, PieceColor, Capture) :-
	checkValidCoord(StartY, StartX),
	checkValidCoord(EndY, EndX),
	content(Game, StartY, StartX, StartContent),
	StartContent == PieceColor,
	content(Game, EndY, EndX, EndContent),
	EndContent == empty,
	captureValidMove(Game, StartY, StartX, EndY, EndX),
	Capture = true
.
