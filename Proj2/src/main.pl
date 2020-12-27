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
    example(Board),
    solveBoard(Board, [RowValues, ColValues]),
    write(RowValues), nl,
    write(ColValues), nl
.
generateBoard(BoardSize) :-
    length(Board, 2),
        write(4),nl,

    [RowClues, ColClues] = Board,
        write(5),nl,

    length(RowClues, BoardSize),
        write(6),nl,

    length(ColClues, BoardSize),
        write(7),nl,

    MaxClue is BoardSize * 2 + 1,
        write(8),nl,

    domain(RowClues, 2, MaxClue),
        write(9),nl,

    domain(ColClues, 2, MaxClue),
        write(10),nl,

    append(RowClues, ColClues, Clues),
        write(11), nl,

    all_distinct(Clues),
        write(3),nl,
    labeling([], Clues),
    write(15), nl,
    findall(Clue,(
        member(Clue, Clues),
        solveBoard(Clues, Solution)
    ), Boards),
    write(Boards),
    write(1),nl,
    labeling([], Board), 
    write(2),nl,
    write(Board), nl,
    write(Solution), nl
.
solveBoard([ColClues, RowClues],[RowValues, ColValues]) :-
    write(RowClues),nl,
    getValues(RowClues, RowValues),
    write(12),nl,
    getValues(ColClues, ColValues),
    write(14), nl
.

getValues(Clues, Solution) :-
    length(Clues, GridSize),
    MaxValue is GridSize * 2,
    length(Solution, MaxValue),
    domain(Solution, 1, MaxValue),
    all_distinct(Solution),
    write(a), nl,
    restrictions(Solution, Clues),
    write(s), nl,
    labeling([], Solution)
.
restrictions([], []).
restrictions([X1, X2|Rest], [Clue|RestClues]) :-
    (X1 * X2 #= Clue + 1 ; X1 * X2 #= Clue - 1),
    restrictions(Rest, RestClues)
.


