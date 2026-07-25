:- include('activity.pl').
:- include('character.pl').
:- include('display.pl').
:- include('game.pl').
:- include('inventory.pl').
:- include('item.pl').
:- include('place.pl').
:- include('save.pl').
:- include('sickness.pl').
:- include('time.pl').
:- include('weather.pl').

start_game :-
    change_place,
    change_weather,
    start_inventory,
    write('SUCCESS: Starting game...'),nl,
    retract(game_started(_)),
    assertz(game_started(true)).

