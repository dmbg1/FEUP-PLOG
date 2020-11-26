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

getRequestedMove(StartCoord, EndCoord, MoveList, Move) :-
	write(MoveList), nl,
	MoveList \=[],
	[ValidMove|RestValidMoves] = MoveList,
	((ValidMove = [_, StartCoord, EndCoord|_], Move = ValidMove); 
	getRequestedMove(StartCoord, EndCoord, RestValidMoves, Move)),
	write('1')
.

requestMove(Game, PieceColor, Move) :- 
	inputPlayerMove(StartCoord, EndCoord),
	valid_moves(Game, PieceColor, ValidMoves),
	getRequestedMove(StartCoord, EndCoord, ValidMoves, Move)
.
requestMove(Game, PieceColor, Move) :-
	write('That is an invalid play, try again...'), nl, nl,
	requestMove(Game, PieceColor, Move)
.

gsVerificationsAndTurn(GameStateOld, Turn, GameStateNew) :- % Talvez precise de algumas mudanças
	getGSPlayer(GameStateOld, Gs),
	Gs = Turn,
	inputGreenSkullMove(Input),
	Input = y,
	requestMove(GameStateOld, green, Move),
	[MoveType|_] = Move,
	move(GameStateOld, GameStateNew1, Move),
	multiCapture(GameStateNew1, GameStateNew2, Turn, Move),
	(
		(MoveType = capture, changeSkull(GameStateNew2, GameStateNew))
		;
		(MoveType = move, GameStateNew = GameStateNew1)
	)
.
gsVerificationsAndTurn(GameStateOld, _, GameStateNew) :- GameStateOld = GameStateNew.

multiCapture(GameOld, GameNew, Turn, Move) :-
	parseCapture(Move, _, StartCoord, SubCaptures),
	length(SubCaptures, Len),
	Len \= 0,
	inputNextCapture(GameOld, EndCoord),
	EndCoord \= -1,
	(
		(
		getRequestedMove(StartCoord, EndCoord, SubCaptures, Capture), 
		move(GameOld, GameNew1, Capture))
		;
		(
		write('Wrong coord, try again...'), nl, nl, GameNew1 = GameOld, Capture = Move)
	),
	multiCapture(GameNew1, GameNew, Turn, Capture)
.
multiCapture(Game, Game, _, _).

gameTurn(GameStateOld, GameStateNew) :- % Talvez precise de algumas mudanças
	getPlayerTurn(GameStateOld, Turn),
	requestMove(GameStateOld, Turn, Move),
	move(GameStateOld, GameStateNew1, Move),
	[MoveType|_] = Move,
	multiCapture(GameStateNew1, GameStateNew2, Turn, Move),
	gsVerificationsAndTurn(GameStateNew2, Turn, GameStateNew3),
	getGSPlayer(GameStateNew3, GS),
	(
		(
		GS = Turn, MoveType = capture, 
		changeSkull(GameStateNew3, GameStateNew4),
		changeTurn(GameStateNew4, GameStateNew))
		;
		(
		GS \= Turn,
		changeTurn(GameStateNew3, GameStateNew))
		;
		(
		GS=Turn,
		changeTurn(GameStateNew3, GameStateNew))
	 )
.

gameLoop(GameOld) :-
    display_game(GameOld),
    gameTurn(GameOld, GameNew),
    (
        (game_over(GameNew, Winner), % game_over returns yes if game is not over yet and no otherwise
         gameLoop(GameNew));
        (display_game(GameNew), winnerToWords(Winner, WinnerStr), format('The Winner is: ~w!~n', [WinnerStr]))    % winScreen
    )
.