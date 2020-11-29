% Verifica se um movimento é válido num tabuleiro vazio
freeValidMove(StartY, StartX, EndY, EndX) :-
	EndY - StartY =:= -1,
	EndX - StartX =:= -1
.
freeValidMove(StartY, StartX, EndY, EndX) :-
	EndY - StartY =:= -1,
	EndX - StartX =:= 0
.
freeValidMove(StartY, StartX, EndY, EndX) :-
	EndY - StartY =:= 0,
	EndX - StartX =:= -1
.
freeValidMove(StartY, StartX, EndY, EndX) :-
	EndY - StartY =:= 0,
	EndX - StartX =:= 1
.
freeValidMove(StartY, StartX, EndY, EndX) :-
	EndY - StartY =:= 1,
	EndX - StartX =:= 0
.
freeValidMove(StartY, StartX, EndY, EndX) :-
	EndY - StartY =:= 1,
	EndX - StartX =:= 1
.

% Verifica se uma captura é válida num tabuleiro vazio
capturedCoord(StartY, StartX, EndY, EndX, MidY, MidX) :-
	EndY - StartY =:= -2,
	EndX - StartX =:= -2,
	MidY is StartY - 1,
	MidX is StartX - 1
.
capturedCoord(StartY, StartX, EndY, EndX, MidY, MidX) :-
	EndY - StartY =:= -2,
	EndX - StartX =:= 0,
	MidY is StartY - 1,
	MidX is StartX
.
capturedCoord(StartY, StartX, EndY, EndX, MidY, MidX) :-
	EndY - StartY =:= 0,
	EndX - StartX =:= -2,
	MidY is StartY,
	MidX is StartX - 1
.
capturedCoord(StartY, StartX, EndY, EndX, MidY, MidX) :-
	EndY - StartY =:= 0,
	EndX - StartX =:= 2,
	MidY is StartY,
	MidX is StartX + 1
.
capturedCoord(StartY, StartX, EndY, EndX, MidY, MidX) :-
	EndY - StartY =:= 2,
	EndX - StartX =:= 0,
	MidY is StartY + 1,
	MidX is StartX
.
capturedCoord(StartY, StartX, EndY, EndX, MidY, MidX) :-
	EndY - StartY =:= 2,
	EndX - StartX =:= 2,
	MidY is StartY + 1,
	MidX is StartX + 1
.

% Verifica se uma captura é válida
captureValidMove(Game, StartCoord, EndCoord) :-
	parseCoord(StartCoord, StartY, StartX),
    parseCoord(EndCoord, EndY, EndX),
	capturedCoord(StartY, StartX, EndY, EndX, MidY, MidX),
	content(Game, MidY, MidX, Content),
	Content \= empty
.

% Verifica se o movimento da StartCoord para a EndCoord é válido
checkValidMoveAux(Game, PieceColor, StartCoord, EndCoord) :-
	parseCoord(StartCoord, StartY, StartX),
    parseCoord(EndCoord, EndY, EndX),
	checkValidCoord(StartY, StartX),
	checkValidCoord(EndY, EndX),
	content(Game, StartY, StartX, StartContent),
	StartContent = PieceColor,
	content(Game, EndY, EndX, EndContent),
	EndContent = empty
.

/*	checkValidMove(+Game, +Move, +PieceColor) :-


	Verifica se um Move é válido sendo este com ou sem captura
*/
checkValidMove(Game, Move, PieceColor) :-
	parseMove(Move, StartCoord, EndCoord),
	checkValidMoveAux(Game, PieceColor, StartCoord, EndCoord),
	parseCoord(StartCoord, StartY, StartX),
    parseCoord(EndCoord, EndY, EndX),
	freeValidMove(StartY, StartX, EndY, EndX)
.
checkValidMove(Game, Move, PieceColor) :-
	parseCapture(Move, StartCoord, EndCoord, _SubCaptures),
	checkValidMoveAux(Game, PieceColor, StartCoord, EndCoord),
	captureValidMove(Game, StartCoord, EndCoord)
.

getMove(StartCoord, EndCoord, ValidMove) :-
    append([], [move, StartCoord, EndCoord], ValidMove)
.
getMove(StartY, StartX, EndY, EndX, ValidMove) :-
	getCoord(StartY, StartX, StartCoord),
	getCoord(EndY, EndX, EndCoord),
	getMove(StartCoord, EndCoord, ValidMove)
.
parseMove(Move, StartCoord, EndCoord) :-
	nth0(0, Move, MoveType),
	MoveType = move,
	nth0(1, Move, StartCoord),
	nth0(2, Move, EndCoord)
.

getCapture(StartCoord, EndCoord, ValidMove) :-
    append([], [capture, StartCoord, EndCoord, []], ValidMove)
.
getCapture(StartY, StartX, EndY, EndX, ValidMove) :-
	getCoord(StartY, StartX, StartCoord),
	getCoord(EndY, EndX, EndCoord),
	getCapture(StartCoord, EndCoord, ValidMove)
.
parseCapture(Capture, StartCoord, EndCoord, SubCaptures) :-
	nth0(0, Capture, MoveType),
	MoveType = capture,
	nth0(1, Capture, StartCoord),
	nth0(2, Capture, EndCoord),
	nth0(3, Capture, SubCaptures)
.

/*  capturePiece(+GameOld, -GameNew, +StartY, +StartX, +EndY, +EndX)


	Movimenta a peça presente nas coordenadas (StartX, StartY) para as coordenadas (EndX, EndY) 
*/
movePiece(GameOld, GameNew, StartY, StartX, EndY, EndX) :-
	content(GameOld, StartY, StartX, Piece),
	setPiece(empty, GameOld, GameAux, StartY, StartX),
	setPiece(Piece, GameAux, GameAux1, EndY, EndX),

	getCoord(StartY, StartX, StartCoord),
	getCoord(EndY, EndX, EndCoord),

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

/*  capturePiece(+GameOld, -GameNew, +StartY, +StartX, +EndY, +EndX)


	Captura a peça entre as coordenadas (StartX, StartY) e as coordenadas (EndX, EndY) 
*/
capturePiece(GameOld, GameNew, StartY, StartX, EndY, EndX) :-
	movePiece(GameOld, GameNew1, StartY, StartX, EndY, EndX),
	
	capturedCoord(StartY, StartX, EndY, EndX, CapturedY, CapturedX),

	getCoord(CapturedY, CapturedX, CapturedCoord),

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

	setPiece(empty, GameAux1, GameNew, CapturedY, CapturedX)
.

/*	move(+GameOld, -GameNew, +Move)
	

	Processa o Move com o auxílio dos predicados movePiece e capturePiece e atualiza o estado de jogo de
 	acordo com esse processamento 
*/
move(GameOld, GameNew, Move) :-
	parseMove(Move, StartCoord, EndCoord),
	parseCoord(StartCoord, StartY, StartX),
	parseCoord(EndCoord, EndY, EndX),
	movePiece(GameOld, GameNew, StartY, StartX, EndY, EndX)
.
move(GameOld, GameNew, Move) :-
	parseCapture(Move, StartCoord, EndCoord, _SubCaptures),
	parseCoord(StartCoord, StartY, StartX),
	parseCoord(EndCoord, EndY, EndX),
	capturePiece(GameOld, GameNew1, StartY, StartX, EndY, EndX),
	changeSkull(GameNew1, GameNew)
.


% Aplica subcapturas 
applySubCaptures(GameOld, GameOld, _Player, []).
applySubCaptures(GameOld, GameNew, Player, [Capture | Rest]) :-
	move(GameOld, GameNew1, Capture),
	applySubCaptures(GameNew1, GameNew, Player, Rest)
.
% Aplica uma captura e respetivas subcapturas
applyCapture(GameOld, GameNew, Player, Capture) :-
	move(GameOld, GameNew1, Capture),
	parseCapture(Capture, _, _, SubCaptures),
	applySubCaptures(GameNew1, GameNew, Player, SubCaptures)
.

%
valid_captures(Game, Player, StartCoord, CapturesList) :-
    findall(Capture, (
		between(-2, 2, XDiff), (XDiff = -2 ; XDiff = 0 ; XDiff = 2),
		between(-2, 2, YDiff), (YDiff = -2 ; YDiff = 0 ; YDiff = 2),
		parseCoord(StartCoord, StartY, StartX),
		EndY is StartY + YDiff,
		EndX is StartX + XDiff,
		getCapture(StartY, StartX, EndY, EndX, Capture), 
		checkValidMove(Game, Capture, Player)
		), CapturesList)
.
valid_captures(_, _, _, []).

/*  valid_multiCaptures(+Game, +Player, +Captures, -CapturesWithSubCaptures)
	
	
	Obtém as sub-capturas de cada uma das capturas da lista do terceiro argumento. Predicado usado no valid_captures 
*/
valid_multiCaptures(_Game, _Player, [], []).
valid_multiCaptures(Game, Player, [Capture | Rest], [ [capture, StartCoord, EndCoord, SubCaptures] | RestNewCaptures]) :-
	applyCapture(Game, GameUpdated, Player, Capture),
	parseCapture(Capture, StartCoord, EndCoord, SubCaptures1),
	valid_captures(GameUpdated, Player, EndCoord, SubCaptures2), !,
	append(SubCaptures1, SubCaptures2, SubCaptures3),
	valid_multiCaptures(Game, Player, Rest, RestNewCaptures),
	valid_multiCaptures(GameUpdated, Player, SubCaptures3, SubCaptures)
.

valid_captures_aux(_Game, _Player, [], []).
valid_captures_aux(Game, Player, [Coord | Rest], Caps) :-
	valid_captures_aux(Game, Player, Rest, RestCaps),
	valid_captures(Game, Player, Coord, ThisCaps),!,
	append(ThisCaps, RestCaps, Caps)	
.
/*	valid_captures(+Game, +Player, -CapturesList)


	Predicado auxiliar ao valid_moves que obtém a lista de capturas possíveis
	e para cada captura as respetivas sub-capturas
*/
valid_captures(Game, Player, CapturesList) :-
    ((Player = purple, Game = [GS, _, _, _, _, _, Coords, _, _]);
    (Player = white, Game = [GS, _, _, _, _, _, _, Coords, _]);
    (Player = green, Game = [GS, _, _, _, _, _, _, _, Coords])),
    
	valid_captures_aux(Game, Player, Coords, SingleCaptures),
	valid_multiCaptures(Game, Player, SingleCaptures, CapturesList)
.	

/*	valid_moves(+Game, +Player, -MovesList)


	Obtém a lista de jogadas possíveis (capturas e jogadas sem capturas)
*/ 
valid_moves(Game, Player, MovesList) :-
    ((Player = purple, Game = [GS, _, _, _, _, _, Coords, _, _]);
    (Player = white, Game = [GS, _, _, _, _, _, _, Coords, _]);
    (Player = green, Game = [GS, _, _, _, _, _, _, _, Coords])),
    findall(Move, (
		member(StartCoord, Coords),
		between(-1, 1, XDiff),
		between(-1, 1, YDiff),
		parseCoord(StartCoord, StartY, StartX),
		EndY is StartY + YDiff,
		EndX is StartX + XDiff,
		getMove(StartY, StartX, EndY, EndX, Move), 
		checkValidMove(Game, Move, Player)
		), MovesList1),
	valid_captures(Game, Player, CapturesList),
	MovesList2 = [MovesList1, CapturesList],
	append(MovesList2, MovesList)
.