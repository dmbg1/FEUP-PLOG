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
checkValidMove(Game, Move, PieceColor, Capture):-
	nth0(0, Move, MoveType),
	MoveType = move,
	nth0(1, Move, StartCoord),
	nth0(2, Move, EndCoord),
    parseCoord(StartCoord, StartY, StartX),
    parseCoord(EndCoord, EndY, EndX),
    checkValidMove(Game, StartY, StartX, EndY, EndX, PieceColor, Capture)
.
getMove(StartCoord, EndCoord, ValidMove) :-
    append([], [move, StartCoord, EndCoord], ValidMove)
.
getMove(StartY, StartX, EndY, EndX, ValidMove) :-
	getCoord(StartY, StartX, StartCoord),
	getCoord(EndY, EndX, EndCoord),
	getMove(StartCoord, EndCoord, ValidMove)
.
getCapture(StartCoord, EndCoord, ValidMove) :-
    append([], [capture, StartCoord, EndCoord], ValidMove)
.
getCapture(StartY, StartX, EndY, EndX, ValidMove) :-
	getCoord(StartY, StartX, StartCoord),
	getCoord(EndY, EndX, EndCoord),
	getCapture(StartCoord, EndCoord, ValidMove)
.

myBetween(Start, End, Step, Start) :-
	fin
.

valid_captures(Game, Player, MovesList) :-
     ((Player = purple, Game = [GS, _, _, _, _, _, Coords, _, _]);
    (Player = white, Game = [GS, _, _, _, _, _, _, Coords, _]);
    (Player = green, Game = [GS, _, _, _, _, _, _, _, Coords])),
    
    findall(Move, (
		member(StartCoord, Coords),
		between(-2, 2, XDiff), (XDiff = -2 ; XDiff = 2),
		between(-2, 2, YDiff), (YDiff = -2 ; YDiff = 2),
		parseCoord(StartCoord, StartY, StartX),
		EndY is StartY + YDiff,
		EndX is StartX + XDiff,
		getMove(StartY, StartX, EndY, EndX, Move), 
		checkValidMove(Game, Move, Player, true),
		), MovesList)
.

valid_moves(Game, Player, MovesList) :-
     ((Player = purple, Game = [GS, _, _, _, _, _, Coords, _, _]);
    (Player = white, Game = [GS, _, _, _, _, _, _, Coords, _]);
    (Player = green, Game = [GS, _, _, _, _, _, _, _, Coords])),
    
    findall(Move, (
		member(StartCoord, Coords),
		between(-1, 1, XDiff), (XDiff = -1 ; XDiff = 1),
		between(-1, 1, YDiff), (YDiff = -1 ; YDiff = 1),
		parseCoord(StartCoord, StartY, StartX),
		EndY is StartY + YDiff,
		EndX is StartX + XDiff,
		getMove(StartY, StartX, EndY, EndX, Move), 
		checkValidMove(Game, Move, Player, false),
		), MovesList)
.