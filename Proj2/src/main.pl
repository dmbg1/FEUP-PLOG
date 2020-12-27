%Na geração de soluções:
%Domínio das soluções = nº de linhas (ou colunas) * 2 -- all_distinct

%Principais predicados a implementar: 
%generateClues
%getSolution
% RowValue Solution List format -> [1,3,2,7,5,6,4,8]
% ColValue Solution List format -> [1,4,2,5,3,8,7,6]

:-use_module(library(clpfd)).

example([[3, 11, 23, 41],
         [2, 13, 29, 31]]).

main :-
    example([ColClues, RowClues]),
    getRowValues(RowClues, RowValues),
    getColValues(ColClues, ColValues),
    write(RowValues), nl,
    write(ColValues), nl
.

getRowValues(RowClues, Solution) :-
    length(RowClues, GridSize),
    MaxValue is GridSize * 2,
    length(Solution, MaxValue),
    domain(Solution, 1, MaxValue),
    all_distinct(Solution),
    restrictions(Solution, RowClues),
    labeling([], Solution)
.
rowRestrictions([], []).
rowRestrictions([X1, X2|Rest], [ClueRow|RestClues]) :-
    (X1 * X2 #= ClueRow + 1 ; X1 * X2 #= ClueRow - 1),
    restrictions(Rest, RestClues)
.

getColValues(ColClues, Solution) :-
    length(ColClues, GridSize),
    MaxValue is GridSize * 2,
    length(Solution, MaxValue),
    domain(Solution, 1, MaxValue),
    all_distinct(Solution),
    restrictions(Solution, ColClues),
    labeling([], Solution)
.
colRestrictions([], []).
colRestrictions([X1, X2|Rest], [ClueCol|RestClues]) :-
    (X1 * X2 #= ClueCol + 1 ; X1 * X2 #= ClueCol - 1),
    restrictions(Rest, RestClues)
.

