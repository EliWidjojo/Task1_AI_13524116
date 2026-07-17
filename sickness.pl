% sickness(Sickness_Name, Health, InjuredHappiness, FriendHappiness)
sickness(broken_leg, -90, -50, -50).
sickness(scratch, -10, -10, -5).
sickness(hypothermia, -5, -5, -5).

:- dynamic(is_hypothermic/2).
is_hypothermic(chito, false).
is_hypothermic(yuuri, false).

give_sickness(Character) :-
    random(0, 3, Chance),
    stats(Character, health, Health),
    stats(Character, happiness, Happiness),
    ( 
        Chance < 1 -> 
            Health1 is Health -90, 
            Happiness1 is Happiness -50,
            format("~w broke her leg!~n", [Character]);

            Health1 is Health -10, 
            Happiness1 is Happiness -10,
            format("~w got a scratch!~n", [Character])

    ),
    retract(stats(Character, health, _)),
    assertz(stats(Character, health, Health1)),
    retract(stats(Character, happiness, _)),
    assertz(stats(Character, happiness, Happiness1)),
    format("~w's health and happiness decreases~n", [Character]).

give_hypothermia(Character) :- 
    stats(Character, health, Health),
    stats(Character, happiness, Happiness),
    retract(is_hypothermic(Character, _)), 
    assertz(is_hypothermic(Character, true)),
    Health1 is Health -5,
    Happiness1 is Happiness -5,
    format("~w got hypothermia!~n", [Character]),
    format("~w's health and happiness decreases", [Character]),
    retract(stats(Character, health, _)),
    assertz(stats(Character, health, Health1)),
    retract(stats(Character, happiness, _)),
    assertz(stats(Character, happiness, Happiness1)).

hypothermia_debuff(Character) :-
    is_hypothermic(Character, true), !,
    stats(Character, health, Health),
    stats(Character, happiness, Happiness),
    Health1 is Health -5,
    Happiness1 is Happiness -5,
    format("~w's health and happiness decreases", [Character]),
    retract(stats(Character, health, _)),
    assertz(stats(Character, health, Health1)),
    retract(stats(Character, happiness, _)),
    assertz(stats(Character, happiness, Happiness1)).

hypothermia_debuff(Character).