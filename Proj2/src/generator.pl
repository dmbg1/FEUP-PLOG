generateBoard(BoardSize, Board, firstBoard) :-
    length(Board, 2),
    length(RowClues, BoardSize),
    length(ColClues, BoardSize),
    MaxClue is (BoardSize * 2 - 1) * (BoardSize * 2),
    domain(RowClues, 2, MaxClue),
    domain(ColClues, 2, MaxClue),
    append([RowClues, ColClues], Clues),
    all_distinct(Clues),
    solveBoardNoLabeling([RowClues, ColClues], [RowValues, ColValues]), !,
    append([Clues, RowValues, ColValues], Vars),
    labeling([ffc], Vars), !,
    [RowClues, ColClues] = Board
.

generateBoard(BoardSize, Board, randomLabeling) :-
    length(Board, 2),
    length(RowClues, BoardSize),
    length(ColClues, BoardSize),
    MaxClue is (BoardSize * 2 - 1) * (BoardSize * 2),
    domain(RowClues, 2, MaxClue),
    domain(ColClues, 2, MaxClue),
    append([RowClues, ColClues], Clues),
    all_distinct(Clues),
    
    solveBoard([RowClues, ColClues], _Solution), !,
    labeling([value(mySelValores)], Clues), !,

    [RowClues, ColClues] = Board
.

generateBoard(BoardSize, Board, randomNoLabeling) :-
    length(Board, 2),
    length(RowClues, BoardSize),
    length(ColClues, BoardSize),
    MaxClue is (BoardSize * 2 - 1) * (BoardSize * 2),
    domain(RowClues, 2, MaxClue),
    domain(ColClues, 2, MaxClue),
    append([RowClues, ColClues], Clues),
    all_distinct(Clues),
    
    solveBoardNoLabeling([RowClues, ColClues], [RowValues, ColValues]), !,
    append([Clues, RowValues, ColValues], Vars),
    labeling([value(mySelValores)], Vars), 

    [RowClues, ColClues] = Board
.

mySelValores(Var, _Rest, BB, BB1) :-
    fd_set(Var, Set),
    select_best_value(Set, Value),
    (   
        first_bound(BB, BB1), Var #= Value
        ;   
        later_bound(BB, BB1), Var #\= Value
    ).

select_best_value(Set, BestValue):-
    fdset_to_list(Set, Lista),
    length(Lista, Len),
    random(0, Len, RandomIndex),
    nth0(RandomIndex, Lista, BestValue).
