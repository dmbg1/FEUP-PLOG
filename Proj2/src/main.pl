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

example([[2, 13, 29, 31],[3, 11, 23, 41]]).


main :-
    example(Board),
    solveBoard(Board, SolutionMatrix),
    write(SolutionMatrix), nl
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


solveBoard([RowClues, ColClues], SolutionMatrix) :-
    getValues(RowClues, RowValues),
    getValues(ColClues, ColValues),
    length(RowClues, Size),
    getDisplayMatrix([RowValues, ColValues], SolutionMatrix, Size)
.

getDisplayMatrix(Solution, DisplayMatrix, Size) :-
    length(DisplayMatrix1, Size),
    maplist(same_length(DisplayMatrix1), DisplayMatrix1),
    emptyMatrix(DisplayMatrix1, Size),
    fillWithSolution(DisplayMatrix1, Solution, 1, DisplayMatrix)
.
fillWithSolution(Matrix, [RowValues, ColValues], SecondRowValueIndex, FinalMatrix) :- 
    length(RowValues, AmountOfValues),
    SecondRowValueIndex =< AmountOfValues - 1,
    X1 is SecondRowValueIndex - 1,
    nth0(Y1, RowValues, Value1),
    LineCoord is X1 // 2,
    nth0(X1, ColValues, Value1),
    ColCoord1 is Y1 // 2,
    setValue(Value1, Matrix, Matrix1, LineCoord, ColCoord1),
    nth0(SecondRowValueIndex, RowValues, Value2),
    nth0(Y2, ColValues, Value2),
    ColCoord2 is Y2 // 2,
    setValue(Value2, Matrix1, Matrix2, LineCoord, ColCoord2),    
    NextIndex is SecondRowValueIndex + 2,
    fillWithSolution(Matrix2, [RowValues, ColValues], NextIndex, FinalMatrix)
.
fillWithSolution(FinalMatrix, _, _, FinalMatrix).

emptyMatrix([], _).
emptyMatrix([Row|RestMatrix], Size) :-
    emptyRow(Row),
    emptyMatrix(RestMatrix, Size)
.
emptyRow([]).
emptyRow([0|RestRow]) :- emptyRow(RestRow).

setValue(Value, OldBoard, NewBoard, Y, X) :-
    nth0(Y, OldBoard, Row, TmpBoard),
	nth0(X, Row, _, TmpRow),
	nth0(X, NewRow, Value, TmpRow),
	nth0(Y, NewBoard, NewRow, TmpBoard)
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


