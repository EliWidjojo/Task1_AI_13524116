character(chito).
character(yuuri).

:- dynamic(stats/3).

% stats(Name, Stat, Value)
stats(chito, hunger, 100).
stats(chito, thirst, 100).
stats(chito, energy, 100).
stats(chito, health, 100).
stats(chito, happiness, 100).
stats(yuuri, hunger, 100).
stats(yuuri, thirst, 100).
stats(yuuri, energy, 100).
stats(yuuri, health, 100).
stats(yuuri, happiness, 100).

modify_stats(Name, Stat, Delta) :-
    retract(stats(Name, Stat, Value)),
    Value1 is Value + Delta,
    clamp(Value1, Value2),
    assertz(stats(Name, Stat, Value2)).

clamp(Value, 100) :-
    Value > 100, !.

clamp(Value, 0) :-
    Value < 0, !.

clamp(Value, Value).