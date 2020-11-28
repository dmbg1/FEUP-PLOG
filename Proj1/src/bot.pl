:- use_module(library(random)).
:- consult('board.pl').
:- consult('game.pl').

% choose_move(Game, Player, Level, Move) 
choose_move(Game, Player, 0, Move) :-
    valid_moves(Game, Player, MovesList),
    length(MovesList, Len),
    random_between(0, Len, I),
    nth0(I, MovesList, Move)
.

movesWithValue([], []).
movesWithValue(Game, Player, [Move | Rest], [Value-Move | RestValues]) :-
    move(Game, GameWithMove, Move),
    value(GameWithMove, Player, Value),
    movesWithValue(Game, Player, Rest, RestValues)
.

choose_move(Game, Player, 1, Move) :-
    valid_moves(Game, Player, MovesList),
    movesWithValue(Game, Player, MovesList, MovesValuesList),
    sort(MovesValuesList, SortedMoves),
    reverse(SortedMoves, SortedMovesValuesList),
    nth0(0, SortedMovesValuesList, Move)
.
