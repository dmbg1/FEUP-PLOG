:- use_module(library(between)).
:- use_module(library(lists)).
:- use_module(library(random)).
:- use_module(library(system)).
:- consult('board.pl').
:- consult('moves.pl').
:- consult('ui.pl').
:- consult('game.pl').
:- consult('bot.pl').


play :-
	initial(GameState),
	gameLoop(GameState, noBot)
.

playAgainstBot :-
	format('The PC plays with the white pieces~n', []),
	initial(GameState),
	gameLoop(GameState, againstBot)
.

botAgainstBot :-
	initial(GameState),
	gameLoop(GameState, botAgainstBot)
.


main :-
    format('    ---------------~n    | GREEN SKULL |~n    ---------------~n', []),
    format('       Main Menu~nChoose an option:~n1 - Play (2 Players)~n2 - Play (Against PC)~n3 - Watch PC against PC~n4 - Instructions~n5 - Exit~n', []),
    read(Input),
    (
		(Input = 1, 
			play, !,
			main)
		;
		(Input = 2, 
			playAgainstBot, !,
			main)
		;
		(Input = 3, 
			botAgainstBot, !,
			main)
		;
		(Input = 4, 
			format('Your objective is to have more points than the other player and the zombies.~nNote that the zombies can win the game too.~n~n', []),
			format('Each captured piece of a player gives both opponents 1 point.~nWhen the game ends, each piece at the opposite side of the initial display gives that player 2 points.~n',[]),
			format('Zombies score the same way as players.~n~nThe player who possesses the skull controls the zombies. If that player captures a piece he passes the skull to the other player.~n~n',[]),
			format('A position\'s coordinate has the following structure:~n  -It is a 2 digit number~n  -The most significant digit represents the number of the position\'s line. It goes from 0 to 9~n',[]),
			format('  -The unit digit represents the position within that line (from 0 to 9 as well). Since the board is a triangle, the range of values varies from line to line~n~n',[]),
			format('A piece can move to an empty adjacent space, or it can capture an adjacent piece by jumping over it.~nMultiple piece captures are allowed.~n~n',[]),
			!,
			main)
		;
		(Input = 5)
		;
		(format('Not an option, try again...~n', []), !, main)
	)
.

