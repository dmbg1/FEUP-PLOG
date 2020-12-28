%Na geração de soluções:
%Domínio das soluções = nº de linhas (ou colunas) * 2 -- all_distinct

%Principais predicados a implementar: 
%generateClues
%getSolution
% RowValue Solution List format -> [1,3,2,7,5,6,4,8]
% ColValue Solution List format -> [1,4,2,5,3,8,7,6]

:- use_module(library(lists)).
:- use_module(library(clpfd)).
:- use_module(library(random)).
:- use_module(library(clpb)).
:- use_module(library(file_systems)).

example([[3, 11, 23, 41],
         [2, 13, 29, 31]]).


main :-
    example(Board),
    solveBoard(Board, [RowValues, ColValues]),
    write(RowValues), nl,
    write(ColValues), nl
.
generateBoard(BoardSize) :-
    length(Board, 2),
    length(RowClues, BoardSize),
    length(ColClues, BoardSize),
    MaxClue is (BoardSize * 2 - 1) * (BoardSize * 2),
    domain(RowClues, 2, MaxClue),
    domain(ColClues, 2, MaxClue),
    append(RowClues, ColClues, Clues),
    all_distinct(Clues),
    solveBoard([RowClues, ColClues], _Solution),
    labeling([], RowClues),
    labeling([], ColClues),
    [RowClues, ColClues] = Board,
    write(Board), nl
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
    write(Len), nl,
    nth0(RandomIndex, Lista, BestValue).



solveBoard([ColClues, RowClues],[RowValues, ColValues]) :-
    getValues(RowClues, RowValues),
    getValues(ColClues, ColValues)
.

getValues(Clues, Solution) :-
    length(Clues, GridSize),
    MaxValue is GridSize * 2,
    length(Solution, MaxValue),
    domain(Solution, 1, MaxValue),
    all_distinct(Solution),
    restrictions(Solution, Clues),
    labeling([], Solution)
.
restrictions([], []).
restrictions([X1, X2|Rest], [Clue|RestClues]) :-
    (X1 * X2 #= Clue + 1 ; X1 * X2 #= Clue - 1),
    restrictions(Rest, RestClues)
.


