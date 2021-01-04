:- use_module(library(lists)).
:- use_module(library(clpfd)).
:- use_module(library(random)).
:- use_module(library(clpb)).
:- use_module(library(file_systems)).
:- consult('display.pl').
:- consult('solver.pl').
:- consult('auxiliar.pl').
:- consult('generator.pl').

example2x2([[7, 2], [3, 11]]).
example3x3([[6,19,7],[2,9,25]]).
example4x4([[2, 13, 29, 31],[3, 11, 23, 41]]).
example6x6([[9, 4, 49, 76, 91, 49], [15, 11, 14, 73, 100, 33]]).
example8x8([[3, 29, 73, 13, 43, 109, 157, 241],[12, 145, 81, 43, 57,46]]).

solveExampleBoard :-
    fd_statistics, cls,
    example4x4(Board),
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

solveGeneratedBoard(Size, RandomOrFirstBoard) :-
    fd_statistics, cls,
    statistics(runtime, [StartGenerateTime | _]),
    generateBoard(Size, Board, RandomOrFirstBoard),
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

main :-
    format('    ------------------~n    | WRONG PRODUCTS |~n    ------------------~n', []),
    format('       Choose an option:~n', []),
    format('1 - Solve Example Board~n', []),
    format('2 - Generate and Solve a board~n', []),
    format('3 - Generate and Solve a random board with 2 labelings~n', []),
    format('4 - Generate and Solve a random board with 1 labeling~n', []),
    format('0 - Exit~n', []),
    read(Input),
    manageInput(Input)
.

manageInput(0).

manageInput(1) :- 
    cls,
    nl, 
    solveExampleBoard, !,
    format('Press enter to continue...',[]),
    get_char(_),
    get_char(_),
    
    cls,
	main
.
manageInput(2) :-
    format('Enter the size of side of the board: ',[]),
    read(Size),
    (
        (
            number(Size), !,
            cls, nl,
            solveGeneratedBoard(Size, firstBoard), !,
            format('Press enter to continue...',[]),
            get_char(_),
            get_char(_),
            cls,
            main
        )
        ;
        (
            manageInput(2), !
        )
    )
.

manageInput(3) :-
    format('Enter the size of side of the board: ',[]),
    read(Size),
    (
        (
            number(Size), !,
            cls, nl, 
            solveGeneratedBoard(Size, randomLabeling), !,
            format('Press enter to continue...',[]),
            get_char(_),
            get_char(_),
            cls,
            main
        )
        ;
        (
            manageInput(2), !
        )
    )
.

manageInput(4) :-
    format('Enter the size of side of the board: ',[]),
    read(Size),
    (
        (
            number(Size), !,
            cls, nl, 
            solveGeneratedBoard(Size, randomNoLabeling), !,
            format('Press enter to continue...',[]),
            get_char(_),
            get_char(_),
            cls,
            main
        )
        ;
        (
            manageInput(2), !
        )
    )
.

manageInput(_):- main, !.
