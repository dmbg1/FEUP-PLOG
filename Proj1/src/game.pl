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


requestNextCapture(Game, StartY, StartX, EndY, EndX, PieceColor) :- 
	inputNextCapture(EndY, EndX),
	((checkValidMove(Game, StartY, StartX, EndY, EndX, PieceColor, Capture),
	  Capture = true);
	  (write('That is not a capture! Try again'), nl, nl,
	   requestNextCapture(Game, StartY, StartX, EndY, EndX, PieceColor))
	)
.

capture(GameOld, GameNew, _, _, _,_, _, 0, _) :- GameNew = GameOld.
capture(GameOld, GameNew, StartY, StartX, EndY, EndX, PieceColor, NCap, CurrCap):-
	(
		(CurrCap = 1); 
		(CurrCap > 1, 
	 	 write('Capture '), write(CurrCap), write(':'), nl, 
	     ((requestNextCapture(GameOld, StartY, StartX, EndY, EndX, PieceColor));
	     (!, fail)))
  	),
	movePiece(GameOld, GameNew1, StartY, StartX, EndY, EndX),
	capturedCoord(StartY, StartX, EndY, EndX, CapturedY, CapturedX),
	CapturedCoord is (CapturedY * 10) + CapturedX,
	[GS, T, B, _, _, _, PurpleCoordsOld, WhiteCoordsOld, ZombieCoordsOld] = GameNew1,
	content(GameNew1, CapturedY, CapturedX, Content),
	((Content = purple, purpleEaten(GameNew1, GameAux), 
		[_, _, _, PP, WP, ZP, _, _, _] = GameAux,
		delete(PurpleCoordsOld, CapturedCoord, PurpleCoordsNew),
		WhiteCoordsNew = WhiteCoordsOld,
		ZombieCoordsNew = ZombieCoordsOld);
	 (Content = white, whiteEaten(GameNew1, GameAux), 
		[_, _, _, PP, WP, ZP, _, _, _] = GameAux,
	 	delete(WhiteCoordsOld, CapturedCoord, WhiteCoordsNew),
	 	PurpleCoordsNew = PurpleCoordsOld,
		ZombieCoordsNew = ZombieCoordsOld);
	 (Content = green, zombieEaten(GameNew1, GameAux),
		[_, _, _, PP, WP, ZP, _, _, _] = GameAux,
	  	delete(ZombieCoordsOld, CapturedCoord, ZombieCoordsNew),
		PurpleCoordsNew = PurpleCoordsOld,
		WhiteCoordsNew = WhiteCoordsOld)),
	
	GameAux1 = [GS, T, B, PP, WP, ZP, PurpleCoordsNew, WhiteCoordsNew, ZombieCoordsNew],

	setPiece(empty, GameAux1, GameNew2, CapturedY, CapturedX),

	NCap1 is NCap - 1,
	CurrCap1 is CurrCap + 1,

	capture(GameNew2, GameNew, EndY, EndX, _EY, _EX, PieceColor, NCap1, CurrCap1),
.

requestMove(Game, StartY, StartX, EndY, EndX, PieceColor, Capture, NCap) :-
	(
		(PieceColor = green,
		inputGreenSkullMove(DoneGS),
			((DoneGS = true, 
			inputPlayerMove(StartY, StartX, EndY, EndX, NCap),
			checkValidMove(Game, StartY, StartX, EndY, EndX, PieceColor, Capture),
				((Capture = true, NCap > 0);
				 (Capture = false, NCap = 0);
		 		 (Capture = true, NCap = 0, write('That is a capture!'), nl, fail);
		 		 (Capture = false, NCap > 0, write('That isn\'t a capture!'), nl, fail))
			);
			 (DoneGS = false, StartY = -1)
			)
		);
		(PieceColor \= green,
		inputPlayerMove(StartY, StartX, EndY, EndX, NCap),
		checkValidMove(Game, StartY, StartX, EndY, EndX, PieceColor, Capture),
			((Capture = true, NCap > 0);
			 (Capture = false, NCap = 0);
		 	 (Capture = true, NCap = 0, write('That is a capture!'), nl, fail);
			 (Capture = false, NCap > 0, write('That isn\'t a capture!'), nl, fail))
		)
	)
.
requestMove(Game, StartY, StartX, EndY, EndX, PieceColor, Capture, NCap) :-
	write('That is an invalid play, try again'), nl, nl,
	requestMove(Game, StartY, StartX, EndY, EndX, PieceColor, Capture, NCap)
.

move(GameStateOld, GameStateNew, PieceColor) :-
	requestMove(GameStateOld, StartY, StartX, EndY, EndX, PieceColor, Capture, NCap),
	(
		(StartY \= -1, 
	 	(	
			(Capture = false,
			 movePiece(GameStateOld, GameStateNew1, StartY, StartX, EndY, EndX),
		     GameStateNew = GameStateNew1); 
	 		(Capture = true, 
			 	(PieceColor = green,
			  	((
					capture(GameStateOld, GameStateNew1, StartY, StartX, EndY, EndX, PieceColor, NCap, 1),
				  	changeSkull(GameStateNew1, GameStateNew));
				 (	
					write('Restarting play...'), nl, nl,
					move(GameStateOld, GameStateNew, PieceColor))
				 ));
			  	(PieceColor \= green, 
				((
					capture(GameStateOld, GameStateNew, StartY, StartX, EndY, EndX, PieceColor, NCap, 1));
				 (
					write('Restarting play...'), nl, nl,
					move(GameStateOld, GameStateNew, PieceColor))
				 ))
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




