% choose_move(Game, Player, Level, Move) 
choose_move(Game, Player, 0, Move) :-
    valid_moves(Game, Player, MovesList),
    length(MovesList, Len),
    random(0, Len, I),
    nth0(I, MovesList, Move)
.

movesWithValue(_, _, [], []).
movesWithValue(Game, Player, [Move | Rest], [Value-Move | RestValues]) :-
    move(Game, GameWithMove, Move),
    getGSPlayer(Game, GSPlayer),
    ((GSPlayer = Player,
    value(GameWithMove, GSPlayer, Value));
    (value(GameWithMove, Player, Value))), !,
    movesWithValue(Game, Player, Rest, RestValues)
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

decide_multi_capture(Game, Player, Move, EndCoord) :-
    move(Game, GameWithMove, Move),
    value(GameWithMove, Player, Value),
    ((Value=0, 
        EndCoord = -1);
    (Value > 0,
        Move = [capture, _, EndCoord]))
.