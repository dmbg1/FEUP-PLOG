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
	((ValidMove = [_, StartCoord, EndCoord|_], Move = ValidMove); 
	getRequestedMove(StartCoord, EndCoord, RestValidMoves, Move))
.
getRequestedMove(_StartCoord, _EndCoord, [], _Move) :- fail.

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
	move(GameStateOld, GameStateNew, Move)
.
gsVerificationsAndTurn(GameStateOld, _, GameStateNew) :- GameStateOld = GameStateNew.

gameTurn(GameStateOld, GameStateNew) :- % Talvez precise de algumas mudanças
	getPlayerTurn(GameStateOld, Turn),
	requestMove(GameStateOld, Turn, Move),
	move(GameStateOld, GameStateNew1, Move),
	gsVerificationsAndTurn(GameStateNew1, Turn, GameStateNew2),
	changeTurn(GameStateNew2, GameStateNew)
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