/* Menu do jogo que recebe como input 1 para jogar no modo de jogador contra jogador, 
2 para jogar no modo de jogador contra computador, 3 para visualizar o modo computador
contra computador com intervalos de 5 segundos entre jogadas, 4 para visualizar o modo computador
contra computador sem intervalos entre jogadas, 5 para verificar as instruções de jogo 
e 0 para sair do jogo*/
menu :-
    format('    ---------------~n    | GREEN SKULL |~n    ---------------~n', []),
    format('       Main Menu~nChoose an option:~n', []),
    format('1 - Play (2 Players)~n', []),
    format('2 - Play (Against PC)~n', []),
    format('3 - Watch PC against PC with 5 seconds between turns~n', []),
    format('4 - Watch PC against PC with no time between turns~n', []),
    format('5 - Instructions~n', []),
    format('0 - Exit~n', []),
    read(Input),
    manageInput(Input)
.

/* Trata das opções de input anteriormente referidas */
manageInput(1) :- 
    cls,
    start_game(noBot, 0, 0), !,
    cls,
	menu
.
manageInput(2) :-
    !,
    cls,
    difficultyMenu(againstBot, 0)
.
manageInput(3) :-
    !,
    cls,
    difficultyMenu(botAgainstBot, 5)
.
manageInput(4) :-
    !,
    cls,
    difficultyMenu(botAgainstBot, 0)
.
manageInput(5) :-
    cls,
    format('Your objective is to have more points than the other player and the zombies.~n', []),
    format('Note that the zombies can win the game too.~n~n', []),
	format('Each captured piece of a player gives both opponents 1 point.~n', []),
    format('When the game ends, each piece at the opposite side of the initial display gives that player 2 points.~n',[]),
	format('Zombies score the same way as players.~n~n', []),
    format('The player who possesses the skull controls the zombies. If that player captures a piece he passes the skull to the other player.~n~n',[]),
	format('A position\'s coordinate has the following structure:~n', []),
    format('  -It is a 2 digit number~n', []),
    format('  -The most significant digit represents the number of the position\'s line. It goes from 0 to 9~n',[]),
	format('  -The unit digit represents the position within that line (from 0 to 9 as well). Since the board is a triangle, the range of values varies from line to line~n~n',[]),
	format('A piece can move to an empty adjacent space, or it can capture an adjacent piece by jumping over it.~n', []),
    format('Multiple piece captures are allowed.~n~n',[]),	
    !,
    menu
.
manageInput(0).
manageInput(_) :- 
    cls,
    format('Not an option, try again...~n', []), !, menu
.

% Menu para escolher a dificuldade de jogo (Bot aleatório ou Bot normal)
difficultyMenu(Mode, BetweenTurns) :-
    format('       Difficulty Menu~nChoose an option:~n', []),
    format('1 - Random Bot~n', []),
    format('2 - Normal Bot~n', []),
    format('0 - Go Back~n', []), 
    read(Input),
    manageDifficultyInput(Input, Mode, BetweenTurns)
.
manageDifficultyInput(1, Mode, BetweenTurns) :-
    cls,
    start_game(Mode, BetweenTurns, 0), !,
    cls,
	menu
.
manageDifficultyInput(2, Mode, BetweenTurns) :-
    cls,
    start_game(Mode, BetweenTurns, 1), !,
    cls,
	menu
.
manageDifficultyInput(0, _, _) :-
    !,
    cls,
    menu
.
manageDifficultyInput(_, _) :-
    format('Not an option, try again...~n', []), !, difficultyMenu(_Difficulty)
.

    
