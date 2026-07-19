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
    retract(Name, Stat, Value),
    Value1 is Value + Delta,
    assertz(Name, Stat, Value1).