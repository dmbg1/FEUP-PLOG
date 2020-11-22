:- consult('board.pl').
:- consult('ui.pl').

changeSkull(GameStateOld, GameStateNew) :-
	[Skull|Board] = GameStateOld,
	Skull = purple,
	SkullNew = green,
	GameStateNew = [SkullNew|Board]
.

changeSkull(GameStateOld, GameStateNew) :-
	[Skull|Board] = GameStateOld,
	Skull = green,
	SkullNew = purple,
	GameStateNew = [SkullNew|Board]
.

changeTurn(GameStateOld, GameStateNew) :-
	[Gs, Turn|Board] = GameStateOld,
	Turn = purple,
	NewTurn = green,
	GameStateNew = [Gs, NewTurn|Board]
.

changeTurn(GameStateOld, GameStateNew) :-
	[Gs, Turn|Board] = GameStateOld,
	Turn = green,
	NewTurn = purple,
	GameStateNew = [Gs, NewTurn|Board]
.

setPiece(Piece, GameStateOld,GameStateNew, Y, X) :-
	[Gs, Player, Board, PP, WP, ZP] = GameStateOld,
	nth0(Y, Board, Row, TmpBoard),
	nth0(X, Row, _, TmpRow),
	nth0(X, NewRow, Piece, TmpRow),
	nth0(Y, NewBoard, NewRow, TmpBoard),
	GameStateNew = [Gs, Player, NewBoard, PP, WP, ZP]
.

capture(GameOld, GameNew, StartY, StartX, EndY, EndX):-
	capturedCoord(StartY, StartX, EndY, EndX, CapturedY, CapturedX),
	content(GameOld, CapturedY, CapturedX, Content),
	((Content = purple, purpleEaten(GameOld, GameAux));
	 (Content = white, whiteEaten(GameOld, GameAux));
	 (Content = green, greenEaten(GameOld, GameAux))),
	setPiece(empty, GameAux, GameNew, CapturedY, CapturedX)
.


move(GameStateOld, GameStateNew, PieceColor) :-
	PieceColor \= green,
	inputPlayerMove(StartY, StartX, EndY, EndX),
	checkValidMove(GameStateOld, StartY, StartX, EndY, EndX, PieceColor, Capture),
	((	Capture = false,
	setPiece(empty, GameStateOld, GameStateNew1, StartY, StartX),
	setPiece(PieceColor, GameStateNew1, GameStateNew, EndY, EndX) 
	); ( Capture = true,
	setPiece(empty, GameStateOld, GameStateNew1, StartY, StartX),
	capture(GameStateNew1, GameStateNew2, StartY, StartX, EndY, EndX),
	setPiece(PieceColor, GameStateNew2, GameStateNew, EndY, EndX) 
	))
.
move(GameStateOld, GameStateNew, PieceColor) :-
	PieceColor = green,
	inputGreenSkullMove(StartY, StartX, EndY, EndX, DoneGS),
	(( DoneGS = true,
		checkValidMove(GameStateOld, StartY, StartX, EndY, EndX, PieceColor, Capture),
			((	Capture = false,
			setPiece(empty, GameStateOld, GameStateNew1, StartY, StartX),
			setPiece(PieceColor, GameStateNew1, GameStateNew, EndY, EndX) 
			); ( Capture = true,
			setPiece(empty, GameStateOld, GameStateNew1, StartY, StartX),
			capture(GameStateNew1, GameStateNew2, StartY, StartX, EndY, EndX),
			setPiece(PieceColor, GameStateNew2, GameStateNew, EndY, EndX) 
			))
	) ; (DoneGS = false, GameStateNew = GameStateOld))
.


gameTurn(GameStateOld, GameStateNew) :-
	getPlayerTurn(GameStateOld, Turn), 
	getGSPlayer(GameStateOld, Gs),
	(	Gs = Turn,
		move(GameStateOld, GameStateNew1, Turn),
		% display talvez
		move(GameStateNew1, GameStateNew2, green),
		changeTurn(GameStateNew2, GameStateNew3),
		changeSkull(GameStateNew3, GameStateNew)
	);(
		Gs \= Turn,
		move(GameStateOld, GameStateNew1, Turn),
		changeTurn(GameStateNew1, GameStateNew)
	)
.


