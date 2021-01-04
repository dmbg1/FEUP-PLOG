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
example8x8([[3, 29, 73, 13, 43, 109, 157, 241],[12, 145, 81, 43, 57, 46, 27, 61]]).
example10x10([[7, 29, 64, 33, 183, 271, 109, 299, 11, 341], [7, 79, 49, 154, 23, 209, 78, 17, 227, 319]]).

% Predicado utilizado para a resolução de uma das boards example
solveExampleBoard(Board) :-
    fd_statistics, cls,
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

% Resolve uma Board gerada
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

% Main Menu
main :-
    format('    ------------------~n    | WRONG PRODUCTS |~n    ------------------~n', []),
    format('       Choose an option:~n', []),
    format('1 - Solve Example 2x2 Board~n', []),
    format('2 - Solve Example 3x3 Board~n', []),
    format('3 - Solve Example 4x4 Board~n', []),
    format('4 - Solve Example 6x6 Board~n', []),
    format('5 - Solve Example 8x8 Board~n', []),
    format('6 - Solve Example 10x10 Board~n', []),
    format('7 - Generate and Solve a board~n', []),
    format('8 - Generate and Solve a random board with 2 labelings~n', []),
    format('9 - Generate and Solve a random board with 1 labeling~n', []),
    format('0 - Exit~n', []),
    read(Input),
    manageInput(Input)
.

manageInput(0).

manageInput(1) :- 
    cls,
    nl, 
    example2x2(Board),
    solveExampleBoard(Board), !,
    format('Press enter to continue...',[]),
    get_char(_),
    get_char(_),
    cls,!,
	main
.

manageInput(2) :- 
    cls,
    nl, 
    example3x3(Board),
    solveExampleBoard(Board), !,
    format('Press enter to continue...',[]),
    get_char(_),
    get_char(_),
    cls,!,
	main
.

manageInput(3) :- 
    cls,
    nl, 
    example4x4(Board),
    solveExampleBoard(Board), !,
    format('Press enter to continue...',[]),
    get_char(_),
    get_char(_),
    cls,!,
	main
.

manageInput(4) :- 
    cls,
    nl, 
    example6x6(Board),
    solveExampleBoard(Board), !,
    format('Press enter to continue...',[]),
    get_char(_),
    get_char(_),
    cls,!,
	main
.

manageInput(5) :- 
    cls,
    nl, 
    example8x8(Board),
    solveExampleBoard(Board), !,
    format('Press enter to continue...',[]),
    get_char(_),
    get_char(_),
    cls,!,
	main
.

manageInput(6) :- 
    cls,
    nl, 
    example10x10(Board),
    solveExampleBoard(Board), !,
    format('Press enter to continue...',[]),
    get_char(_),
    get_char(_),
    cls,!,
	main
.

manageInput(7) :-
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
            manageInput(7), !
        )
    )
.

manageInput(8) :-
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
            manageInput(8), !
        )
    )
.

manageInput(9) :-
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
            manageInput(9), !
        )
    )
.

manageInput(_):- main, !.
