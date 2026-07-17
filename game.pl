:- dynamic(game_started/1).
game_started(false).
:- dynamic(game_over/1).
game_over(false).

travel :-
    ensure_game_running,
    travel_implement.

travel_implement :-
    current_weather(blizzard), !,
    write('They can\'t travel because of a blizzard!'), nl.

travel_implement :-
    travel_effect,
    change_place,
    change_time,
    current_place(Place),
    day(Day),
    current_time(Time),
    format('They traveled to ~w.~n', [Place]),
    format('It is currently day ~d, ~w.~n', [Day, Time]),
    write('Chito and Yuuri spent some of their energy travelling!'),
    hypothermia_debuff(chito),
    hypothermia_debuff(yuuri).

travel_effect :-
    current_time(night), !,
    random(0, 4, Chance),
    random(0, 1, Character),
    (
        Chance =:= 0 ->
            Character =:= 0 -> give_sickness(chito);
            give_sickness(yuuri)
    ).

travel_effect :-
    current_weather(sunny), !,
    travel_effect_sunny(chito),
    travel_effect_sunny(yuuri).

travel_effect :-
    current_weather(rain), !,
    travel_effect_rain(chito),
    travel_effect_rain(yuuri).

travel_effect :-
    current_weather(light_snow), !,
    travel_effect_light_snow(chito),
    travel_effect_light_snow(yuuri).

travel_effect :-
    travel_effect_heavy_snow(chito),
    travel_effect_heavy_snow(yuuri).  

travel_effect_sunny(Character) :-
    retract(is_hypothermic(Character, _)),
    assertz(is_hypothermic(Character, false)),
    stats(Character, energy, Energy),
    Energy1 is Energy - 20,
    retract(stats(Character, energy, _)),
    assertz(stats(Character, energy, Energy1)).

travel_effect_rain(Character) :-
    retract(stats(Character, thirst, _)),
    assertz(stats(Character, thirst, 100)),
    stats(Character, energy, Energy),
    Energy1 is Energy - 40,
    retract(stats(Character, energy, _)),
    assertz(stats(Character, energy, Energy1)).   

travel_effect_light_snow(Character) :-
    stats(Character, energy, Energy),
    Energy1 is Energy-20,
    retract(stats(Character, energy, _)),
    assertz(stats(Character, energy, Energy1)).

travel_effect_heavy_snow(Character) :-
    stats(Character, energy, Energy),
    Energy1 is Energy - 30,
    retract(stats(Character, energy, _)),
    assertz(stats(Character, energy, Energy1)).

rest :-
    ensure_game_running,
    change_time,
    Value is 100,
    retract(stats(chito, energy, _)),
    assertz(stats(chito, energy, Value)),
    retract(stats(yuuri, energy, _)),
    assertz(stats(yuuri, energy, Value)),
    write('Chito and Yuuri are full of energy!'),
    hypothermia_debuff.

happy_ending :-
    day(30), !,
    write('They reached Day 30!'),
    retract(game_over(_)),
    assertz(game_over(true)).

happy_ending.

ensure_game_running :-
    game_started(true), !,
    game_over(false).

ensure_game_running :-
    game_started(false), !,
    write('The game hasn\'t started yet.'), nl,
    fail.

ensure_game_running :-
    write('The game has ended.'), nl,
    fail.
    