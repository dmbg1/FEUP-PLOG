% choose_move(Game, Player, Level, Move) 

movesWithValue(_, _, [], []).
movesWithValue(Game, Player, [Move | Rest], [Value-Move | RestValues]) :-
    move(Game, GameWithMove, Move),
    getGSPlayer(Game, GSPlayer),
    ((GSPlayer = Player,
    value(GameWithMove, GSPlayer, Value));
    (value(GameWithMove, Player, Value))), !,
    movesWithValue(Game, Player, Rest, RestValues)
.

choose_move(Game, Player, 0, Move) :-
    valid_moves(Game, Player, MovesList),
    length(MovesList, Len),
    random(0, Len, I),
    nth0(I, MovesList, Move)
.
choose_move(Game, green, 1, Move) :-
    valid_moves(Game, green, MovesList),
    movesWithValue(Game, green, MovesList, MovesValuesList),
    sort(MovesValuesList, SortedMoves),
    reverse(SortedMoves, SortedMovesValuesList),
    nth0(0, SortedMovesValuesList, Move1),
    ((0-_ = Move1, 
        Move=[]);
     (_-Move = Move1)), !
.
choose_move(Game, Player, 1, Move) :-
    valid_moves(Game, Player, MovesList),
    movesWithValue(Game, Player, MovesList, MovesValuesList),
    sort(MovesValuesList, SortedMoves),
    reverse(SortedMoves, SortedMovesValuesList),
    nth0(0, SortedMovesValuesList, Move1),
    _-Move = Move1
.

maxListSubCaptures(Game, Turn, SubCaptures, SubCapture, MaxValue) :- 
    member(SubCaptures, SubCapture), 
    GameCopy = Game,
    move(Game, GameWithMove, SubCapture),
    value(GameWithMove, Turn, MaxValue),
    \+(member(E, SubCaptures), move(GameCopy, GameCopyWithMove, E), value(GameCopyWithMove, Turn, Value), Value > MaxValue).
maxListSubCaptures(_, _, _, _, 0).

decide_multi_capture(Game, Player, Move, EndCoord) :-
    parseCapture(Move, _, _, SubCaptures),
    maxListSubCaptures(Game, Player, SubCaptures, SelectedSubCapture, Value),
    format('VALUE: ~w  -  Selected Captures: ~w~n', [Value, Move]),
    ((Value = 0, 
        EndCoord = -1);
    (Value > 0,
        [capture, _, EndCoord, _SubSubCapture] = SelectedSubCapture))
.