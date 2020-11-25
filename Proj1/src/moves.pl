:- consult('board.pl').

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
checkValidMove(Game, StartCoord, Coord, PieceColor, Capture):-
    parseCoord(StartCoord, StartY, StartX),
    parseCoord(Coord, EndY, EndX),
    checkValidMove(Game, StartY, StartX, EndY, EndX, PieceColor, Capture)
.
getMove(Game, StartCoord, Coord, PieceColor, ValidMove) :-
    checkValidMove(Game, StartCoord, Coord, PieceColor, false), 
    append([], [move, StartCoord, Coord], ValidMove)
.
getMove(Game, StartCoord, Coord, PieceColor, ValidMove) :-
    checkValidMove(Game, StartCoord, Coord, PieceColor, true), 
    append([], [capture, StartCoord, Coord], ValidMove)
.

valid_moves(Game, Player, MovesList) :-
     ((Turn = purple, Game = [GS, _, _, _, _, _, Coords, _, _]);
    (Turn = white, Game = [GS, _, _, _, _, _, _, Coords, _]);
    (Turn = green, Game = [GS, _, _, _, _, _, _, _, Coords])),
    
    findall(Move, getMove(Game, _StartCoord, _EndCoord, Player, Move), MovesList)
.