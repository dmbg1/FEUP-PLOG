:- consult('board.pl').
:- consult('ui.pl').

changeSkull(GameStateOld, GameStateNew) :-
	[Skull|Board] = GameStateOld,
	Skull = purple,
	SkullNew = white,
	GameStateNew = [SkullNew|Board]
.

changeSkull(GameStateOld, GameStateNew) :-
	[Skull|Board] = GameStateOld,
	Skull = white,
	SkullNew = purple,
	GameStateNew = [SkullNew|Board]
.

changeTurn(GameStateOld, GameStateNew) :-
	[Gs, Turn|Board] = GameStateOld,
	Turn = purple,
	NewTurn = white,
	GameStateNew = [Gs, NewTurn|Board]
.

changeTurn(GameStateOld, GameStateNew) :-
	[Gs, Turn|Board] = GameStateOld,
	Turn = white,
	NewTurn = purple,
	GameStateNew = [Gs, NewTurn|Board]
.

setPiece(Piece, GameStateOld,GameStateNew, Y, X) :-
	[Gs, Player, Board, PP, WP, ZP | T] = GameStateOld,
	nth0(Y, Board, Row, TmpBoard),
	nth0(X, Row, _, TmpRow),
	nth0(X, NewRow, Piece, TmpRow),
	nth0(Y, NewBoard, NewRow, TmpBoard),
	GameStateNew = [Gs, Player, NewBoard, PP, WP, ZP | T]
.

movePiece(GameOld, GameNew, StartY, StartX, EndY, EndX) :-
	content(GameOld, StartY, StartX, Piece),
	setPiece(empty, GameOld, GameAux, StartY, StartX),
	setPiece(Piece, GameAux, GameAux1, EndY, EndX),

	StartCoord is (StartY * 10) + StartX,
	EndCoord is (EndY * 10) + EndX,

	[Gs, Player, Board, PP, WP, ZP, PurpleCoordsOld, WhiteCoordsOld, ZombieCoordsOld] = GameAux1,

	((Piece = purple, 
		delete(PurpleCoordsOld, StartCoord, PurpleCoordsAux),
		PurpleCoordsNew = [EndCoord | PurpleCoordsAux],
		WhiteCoordsNew = WhiteCoordsOld,
		ZombieCoordsNew = ZombieCoordsOld);
	(Piece = white,
		delete(WhiteCoordsOld, StartCoord, WhiteCoordsAux),
		WhiteCoordsNew = [EndCoord | WhiteCoordsAux],
		PurpleCoordsNew = PurpleCoordsOld,
		ZombieCoordsNew = ZombieCoordsOld);
	(Piece = green,
		delete(ZombieCoordsOld, StartCoord, ZombieCoordsAux),
		ZombieCoordsNew = [EndCoord | ZombieCoordsAux],
		PurpleCoordsNew = PurpleCoordsOld,
		WhiteCoordsNew = WhiteCoordsOld)),

	GameNew = [Gs, Player, Board, PP, WP, ZP, PurpleCoordsNew, WhiteCoordsNew, ZombieCoordsNew]
.

capture(GameOld, GameNew, StartY, StartX, EndY, EndX):-
	capturedCoord(StartY, StartX, EndY, EndX, CapturedY, CapturedX),
	CapturedCoord is (CapturedY * 10) + CapturedX,
	
	[GS, T, B, _, _, _, PurpleCoordsOld, WhiteCoordsOld, ZombieCoordsOld] = GameOld,
	content(GameOld, CapturedY, CapturedX, Content),
	((Content = purple, purpleEaten(GameOld, GameAux), 
		[_, _, _, PP, WP, ZP, _, _, _] = GameAux,
		delete(PurpleCoordsOld, CapturedCoord, PurpleCoordsNew),
		format('HERE: ~w ~w ~w~n', [PurpleCoordsOld, PurpleCoordsNew, CapturedCoord]),
		WhiteCoordsNew = WhiteCoordsOld,
		ZombieCoordsNew = ZombieCoordsOld);
	 (Content = white, whiteEaten(GameOld, GameAux), 
		[_, _, _, PP, WP, ZP, _, _, _] = GameAux,
	 	delete(WhiteCoordsOld, CapturedCoord, WhiteCoordsNew),
	 	PurpleCoordsNew = PurpleCoordsOld,
		ZombieCoordsNew = ZombieCoordsOld);
	 (Content = green, zombieEaten(GameOld, GameAux),
		[_, _, _, PP, WP, ZP, _, _, _] = GameAux,
	  	delete(ZombieCoordsOld, CapturedCoord, ZombieCoordsNew),
		PurpleCoordsNew = PurpleCoordsOld,
		WhiteCoordsNew = WhiteCoordsOld)),
	
	GameAux1 = [GS, T, B, PP, WP, ZP, PurpleCoordsNew, WhiteCoordsNew, ZombieCoordsNew],

	setPiece(empty, GameAux1, GameNew, CapturedY, CapturedX)

.

requestMove(Game, StartY, StartX, EndY, EndX, PieceColor, Capture) :-
	(
		(PieceColor = green,
		inputGreenSkullMove(DoneGS),
			((DoneGS = true, 
			inputPlayerMove(StartY, StartX, EndY, EndX),
			checkValidMove(Game, StartY, StartX, EndY, EndX, PieceColor, Capture)
			);
			 (DoneGS = false, StartY = -1)
			)
		);
		(PieceColor \= green,
		inputPlayerMove(StartY, StartX, EndY, EndX),
		checkValidMove(Game, StartY, StartX, EndY, EndX, PieceColor, Capture))
	)
.
requestMove(Game, StartY, StartX, EndY, EndX, PieceColor, Capture) :-
	write('That is a invalid move, try again'), nl,
	requestMove(Game, StartY, StartX, EndY, EndX, PieceColor, Capture)
.


move(GameStateOld, GameStateNew, PieceColor) :-
	requestMove(GameStateOld, StartY, StartX, EndY, EndX, PieceColor, Capture),
	(
		(StartY \= -1, 
	 	movePiece(GameStateOld, GameStateNew1, StartY, StartX, EndY, EndX),
	 	(	
			(Capture = false, GameStateNew = GameStateNew1); 
	 		(Capture = true, 
			 	(PieceColor = green,
			  	capture(GameStateNew1, GameStateNew2, StartY, StartX, EndY, EndX),
			  	changeSkull(GameStateNew2, GameStateNew)
			  	);
			  	(PieceColor \= green), 
			  	capture(GameStateNew1, GameStateNew, StartY, StartX, EndY, EndX)
			)
		)
		);
		(StartY = -1, GameStateNew = GameStateOld) % Player doesn't want to move green piece
	)
.


gameTurn(GameStateOld, GameStateNew) :-
	getPlayerTurn(GameStateOld, Turn), 
	move(GameStateOld, GameStateNew1, Turn),
	getGSPlayer(GameStateNew1, Gs),
	(
		(	Gs = Turn,
		% display talvez
		move(GameStateNew1, GameStateNew2, green),
		changeTurn(GameStateNew2, GameStateNew)
		);
		( 	Gs \= Turn,
		changeTurn(GameStateNew1, GameStateNew)
		)
	)
.




