% Dá início ao jogo recebendo como argumento o modo de jogo (bot vs bot, player vs bot e player vs bot)
start_game(Mode, BetweenTurns) :-
	initial(Game),
	gameLoop(Game, Mode, BetweenTurns)
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

gsVerificationsAndTurn(GameStateOld, Turn, GameStateNew, noBot) :-
	getGSPlayer(GameStateOld, Gs),
	Gs = Turn,
	cls,
	display_game(GameStateOld),
	inputGreenSkullMove(Input),
	Input = y,
	write('Move Zombie'), nl,
	requestMove(GameStateOld, green, Move),

	move(GameStateOld, GameStateNew1, Move),
	multiCapture(GameStateNew1, GameStateNew, Turn, Move, noBot)
.
gsVerificationsAndTurn(GameStateOld, Turn, GameStateNew, againstBot) :-
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
			choose_move(GameStateOld, green, 1, Move),
			Move \= [])
	),

	move(GameStateOld, GameStateNew1, Move),
	multiCapture(GameStateNew1, GameStateNew, Turn, Move, againstBot)
.
gsVerificationsAndTurn(GameStateOld, Turn, GameStateNew, botAgainstBot) :-
	getGSPlayer(GameStateOld, Gs),
	Gs = Turn,
	choose_move(GameStateOld, green, 1, Move),
	Move \= [],

	move(GameStateOld, GameStateNew1, Move),
	multiCapture(GameStateNew1, GameStateNew, Turn, Move, botAgainstBot)
.
gsVerificationsAndTurn(GameStateOld, _, GameStateOld, _).

multiCapture(GameOld, GameNew, Turn, Move, noBot) :-
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
	multiCapture(GameNew1, GameNew, Turn, Capture, noBot)
.
multiCapture(GameOld, GameNew, Turn, Move, againstBot) :-
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
	multiCapture(GameNew1, GameNew, Turn, Capture, againstBot)
.
multiCapture(GameOld, GameNew, Turn, Move, botAgainstBot) :-
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
	multiCapture(GameNew1, GameNew, Turn, Capture, botAgainstBot)
.
multiCapture(Game, Game, _, _, _).

% Rodada do jogo
gameTurn(GameStateOld, GameStateNew, noBot) :-
	getPlayerTurn(GameStateOld, Turn),
	requestMove(GameStateOld, Turn, Move),
	move(GameStateOld, GameStateNew1, Move),

	multiCapture(GameStateNew1, GameStateNew2, Turn, Move, noBot),
	(
		(game_over(GameStateNew2, _), GameStateNew = GameStateNew2)
		;
		(		
			gsVerificationsAndTurn(GameStateNew2, Turn, GameStateNew3, noBot),
			changeTurn(GameStateNew3, GameStateNew)
		)
	)
.
gameTurn(GameStateOld, GameStateNew, againstBot) :-
	getPlayerTurn(GameStateOld, Turn),
	( 	
		(Turn \= white, requestMove(GameStateOld, Turn, Move));
		(Turn = white, choose_move(GameStateOld, Turn, 1, Move))
	),

	move(GameStateOld, GameStateNew1, Move),

	multiCapture(GameStateNew1, GameStateNew2, Turn, Move, againstBot),
	(
		(game_over(GameStateNew2, _), GameStateNew = GameStateNew2)
		;
		(		
			gsVerificationsAndTurn(GameStateNew2, Turn, GameStateNew3, againstBot),
			changeTurn(GameStateNew3, GameStateNew)
		)
	)
.
gameTurn(GameStateOld, GameStateNew, botAgainstBot) :-
	getPlayerTurn(GameStateOld, Turn),
	choose_move(GameStateOld, Turn, 1, Move),
	move(GameStateOld, GameStateNew1, Move),

	multiCapture(GameStateNew1, GameStateNew2, Turn, Move, botAgainstBot),
	(
		(game_over(GameStateNew2, _), GameStateNew = GameStateNew2)
		;
		(		
			gsVerificationsAndTurn(GameStateNew2, Turn, GameStateNew3, botAgainstBot),
			changeTurn(GameStateNew3, GameStateNew)
		)
	)
.

% Loop do jogo
gameLoop(GameOld, Mode, BetweenTurns) :-
    display_game(GameOld),
    gameTurn(GameOld, GameNew, Mode),
    (
        (game_over(GameNew, Winner), winnerToWords(Winner, WinnerStr), format('The Winner is: ~w!~n', [WinnerStr]), sleep(5));
        (((Mode = botAgainstBot, sleep(BetweenTurns)); (true)), cls,
			gameLoop(GameNew, Mode))
    )
.
