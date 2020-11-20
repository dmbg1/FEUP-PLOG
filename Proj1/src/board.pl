:- use_module(library(lists)).

% [Green Skull, Turn, Board, PurpleCoords, WhiteCoords, GreenCoords]

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
[purple, purple, purple, purple, empty, empty, white, white, white, white]] 
]

% Digito das unidades indica o numero da peça dentro da linha = X
% Digito das dezenas indica a linha = Y
% 	Assim tem-se uma espécie de (x, y)
).

getPlayerTurn(Game, Turn) :-
	nth0(1, Game, Turn)
.
getGSPlayer(Game, GS) :-
	nth0(0, Game, GS)
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

checkValidMove(Game, StartY, StartX, EndY, EndX, PieceColor) :-
	checkValidCoord(StartY, StartX),
	checkValidCoord(EndY, EndX),
	content(Game, StartY, StartX, StartContent),
	StartContent = PieceColor,
	content(Game, EndY, EndX, EndContent),
	EndContent = empty,
	freeValidMove(StartY, StartX, EndY, EndX)
.