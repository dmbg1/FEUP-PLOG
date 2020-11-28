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

getRequestedMove(StartCoord, EndCoord, [ValidMove|RestValidMoves], Move) :-
	ValidMove \= [],
	((ValidMove = [_, StartCoord, EndCoord|_], Move = ValidMove); 
	(getRequestedMove(StartCoord, EndCoord, RestValidMoves, Move)))
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

multiCapture(GameOld, GameNew, Turn, Move, Mode) :-
	parseCapture(Move, _, StartCoord, SubCaptures),
	length(SubCaptures, Len),
	Len \= 0,
	
	((Mode = noBot,
		inputNextCapture(GameOld, EndCoord));
	 (Mode = againstBot,
	 	(Turn \= white, 
			inputNextCapture(GameOld, EndCoord));
		(Turn = white,
			decide_multi_capture(GameOld, Turn, Move, EndCoord)
		)
	 );
	 (Mode = botAgainstBot,
		decide_multi_capture(GameOld, Turn, Move, EndCoord))
	),

	EndCoord \= -1,
	(
		(
		getRequestedMove(StartCoord, EndCoord, SubCaptures, Capture), 
		move(GameOld, GameNew1, Capture))
		;
		(
		write('Wrong coord, try again...'), nl, nl, GameNew1 = GameOld, Capture = Move)
	),
	multiCapture(GameNew1, GameNew, Turn, Capture, noBot)
.
multiCapture(Game, Game, _, _, _).

gameTurn(GameStateOld, GameStateNew, Mode) :- % Talvez precise de algumas mudanças
	getPlayerTurn(GameStateOld, Turn),

	((Mode = noBot,
		requestMove(GameStateOld, Turn, Move));
	 (Mode = againstBot,
	 	(Turn \= white, 
			requestMove(GameStateOld, Turn, Move));
		(Turn = white,
			choose_move(GameStateOld, Turn, 1, Move)
		)
	 );
	 (Mode = botAgainstBot,
		choose_move(GameStateOld, Turn, 1, Move))
	),
	[MoveType|_] = Move,

	move(GameStateOld, GameStateNew1, Move),

	multiCapture(GameStateNew1, GameStateNew2, Turn, Move, Mode),
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

gameTurn(GameStateOld, GameStateNew, againstBot) :- % Talvez precise de algumas mudanças
	getPlayerTurn(GameStateOld, Turn),
	Turn = purple, 
	gameTurn(GameStateOld, GameStateNew, noBot)
.
gameTurn(GameStateOld, GameStateNew, againstBot) :- % Talvez precise de algumas mudanças
	getPlayerTurn(GameStateOld, Turn),
	Turn = white,
	move(GameStateOld, GameStateNew1, Move),
	[MoveType|_] = Move,
	multiCapture(GameStateNew1, GameStateNew2, Turn, Move, againstBot),
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

gameLoop(GameOld, BotPlaying) :-
    display_game(GameOld),
    gameTurn(GameOld, GameNew, BotPlaying),
    (
        (game_over(GameNew, Winner), % game_over returns yes if game is not over yet and no otherwise
         gameLoop(GameNew, BotPlaying));
        (display_game(GameNew), winnerToWords(Winner, WinnerStr), format('The Winner is: ~w!~n', [WinnerStr]))    % winScreen
    )
.
