:- use_module(library(lists)).
:- use_module(library(clpfd)).
:- use_module(library(random)).
:- use_module(library(clpb)).
:- use_module(library(file_systems)).
:- consult('display.pl').
:- consult('solver.pl').
:- consult('auxiliar.pl').
:- consult('generator.pl').

example([[2, 13, 29, 31],[3, 11, 23, 41]]).
example1([[6,19,7],[2,9,25]]).

main :-
    example(Board),
    solveBoard(Board, Solution),
    write('Found a Solution with the following stats:'), nl,
    fd_statistics, nl,
    Board = [RowClues, _ColClues],
    length(RowClues, Size),
    getSolutionMatrix(Solution, SolutionMatrix, Size),
    [RowValues, ColValues] = Solution,
    getSolutionClues(RowValues, RClues, ColValues, CClues),
    [RClues, CClues] = Clues,
    print_problem_matrix(SolutionMatrix, Size, Clues)
.