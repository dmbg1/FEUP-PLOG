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

parseCoord(Coord, Y, X) :-
	X is Coord rem 10,
	Y is div(Coord, 10)	
.

checkValidCoord(Coord) :-
	parseCoord(Coord, Y, X),
	X >= 0,
	X =< Y
.

content(Game, Coord, Content) :-
	nth0(2, Game, Board),
	parseCoord(Coord, Y, X),
	nth0(Y, Board, Line),
	nth0(X, Line, Content)
.


freeValidMove(StartCoord, EndCoord) :-
	parseCoord(StartCoord, StartY, StartX),
	parseCoord(EndCoord, EndY, EndX),
	EndY - StartY =:= -1,
	EndX - StartX =:= -1
.
freeValidMove(StartCoord, EndCoord) :-
	parseCoord(StartCoord, StartY, StartX),
	parseCoord(EndCoord, EndY, EndX),
	EndY - StartY =:= -1,
	EndX - StartX =:= 0
.
freeValidMove(StartCoord, EndCoord) :-
	parseCoord(StartCoord, StartY, StartX),
	parseCoord(EndCoord, EndY, EndX),
	EndY - StartY =:= 0,
	EndX - StartX =:= -1
.
freeValidMove(StartCoord, EndCoord) :-
	parseCoord(StartCoord, StartY, StartX),
	parseCoord(EndCoord, EndY, EndX),
	EndY - StartY =:= 0,
	EndX - StartX =:= 1
.
freeValidMove(StartCoord, EndCoord) :-
	parseCoord(StartCoord, StartY, StartX),
	parseCoord(EndCoord, EndY, EndX),
	EndY - StartY =:= 1,
	EndX - StartX =:= 0
.
freeValidMove(StartCoord, EndCoord) :-
	parseCoord(StartCoord, StartY, StartX),
	parseCoord(EndCoord, EndY, EndX),
	EndY - StartY =:= 1,
	EndX - StartX =:= 1
.

checkValidMove(Game, StartCoord, EndCoord) :-
	getPlayerTurn(Game, Turn),
	checkValidCoord(StartCoord),
	checkValidCoord(EndCoord),
	content(Game, StartCoord, StartContent),
	StartContent == Turn,
	content(Game, EndCoord, EndContent),
	EndContent == empty,
	freeValidMove(StartCoord, EndCoord)
.