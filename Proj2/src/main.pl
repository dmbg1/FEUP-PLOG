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

    statistics(runtime, [StartSolveTime | _]),
    solveBoard(Board, Solution),
    statistics(runtime, [EndSolveTime | _]),
    SolveTime is EndSolveTime - StartSolveTime,
    
    write('Found a solution with the following stats:'), nl,
    fd_statistics, 
    format('Solving CPU Time: ~w ms~n~n', [SolveTime]),
    
    getSolutionMatrix(Solution, SolutionMatrix, Size),
    [RowValues, ColValues] = Solution,
    getSolutionClues(RowValues, RClues, ColValues, CClues),
    [RClues, CClues] = Clues,
    print_problem_matrix(SolutionMatrix, Size, Clues)
.

solveGeneratedBoard(Size) :-
    statistics(runtime, [StartGenerateTime | _]),
    generateBoard(Size, Board),
    statistics(runtime, [EndGenerateTime | _]),
    GenerateTime is EndGenerateTime - StartGenerateTime,

    [RowClues, _ColClues] = Board,
    length(RowClues, Size),
    getEmptyMatrix(BeforeSolution, Size),
    print_problem_matrix(BeforeSolution, Size, Board),

    statistics(runtime, [StartSolveTime | _]),
    solveBoard(Board, Solution),
    statistics(runtime, [EndSolveTime | _]),
    SolveTime is EndSolveTime - StartSolveTime,

    write('Found a solution with the following stats:'), nl,
    fd_statistics,
    format('Generating CPU Time: ~w ms~nSolving CPU Time: ~w ms~n~n', [GenerateTime, SolveTime]),

    getSolutionMatrix(Solution, SolutionMatrix, Size),
    [RowValues, ColValues] = Solution,
    getSolutionClues(RowValues, RClues, ColValues, CClues),
    [RClues, CClues] = Clues,
    print_problem_matrix(SolutionMatrix, Size, Clues)
.