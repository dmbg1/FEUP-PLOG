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
	[Gs, Player|[Board]] = GameStateOld,
	nth0(Y, Board, Row, TmpBoard),
	nth0(X, Row, _, TmpRow),
	nth0(X, NewRow, Piece, TmpRow),
	nth0(Y, NewBoard, NewRow, TmpBoard),
	GameStateNew = [Gs, Player| [NewBoard]]
.

move(GameStateOld, GameStateNew, PieceColor) :-
	(	PieceColor = green ->
		inputGreenSkullMove(Ystart, Xstart, Yend, Xend);
		PieceColor \= green ->
		inputPlayerMove(Ystart, Xstart, Yend, Xend)
	),
	checkValidMove(GameStateOld, Ystart, Xstart, Yend, Xend, PieceColor),
	setPiece(empty, GameStateOld, GameStateNew1, Ystart, Xstart),
	setPiece(PieceColor, GameStateNew1, GameStateNew, Yend, Xend)
.


gameTurn(GameStateOld, GameStateNew, Turn) :- 
	getGSPlayer(GameStateOld, Gs),
	(	Gs = Turn ->
		move(GameStateOld, GameStateNew1, Turn),
		% display talvez
		move(GameStateNew1, GameStateNew2, green),
		changeTurn(GameStateNew2, GameStateNew3),
		changeSkull(GameStateNew3, GameStateNew);
		Gs \= Turn ->
		move(GameStateOld, GameStateNew1, Turn),
		changeTurn(GameStateNew1, GameStateNew)
	)
.