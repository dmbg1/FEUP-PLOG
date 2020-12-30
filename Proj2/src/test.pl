:- use_module(library(lists)).

example([[1,0,3,0],[0,2,0,7],[0,5,0,6],[4,0,8,0]]).

translate(0, ' ').
translate(N, N).

test :- 
    example(M),
    getSolutionRowClues(M, 1, 1, RClues),
    getSolutionColClues(M, 1, 1, CClues),
    [RClues, CClues] = Clues,
    length(M, Size),
    print_problem_matrix(M, Size, Clues)
.

print_problem_matrix(M, Size, Clues) :-
    [RowClues, ColClues] = Clues,
    print_col_clues(ColClues, 0),
    print_matrix_rows(M, Size, RowClues)
.

print_col_clues([], _):- nl.
print_col_clues(ColClues, ColNum) :-
    [ColClue|RestColClues] = ColClues,
    format("~t~w~*|",[ColClue, 5 + ColNum * 8]),
    ColNum1 is ColNum + 1,
    print_col_clues(RestColClues, ColNum1)
.

print_matrix_rows([], Size, _) :- print_row_delim(Size).
print_matrix_rows(M, Size, RowClues) :-
    [RowClue|RestRowClues] = RowClues,
    [Row|RestRows] = M,
    print_row_delim(Size),
    print_between_row_delim_and_value(Size),
    print_row(Row, 0, RowClue),
    print_between_row_delim_and_value(Size),
    print_matrix_rows(RestRows, Size, RestRowClues)
.

print_row_delim(0) :- format("+~n",[]).
print_row_delim(Size) :-
    format("+-------",[]),
    Size1 is Size - 1,
    print_row_delim(Size1)
.
print_between_row_delim_and_value(0) :- format("|~n",[]).
print_between_row_delim_and_value(Size) :- 
    format("|       ",[]), 
    Size1 is Size - 1,
    print_between_row_delim_and_value(Size1)
.

print_row([], _, ColClue) :- format("| ~w~n",[ColClue]).
print_row([H|T], ColNum, ColClue) :- 
    translate(H, V),
    format("|~t~w~*|   ",[V, 5 + ColNum * 8]),
    ColNum1 is ColNum + 1,
    print_row(T, ColNum1, ColClue)
.

getSolutionColClues([], _Index, Accum, [Accum|_RestClues]).
getSolutionColClues([Row|RestRows], Index, Accum, [Clue|RestClues]) :-
    length(Row, Size),
    Index =< Size,
    nth1(Index, Row, Value),
    ((Value = 0,
     getSolutionColClues(RestRows, Index, Accum, [Clue|_]));
     (Value \= 0, 
     Accum1 is Accum * Value, 
     getSolutionColClues(RestRows, Index, Accum1, [Clue|_]))),
     length(RestRows, RowsLeft),
     ((Size is RowsLeft + 1,
       Index1 is Index + 1,
       getSolutionColClues([Row|RestRows], Index1, 1, RestClues)
       );
       true)
.
getSolutionColClues(_, _, _, []).

getSolutionRowClues([], _Index, _Accum, []).
getSolutionRowClues([Row|RestRows], Index, Accum, [Clue|RestClues]) :-
    length(Row, Size),
    Index =< Size,
    nth1(Index, Row, Value),
    Index1 is Index + 1,
    ((Value = 0,
     getSolutionRowClues([Row|RestRows], Index1, Accum, [Clue|_]));
     (Value \= 0,
     Accum1 is Accum * Value, 
     getSolutionRowClues([Row|RestRows], Index1, Accum1, [Clue|_]))),
    getSolutionRowClues(RestRows, 1, 1, RestClues)
.
getSolutionRowClues(_, _Index, Accum, [Accum|_RestClues]).