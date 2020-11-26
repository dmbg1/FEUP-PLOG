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
movesWithValue(Game, Player, [Move | Rest], [MovesValue | RestValues]) :-
    move(Game, GameWithMove, Move),
    value(GameWithMove, Player, Value),
    MovesValue = (Move, Value),
    movesWithValue(Game, Player, Rest, RestValues)
.

choose_move(Game, Player, 1, Move) :-
    valid_moves(Game, Player, MovesList),
    movesWithValue(Game, Player, MovesList, MovesValuesList),
    sort(2, $>=, MovesValuesList, SortedMovesValuesList),
    nth0(0, SortedMovesValuesList, Move)
.
