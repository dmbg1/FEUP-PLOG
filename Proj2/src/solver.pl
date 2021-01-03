solveBoard(Clues, Solution) :-    
    [RowClues, ColClues] = Clues,
    getSolutionValues(RowClues, RowValues),
    getSolutionValues(ColClues, ColValues),
    checkColValues(ColValues, RowValues),
    checkMatrixMults(ColValues, RowValues, RowClues, ColClues),
    append([RowValues, ColValues], Solution1),
    labeling([], Solution1), !,
    Solution = [RowValues, ColValues] % Better format to get solution matrix
.

checkColValues([],[]).
checkColValues(_, []).
checkColValues([], _).
checkColValues([C1, C2|RestCols], [R1, R2|RestRows]) :-
    ((C1 #\= R1 #\/ C2 #\= R2) #/\ (C1 #\= R2 #\/ C2 #\= R1)),
    checkColValues([C1, C2|RestCols], RestRows),
    checkColValues(RestCols, [R1, R2|RestRows])
.

checkMatrixMults([], [], [], []).
checkMatrixMults([C1, C2|RestCols], [R1, R2|RestRows], [RowClue|RestR], [ColClue|RestC]) :-
    (((C1 * C2 #= ColClue + 1) #\/ (C1 * C2 #= ColClue - 1)) #/\ ((R1 * R2 #= RowClue + 1) #\/ (R1 * R2 #= RowClue - 1))),
    checkMatrixMults(RestCols, RestRows, RestR, RestC)
.

getSolutionValues(Clues, Solution) :-
    length(Clues, GridSize),
    MaxValue is GridSize * 2,
    length(Solution, MaxValue),
    domain(Solution, 1, MaxValue),
    all_distinct(Solution),
    restrictions(Solution, Clues)
.
restrictions([], []).
restrictions([X1, X2|Rest], [Clue|RestClues]) :-
    ((X1 * X2) #= (Clue + 1)) #\ ((X1 * X2) #= (Clue - 1)),
    restrictions(Rest, RestClues)
.

getSolutionMatrix(Solution, SolutionMatrix, Size) :-
    length(EmptyMatrix, Size),
    maplist(same_length(EmptyMatrix), EmptyMatrix),
    emptyMatrix(EmptyMatrix, Size), 
    fillWithSolution(EmptyMatrix, Solution, 1, SolutionMatrix), !
.
fillWithSolution(Matrix, Solution, SecondRowValueIndex, FinalMatrix) :- 
    [RowValues, ColValues] = Solution,
    length(RowValues, AmountOfValues),
    SecondRowValueIndex =< AmountOfValues - 1,
    X1 is SecondRowValueIndex - 1,
    nth0(X1, RowValues, Value1),
    LineCoord is X1 // 2,
    nth0(Y1, ColValues, Value1),
    ColCoord1 is Y1 // 2,
    setValue(Value1, Matrix, Matrix1, LineCoord, ColCoord1),
    nth0(SecondRowValueIndex, RowValues, Value2),
    nth0(Y2, ColValues, Value2),
    ColCoord2 is Y2 // 2,
    setValue(Value2, Matrix1, Matrix2, LineCoord, ColCoord2),    
    NextIndex is SecondRowValueIndex + 2,
    fillWithSolution(Matrix2, Solution, NextIndex, FinalMatrix)
.
fillWithSolution(FinalMatrix, _, _, FinalMatrix).

getSolutionColClues([], _Index, Accum, [Accum|_RestClues]).
getSolutionColClues(Solution, Index, Accum, ColClues) :-
    [Clue|RestClues] = ColClues,
    [Row|RestRows] = Solution,
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
       getSolutionColClues(Solution, Index1, 1, RestClues)
       );
       true)
.
getSolutionColClues(_, _, _, []).

getSolutionRowClues([], _Index, _Accum, []).
getSolutionRowClues(Solution, Index, Accum, RowClues) :-
    [Clue|RestClues] = RowClues,
    [Row|RestRows] = Solution,
    length(Row, Size),
    Index =< Size,
    nth1(Index, Row, Value),
    Index1 is Index + 1,
    ((Value = 0,
     getSolutionRowClues(Solution, Index1, Accum, [Clue|_]));
     (Value \= 0,
     Accum1 is Accum * Value, 
     getSolutionRowClues(Solution, Index1, Accum1, [Clue|_]))),
    getSolutionRowClues(RestRows, 1, 1, RestClues)
.
getSolutionRowClues(_, _Index, Accum, [Accum|_RestClues]).