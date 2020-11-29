% Dá início ao jogo recebendo como argumento o modo de jogo (bot vs bot, player vs bot e player vs bot)
start_game(botAgainstBot, 0, Difficulty) :-
	initial(Game),
	display_game(Game), sleep(5),
	gameLoop(Game, botAgainstBot, 0, Difficulty)
.
start_game(Mode, BetweenTurns, Difficulty) :-
	initial(Game),
	gameLoop(Game, Mode, BetweenTurns, Difficulty)
.

% Troca o jogador que contém a skull criando um novo estado de jogo contendo informação
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

% Troca a turn do jogador criando um novo estado de jogo contendo essa informação
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

/*  getRequestedMove(+StartCoord, +EndCoord, +ValidMoves, -Move)
	
	
	Predicado auxiliar ao requestMove que sucede quando o move solicitado pelo utilizador pertence à lista de jogadas válidas e 
	transforma as mesmas numa jogada válida a ser processada noutros predicados */
getRequestedMove(StartCoord, EndCoord, [ValidMove|RestValidMoves], Move) :-
	ValidMove \= [],
	((ValidMove = [_, StartCoord, EndCoord|_], Move = ValidMove); 
	(getRequestedMove(StartCoord, EndCoord, RestValidMoves, Move)))
.

/* 	requestMove(+Game, +PieceColor, -Move)
	
	
	Recebe as coordenadas da jogada requerida pelo utilizador e verifica se as mesmas podem ser transformadas numa jogada 
	válida com o auxílio do predicado getRequestedMove. Quando esta não termina ou o input não é válido é enviada uma
	mensagem a referir que a jogada é inválida e são pedidas as coordenadas novamente */
requestMove(Game, PieceColor, Move) :- 
	inputPlayerMove(StartCoord, EndCoord),
	valid_moves(Game, PieceColor, ValidMoves),
	getRequestedMove(StartCoord, EndCoord, ValidMoves, Move)
.
requestMove(Game, PieceColor, Move) :-
	write('That is an invalid play, try again...'), nl, nl,
	requestMove(Game, PieceColor, Move)
.

% Responsável pelas jogadas com as peças verdes dos jogadores com a green skull
gsVerificationsAndTurn(GameStateOld, Turn, GameStateNew, noBot, _Difficulty) :-
	getGSPlayer(GameStateOld, Gs),
	Gs = Turn,
	cls,
	display_game(GameStateOld),
	inputGreenSkullMove(Input),
	Input = y,
	write('Move Zombie'), nl,
	requestMove(GameStateOld, green, Move),

	move(GameStateOld, GameStateNew1, Move),
	[MoveType|_] = Move,
	((MoveType = capture, changeSkull(GameStateNew1, GameStateNew2); (GameStateNew2 = GameStateNew1))),
	multiCapture(GameStateNew2, GameStateNew, Turn, Move, noBot, _Difficulty)
.
gsVerificationsAndTurn(GameStateOld, Turn, GameStateNew, againstBot, Difficulty) :-
	getGSPlayer(GameStateOld, Gs),
	Gs = Turn,

	(
		(Turn \= white, 
			cls,
			display_game(GameStateOld),
			inputGreenSkullMove(Input),
			Input = y,
			write('Move Zombie'), nl,
			requestMove(GameStateOld, green, Move));
		(Turn = white,
			choose_move(GameStateOld, green, Difficulty, Move),
			Move \= [])
	),

	move(GameStateOld, GameStateNew1, Move),
	[MoveType|_] = Move,
	((MoveType = capture, changeSkull(GameStateNew1, GameStateNew2); (GameStateNew2 = GameStateNew1))),
	multiCapture(GameStateNew2, GameStateNew, Turn, Move, againstBot, Difficulty)
.
gsVerificationsAndTurn(GameStateOld, Turn, GameStateNew, botAgainstBot, Difficulty) :-
	getGSPlayer(GameStateOld, Gs),
	Gs = Turn,
	choose_move(GameStateOld, green, Difficulty, Move),
	Move \= [],

	move(GameStateOld, GameStateNew1, Move),
	
	[MoveType|_] = Move,
	((MoveType = capture, changeSkull(GameStateNew1, GameStateNew2); (GameStateNew2 = GameStateNew1))),

	multiCapture(GameStateNew2, GameStateNew, Turn, Move, botAgainstBot, Difficulty)
.
gsVerificationsAndTurn(GameStateOld, _, GameStateOld, _, _).


% Lida com situações de captura múltipla
multiCapture(GameOld, GameNew, Turn, Move, noBot, _) :-
	parseCapture(Move, _, StartCoord, SubCaptures),
	length(SubCaptures, Len),
	Len \= 0,

	inputNextCapture(GameOld, EndCoord),

	EndCoord \= -1,
	(
		(
		getRequestedMove(StartCoord, EndCoord, SubCaptures, Capture), 
		move(GameOld, GameNew1, Capture));
		(
		write('Wrong coord, try again...'), nl, nl, GameNew1 = GameOld, Capture = Move)
	),
	multiCapture(GameNew1, GameNew, Turn, Capture, noBot, _)
.
multiCapture(GameOld, GameNew, Turn, Move, againstBot, 0) :-
	parseCapture(Move, _, StartCoord, SubCaptures),
	length(SubCaptures, Len),
	Len \= 0,

	(
		(Turn \= white, inputNextCapture(GameOld, EndCoord));
		(Turn = white, EndCoord = -1)
	),

	EndCoord \= -1,
	(
		(
		getRequestedMove(StartCoord, EndCoord, SubCaptures, Capture), 
		move(GameOld, GameNew1, Capture));
		(
		write('Wrong coord, try again...'), nl, nl, GameNew1 = GameOld, Capture = Move)
	),
	multiCapture(GameNew1, GameNew, Turn, Capture, againstBot, 0)
.
multiCapture(GameOld, GameNew, Turn, Move, againstBot, 1) :-
	parseCapture(Move, _, StartCoord, SubCaptures),
	length(SubCaptures, Len),
	Len \= 0,

	(
		(Turn \= white, inputNextCapture(GameOld, EndCoord));
		(Turn = white, decide_multi_capture(GameOld, Turn, Move, EndCoord))
	),

	EndCoord \= -1,
	(
		(
		getRequestedMove(StartCoord, EndCoord, SubCaptures, Capture), 
		move(GameOld, GameNew1, Capture));
		(
		write('Wrong coord, try again...'), nl, nl, GameNew1 = GameOld, Capture = Move)
	),
	multiCapture(GameNew1, GameNew, Turn, Capture, againstBot, 1)
.
multiCapture(_GameOld, _GameNew, _Turn, _Move, botAgainstBot, 0) :-
	fail
.
multiCapture(GameOld, GameNew, Turn, Move, botAgainstBot, 1) :-
	parseCapture(Move, _, StartCoord, SubCaptures),
	length(SubCaptures, Len),
	Len \= 0,

	decide_multi_capture(GameOld, Turn, Move, EndCoord),

	EndCoord \= -1,
	(
		(
		getRequestedMove(StartCoord, EndCoord, SubCaptures, Capture), 
		move(GameOld, GameNew1, Capture));
		(
		write('Wrong coord, try again...'), nl, nl, GameNew1 = GameOld, Capture = Move)
	),
	multiCapture(GameNew1, GameNew, Turn, Capture, botAgainstBot, 1)
.
multiCapture(Game, Game, _, _, _, _).

% Rodada do jogo
gameTurn(GameStateOld, GameStateNew, noBot, Difficulty) :-
	getPlayerTurn(GameStateOld, Turn),
	requestMove(GameStateOld, Turn, Move),
	move(GameStateOld, GameStateNew1, Move),

	[MoveType|_] = Move,
	((MoveType = capture, changeSkull(GameStateNew1, GameStateNew2); (GameStateNew2 = GameStateNew1))),
	multiCapture(GameStateNew2, GameStateNew3, Turn, Move, noBot, Difficulty),
	(
		(game_over(GameStateNew3, _), GameStateNew = GameStateNew3)
		;
		(		
			gsVerificationsAndTurn(GameStateNew3, Turn, GameStateNew4, noBot, Difficulty),
			changeTurn(GameStateNew4, GameStateNew)
		)
	)
.
gameTurn(GameStateOld, GameStateNew, againstBot, Difficulty) :-
	getPlayerTurn(GameStateOld, Turn),
	( 	

		(Turn \= white, requestMove(GameStateOld, Turn, Move));
		(Turn = white, choose_move(GameStateOld, Turn, Difficulty, Move))
	),

	move(GameStateOld, GameStateNew1, Move),

	[MoveType|_] = Move,
	((MoveType = capture, changeSkull(GameStateNew1, GameStateNew2); (GameStateNew2 = GameStateNew1))),
	multiCapture(GameStateNew2, GameStateNew3, Turn, Move, againstBot, Difficulty),
	(
		(game_over(GameStateNew3, _), GameStateNew = GameStateNew3)
		;
		(		
			gsVerificationsAndTurn(GameStateNew3, Turn, GameStateNew4, againstBot, Difficulty),
			changeTurn(GameStateNew4, GameStateNew)
		)
	)
.
gameTurn(GameStateOld, GameStateNew, botAgainstBot, Difficulty) :-
	getPlayerTurn(GameStateOld, Turn),
	choose_move(GameStateOld, Turn, Difficulty, Move),
	move(GameStateOld, GameStateNew1, Move),
	[MoveType|_] = Move,
	((MoveType = capture, changeSkull(GameStateNew1, GameStateNew2); (GameStateNew2 = GameStateNew1))),
	multiCapture(GameStateNew2, GameStateNew3, Turn, Move, botAgainstBot, Difficulty),
	(
		(game_over(GameStateNew3, _), GameStateNew = GameStateNew3)
		;
		(		
			gsVerificationsAndTurn(GameStateNew3, Turn, GameStateNew4, botAgainstBot, Difficulty),
			changeTurn(GameStateNew4, GameStateNew)
		)
	)
.

% Loop do jogo 
gameLoop(GameOld, Mode, BetweenTurns, Difficulty) :-
	(BetweenTurns \= 0, display_game(GameOld); true),
    gameTurn(GameOld, GameNew, Mode, Difficulty),
    (
        (game_over(GameNew, Winner), (BetweenTurns = 0, display_game(GameOld); true), winnerToWords(Winner, WinnerStr), format('The Winner is: ~w!~n', [WinnerStr]), sleep(10));
        (((Mode = botAgainstBot, sleep(BetweenTurns)); (true)), cls,
			gameLoop(GameNew, Mode, BetweenTurns, Difficulty))
    )
.
