example([[1,0,3,0],[0,2,0,7],[0,5,0,6],[4,0,8,0]]).

translate(0, ' ').
translate(N, N).

test :- 
    example(M),
    getMatrixRowClues(M, 1, 1, Clues),
    getMatrixColClues(M,1, 1, CClues),
    write(Clues),nl,
    write(CClues)
.

getMatrixRowClues([], _Index, Accum, [Accum|_RestClues]).
getMatrixRowClues([Row|RestRows], Index, Accum, [Clue|RestClues]) :-
    length(Row, Size),
    Index =< Size,
    nth1(Index, Row, Value),
    ((Value = 0,
     getMatrixRowClues(RestRows, Index, Accum, [Clue|_]));
     (Value \= 0, 
     Accum1 is Accum * Value, 
     getMatrixRowClues(RestRows, Index, Accum1, [Clue|_]))),
     length(RestRows, RowsLeft),
     ((Size is RowsLeft + 1,
       Index1 is Index + 1,
       getMatrixRowClues([Row|RestRows], Index1, 1, RestClues)
       );
       true)
.
getMatrixRowClues(_, _, _, []).

getMatrixColClues([], _Index, _Accum, []).
getMatrixColClues([Row|RestRows], Index, Accum, [Clue|RestClues]) :-
    length(Row, Size),
    Index =< Size,
    nth1(Index, Row, Value),
    Index1 is Index + 1,
    ((Value = 0,
     getMatrixColClues([Row|RestRows], Index1, Accum, [Clue|_]));
     (Value \= 0,
     Accum1 is Accum * Value, 
     getMatrixColClues([Row|RestRows], Index1, Accum1, [Clue|_]))),
    getMatrixColClues(RestRows, 1, 1, RestClues)
.
getMatrixColClues(_, _Index, Accum, [Accum|_RestClues]).

print_solution([], Size) :- print_row_delim(Size).
print_solution([Row|RestRows], Size, [RowClues, ColClues]) :-
    print_row_delim(Size),
    print_between_row_delim_and_value(Size),
    print_row(Row, 0),
    print_between_row_delim_and_value(Size),
    print_matrix(RestRows, Size)
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

print_row([], _) :- format("|~n",[]).
print_row([H|T], ColNum) :- 
    translate(H, V),
    format("|~t~w~*|   ",[V, 5 + ColNum * 8]),
    ColNum1 is ColNum + 1,
    print_row(T, ColNum1)
.
