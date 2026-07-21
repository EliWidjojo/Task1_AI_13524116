% sickness(Sickness_Name, Health, InjuredHappiness, FriendHappiness)
sickness(broken_leg, -90, -50, -50).
sickness(scratch, -10, -10, -5).
sickness(hypothermia, -5, -5, -5).

:- dynamic(is_hypothermic/2).
is_hypothermic(chito, false).
is_hypothermic(yuuri, false).

give_sickness(Character) :-
    random(0, 3, Chance),
    ( 
        Chance < 1 -> 
            Sickness = broken_leg;

            Sickness = scratch
    ),
    sickness(Sickness, Health, InjuredHappiness, FriendHappiness)
    modify_stats(Character, health, Health),
    modify_stats(Character, happiness, InjuredHappiness),
    affect_friend_happiness(Character, FriendHappiness),
    stats(Friend, _, _), 
    Friend \= Character,
    format("~w's health and happiness decreases due to ~w.~n", [Character, Sickness]),
    format("~w also lost some hope.~n", [Friend]).

affect_friend_happiness(Character, Change) :-
    forall(
        (stats(Friend, _, _), Friend \= Character),
        modify_stats(Friend, happiness, Change)
    ).

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