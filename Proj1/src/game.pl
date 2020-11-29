% Dá início ao jogo recebendo como argumento o modo de jogo (bot vs bot, player vs bot e player vs bot)
start_game(Mode) :-
	initial(Game),
	gameLoop(Game, Mode)
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


gsVerificationsAndTurn(GameStateOld, Turn, GameStateNew, Mode) :-
	getGSPlayer(GameStateOld, Gs),
	Gs = Turn,
	cls,
	display_game(GameStateOld),
	(
	(Mode = noBot,
	 	inputGreenSkullMove(Input),
		 write('Move Zombie'), nl,
		Input = y,
		requestMove(GameStateOld, green, Move));
	(Mode = againstBot,
		(Turn \= white, 
			inputGreenSkullMove(Input),
			write('Move Zombie'), nl,
			Input = y,
			requestMove(GameStateOld, green, Move));
		(Turn = white,
			choose_move(GameStateOld, green, Move),
			Move \= [])
	);
	(Mode = botAgainstBot,
		display_game(GameStateOld),
		choose_move(GameStateOld, green, Move),
		Move \= [])
	),

	[MoveType|_] = Move,
	move(GameStateOld, GameStateNew1, Move),
	multiCapture(GameStateNew1, GameStateNew2, Turn, Move, Mode),
	(
	(MoveType = capture, changeSkull(GameStateNew2, GameStateNew));
	(MoveType = move, GameStateNew = GameStateNew1)
	)
.
gsVerificationsAndTurn(GameStateOld, _, GameStateNew, _) :- GameStateOld = GameStateNew.

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
		move(GameOld, GameNew1, Capture));
		(
		write('Wrong coord, try again...'), nl, nl, GameNew1 = GameOld, Capture = Move)
	),
	multiCapture(GameNew1, GameNew, Turn, Capture, Mode)
.
multiCapture(Game, Game, _, _, _).

% Rodada do jogo
gameTurn(GameStateOld, GameStateNew, Mode) :-
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
	gsVerificationsAndTurn(GameStateNew2, Turn, GameStateNew3, Mode),
	getGSPlayer(GameStateNew3, GS),
	(
	(GS = Turn, MoveType = capture, 
		changeSkull(GameStateNew3, GameStateNew4),
		changeTurn(GameStateNew4, GameStateNew));
	(GS \= Turn,
		changeTurn(GameStateNew3, GameStateNew));
	(GS=Turn,
		changeTurn(GameStateNew3, GameStateNew))
	)
.

gameLoop(GameOld, Mode) :-
	cls,
    display_game(GameOld),
    gameTurn(GameOld, GameNew, Mode),
    (
        (game_over(GameNew, Winner), 
         gameLoop(GameNew, Mode));
        (winnerToWords(Winner, WinnerStr), format('The Winner is: ~w!~n', [WinnerStr]), sleep(5))   
    )
.
