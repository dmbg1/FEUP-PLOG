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

solveExampleBoard :-
    example(Board),
    [RowClues, _ColClues] = Board,
    length(RowClues, Size),
    getEmptyMatrix(BeforeSolution, Size),
    print_problem_matrix(BeforeSolution, Size, Board),
    solveBoard(Board, Solution),
    write('Found a solution with the following stats:'), nl,
    fd_statistics, nl,
    getSolutionMatrix(Solution, SolutionMatrix, Size),
    [RowValues, ColValues] = Solution,
    getSolutionClues(RowValues, RClues, ColValues, CClues),
    [RClues, CClues] = Clues,
    print_problem_matrix(SolutionMatrix, Size, Clues)
.

solveGeneratedBoard(Size) :-
    generateBoard(Size, Board),
    [RowClues, _ColClues] = Board,
    length(RowClues, Size),
    getEmptyMatrix(BeforeSolution, Size),
    print_problem_matrix(BeforeSolution, Size, Board),
    solveBoard(Board, Solution),
    write('Found a solution with the following stats:'), nl,
    fd_statistics, nl,
    getSolutionMatrix(Solution, SolutionMatrix, Size),
    [RowValues, ColValues] = Solution,
    getSolutionClues(RowValues, RClues, ColValues, CClues),
    [RClues, CClues] = Clues,
    print_problem_matrix(SolutionMatrix, Size, Clues)
.