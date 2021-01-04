translate(0, ' ').
translate(N, N).

getEmptyMatrix(M, Size) :-
    length(M, Size),
    maplist(same_length(M), M),
    emptyMatrix(M, Size)
.
emptyMatrix([], _).
emptyMatrix([Row|RestMatrix], Size) :-
    emptyRow(Row),
    emptyMatrix(RestMatrix, Size)
.
emptyRow([]).
emptyRow([0|RestRow]) :- emptyRow(RestRow).

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