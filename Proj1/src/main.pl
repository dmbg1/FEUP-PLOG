:- use_module(library(between)).
:- use_module(library(lists)).
:- use_module(library(random)).
:- use_module(library(system)).
:- consult('board.pl').
:- consult('moves.pl').
:- consult('ui.pl').
:- consult('game.pl').
:- consult('bot.pl').
:- consult('menu.pl').


play :-
	menu
.

