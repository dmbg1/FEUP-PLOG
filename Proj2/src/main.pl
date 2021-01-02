:- use_module(library(lists)).
:- use_module(library(clpfd)).
:- use_module(library(random)).
:- use_module(library(clpb)).
:- use_module(library(file_systems)).
:- consult('display.pl').
:- consult('solver.pl').
:- consult('auxiliar.pl').

example([[2, 13, 29, 31],[3, 11, 23, 41]]).
example1([[6,19,7],[2,9,25]]).

main :-
    example(Board),
    solveBoard(Board, SolutionMatrix),
    getSolutionRowClues(SolutionMatrix, 1, 1, RClues),
    getSolutionColClues(SolutionMatrix, 1, 1, CClues),
    [RClues, CClues] = Clues,
    length(SolutionMatrix, Size),
    print_problem_matrix(SolutionMatrix, Size, Clues)
.

generateBoard(BoardSize) :-
    length(Board, 2),
    length(RowClues, BoardSize),
    length(ColClues, BoardSize),
    MaxClue is (BoardSize * 2 - 1) * (BoardSize * 2),
    domain(RowClues, 2, MaxClue),
    domain(ColClues, 2, MaxClue),
    append([RowClues, ColClues], Clues),
    all_distinct(Clues),
    solveBoard([RowClues, ColClues], _Solution),
    labeling([value(mySelValores)], Clues),
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
    nth0(RandomIndex, Lista, BestValue).

