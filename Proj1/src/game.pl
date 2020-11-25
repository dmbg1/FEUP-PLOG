:- consult('board.pl').
:- consult('moves.pl').
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

requestNextCapture(Game, StartY, StartX, EndY, EndX, PieceColor) :- 
	inputNextCapture(EndY, EndX),
	((checkValidMove(Game, StartY, StartX, EndY, EndX, PieceColor, Capture),
	  Capture = true);
	  (write('That is not a capture! Try again'), nl, nl,
	   requestNextCapture(Game, StartY, StartX, EndY, EndX, PieceColor))
	)
.

userCapture(GameOld, GameOld, _, _, _,_, _, 0, _).
userCapture(GameOld, GameNew, StartY, StartX, EndY, EndX, PieceColor, NCap, CurrCap):-
	(
		(CurrCap = 1); 
		(CurrCap > 1, 
	 	 write('Capture '), write(CurrCap), write(':'), nl, 
	     ((requestNextCapture(GameOld, StartY, StartX, EndY, EndX, PieceColor));
	     (fail)))
  	),
	
	capturePiece(GameOld, GameNew1, StartY, StartX, EndY, EndX),

	NCap1 is NCap - 1,
	CurrCap1 is CurrCap + 1,

	userCapture(GameNew1, GameNew, EndY, EndX, _EY, _EX, PieceColor, NCap1, CurrCap1)
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
	write('That is an invalid play, try again...'), nl, nl,
	requestMove(Game, StartY, StartX, EndY, EndX, PieceColor, Capture, NCap)
.

userMove(GameStateOld, GameStateNew, PieceColor) :-
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
					userCapture(GameStateOld, GameStateNew1, StartY, StartX, EndY, EndX, PieceColor, NCap, 1),
				  	changeSkull(GameStateNew1, GameStateNew));
				 (	
					write('Restarting turn...'), nl, nl,
					userMove(GameStateOld, GameStateNew, PieceColor))
				 ));
			  	(PieceColor \= green, 
				((
					userCapture(GameStateOld, GameStateNew, StartY, StartX, EndY, EndX, PieceColor, NCap, 1));
				 (
					write('Restarting turn...'), nl, nl,
					userMove(GameStateOld, GameStateNew, PieceColor))
				 ))
			)
		)
		);
		(StartY = -1, GameStateNew = GameStateOld) % Player doesn't want to move green piece
		)
.


gameTurn(GameStateOld, GameStateNew) :-
	getPlayerTurn(GameStateOld, Turn), 
	userMove(GameStateOld, GameStateNew1, Turn),
	getGSPlayer(GameStateNew1, Gs),
	(
		(	Gs = Turn,
		% display talvez
		userMove(GameStateNew1, GameStateNew2, green),
		changeTurn(GameStateNew2, GameStateNew)
		);
		( 	Gs \= Turn,
		changeTurn(GameStateNew1, GameStateNew)
		)
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

