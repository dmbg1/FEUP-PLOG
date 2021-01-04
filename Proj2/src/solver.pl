% Resolve a Board com as Clues passadas no primeiro argumento
solveBoard(Clues, Solution) :-    
    [RowClues, ColClues] = Clues,
    getSolutionValues(RowClues, RowValues),
    getSolutionValues(ColClues, ColValues),
    checkColValues(ColValues, RowValues),
    append([RowValues, ColValues], Solution1),
    labeling([ffc], Solution1),
    Solution = [RowValues, ColValues] 
.

% Resolve a Board com as Clues passadas no primeiro argumento sem o labelling
solveBoardNoLabeling(Clues, Solution) :-    
    [RowClues, ColClues] = Clues,
    getSolutionValues(RowClues, RowValues),
    getSolutionValues(ColClues, ColValues),
    checkColValues(ColValues, RowValues),
    Solution = [RowValues, ColValues]
.

% Aplica a restrições que não permitem que uma coluna tenha os mesmos 2 valores que uma linha 
checkColValues([],[]).
checkColValues(_, []).
checkColValues([], _).
checkColValues([C1, C2|RestCols], [R1, R2|RestRows]) :-
    ((C1 #\= R1 #\/ C2 #\= R2) #/\ (C1 #\= R2 #\/ C2 #\= R1)),
    checkColValues([C1, C2|RestCols], RestRows),
    checkColValues(RestCols, [R1, R2|RestRows])
.

% Aplica a restrição em que a multiplicação dos elementos de cada coluna ou linha tem de dar +1 ou -1 que a Clue respetiva na Board a resolver 
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

% Transforma a solução no formato de uma matriz Size x Size
getSolutionMatrix(Solution, SolutionMatrix, Size) :-
    getEmptyMatrix(EmptyMatrix, Size),
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

% Obtém as Clues resultantes da multiplicação dos valores de cada linha ou coluna de uma solução
getSolutionClues([],[], [], []).
getSolutionClues([R1, R2|RestRValues], [SolRowClue|RestSolRowClues], [C1, C2|RestCValues], [SolColClue|RestSolColClue]) :-
    SolRowClue is R1 * R2, 
    SolColClue is C1 * C2, 
    getSolutionClues(RestRValues, RestSolRowClues, RestCValues, RestSolColClue)
.
