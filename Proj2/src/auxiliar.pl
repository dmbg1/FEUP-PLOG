translate(0, ' ').
translate(N, N).

% Obtem uma matriz (preenchida com zeros) de tamanho Size x Size
getEmptyMatrix(M, Size) :-
    length(M, Size),
    maplist(same_length(M), M),
    emptyMatrix(M, Size)
.
% Coloca zeros na matriz passado no primeiro argumento de tamanho Size x Size
emptyMatrix([], _).
emptyMatrix([Row|RestMatrix], Size) :-
    emptyRow(Row),
    emptyMatrix(RestMatrix, Size)
.
% Coloca zeros na lista passada no primeiro argumento
emptyRow([]).
emptyRow([0|RestRow]) :- emptyRow(RestRow).

% Coloca o valor referido no primeiro argumento nas coordenadas (Y, X) da Board referida
setValue(Value, OldBoard, NewBoard, Y, X) :-
    nth0(Y, OldBoard, Row, TmpBoard),
	nth0(X, Row, _, TmpRow),
	nth0(X, NewRow, Value, TmpRow),
	nth0(Y, NewBoard, NewRow, TmpBoard)
.

% Clear Screen
cls :- 
	write('\33\[2J')
.