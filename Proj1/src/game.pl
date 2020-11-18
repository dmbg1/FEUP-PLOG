
changeSkull(GameStateOld, GameStateNew) :-
	[Skull|Board] = GameStateOld,
	Skull == 'Purple',
	SkullNew = 'Green',
	GameStateNew = [SkullNew|Board]
.

changeSkull(GameStateOld, GameStateNew) :-
	[Skull|Board] = GameStateOld,
	Skull == 'Green',
	SkullNew = 'Purple',
	GameStateNew = [SkullNew|Board]
.

changeTurn(GameStateOld, GameStateNew) :-
	[Gs, Turn|Board] = GameStateOld,
	Turn == 'Purple',
	NewTurn = 'Green',
	GameStateNew =[Gs, NewTurn|Board]
.

changeTurn(GameStateOld, GameStateNew) :-
	[Gs, Turn|Board] = GameStateOld,
	Turn == 'Green',
	NewTurn = 'Purple',
	GameStateNew =[Gs, NewTurn|Board]
.