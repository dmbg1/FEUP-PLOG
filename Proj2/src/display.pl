% Faz o display da matriz de tamanho Size x Size e das respetivas Clues
print_problem_matrix(M, Size, Clues) :-
    [RowClues, ColClues] = Clues,
    print_col_clues(ColClues, 0),
    print_matrix_rows(M, Size, RowClues)
.

% Faz o display das clues de cada uma das colunas
print_col_clues([], _):- nl.
print_col_clues(ColClues, ColNum) :-
    [ColClue|RestColClues] = ColClues,
    format("~t~w~*|",[ColClue, 5 + ColNum * 8]),
    ColNum1 is ColNum + 1,
    print_col_clues(RestColClues, ColNum1)
.

% Faz o display das linhas da matriz passada como argumento
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

% Faz o display dos delimitadores
print_row_delim(0) :- format("+~n",[]).
print_row_delim(Size) :-
    format("+-------",[]),
    Size1 is Size - 1,
    print_row_delim(Size1)
.
% Faz o display da linha entre a delimitadora e a linha com os valores 
print_between_row_delim_and_value(0) :- format("|~n",[]).
print_between_row_delim_and_value(Size) :- 
    format("|       ",[]), 
    Size1 is Size - 1,
    print_between_row_delim_and_value(Size1)
.

% Faz o display de uma linha, com os respetivos valores e clues
print_row([], _, RowClue) :- format("| ~w~n",[RowClue]).
print_row([H|T], ColNum, RowClue) :- 
    translate(H, V),
    format("|~t~w~*|   ",[V, 5 + ColNum * 8]),
    ColNum1 is ColNum + 1,
    print_row(T, ColNum1, RowClue)
.
