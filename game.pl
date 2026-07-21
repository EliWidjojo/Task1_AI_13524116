:- dynamic(game_started/1).
game_started(false).
:- dynamic(game_over/1).
game_over(false).


% travel

travel :-
    ensure_game_running,
    travel_implement,
    bad_ending.

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
    clean_loot_list,
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
    modify_stats(Character, energy, -20).

travel_effect_rain(Character) :-
    retract(stats(Character, thirst, _)),
    assertz(stats(Character, thirst, 100)),
    modify_stats(Character, energy, -40).

travel_effect_light_snow(Character) :-
    modify_stats(Character, energy, -20).

travel_effect_heavy_snow(Character) :-
    modify_stats(Character, energy, -30).


% rest

rest :-
    ensure_game_running,
    change_time,
    retract(stats(chito, energy, _)),
    assertz(stats(chito, energy, 100)),
    retract(stats(yuuri, energy, _)),
    assertz(stats(yuuri, energy, 100)),
    write('Chito and Yuuri are full of energy!'),
    hypothermia_debuff.


% consume

consume(_, book) :-
    ensure_game_running,
    write('They can\'t eat a book!').

consume(_, bullets) :-
    write('They can\'t eat bullets!').

consume(Character, Item) :-
    bag_list(Item, Idx), !,
    character(Character), !,
    remove_item(Idx),
    item_stats(Item, Hunger, Thirst, Health, Happiness),
    modify_stats(Character, hunger, Hunger),
    modify_stats(Character, thirst, Thirst),
    modify_stats(Character, health, Health),
    modify_stats(Character, happiness, Happiness),
    format('~w consumed ~w and gain some stats.~n', [Character, Item]).

consume(Character, Item) :-
    character(Character), !,
    format("You don't have ~w~n", [Item]).

consume(_, _):-
    write('Person does not exist!'), nl.

% increase happiness

do_fun_activity(reading) :-
    ensure_game_running,
    change_time,
    bag_list(book, Idx), !,
    remove_item(Idx),
    modify_stats(chito, happiness, 50),
    modify_stats(yuuri, happiness, 10),
    write('Chito read a book out loud for Yuuri.'), nl.

do_fun_activity(reading) :-
    write('They don\'t have a book!'), nl.

do_fun_activity(shooting_targets) :-
    ensure_game_running,
    change_time,
    bag_list(bullets, Idx), !,
    remove_item(Idx),
    modify_stats(chito, happiness, 10),
    modify_stats(yuuri, happiness, 50),
    write('Yuuri shot some targets with Chito.'), nl.

do_fun_activity(shooting_targets) :-
    write('They don\'t have bullets!'), nl.

do_fun_activity(swimming) :-
    ensure_game_running,
    current_place(river), !, 
    change_time,
    modify_stats(chito, happiness, 10),
    modify_stats(yuuri, happiness, 30),
    write('Yuuri and Chito went swimming!').

do_fun_activity(swimming) :-
    write('They can\'t swim in here!').

do_fun_activity(taking_a_hot_bath) :-
    ensure_game_running,
    current_place(onsen), !,
    change_time,
    retract(stats(chito, happiness, _)),
    assertz(stats(chito, happiness, 100)),
    retract(stats(yuuri, happiness, _)),
    assertz(stats(yuuri, happiness, 100)),
    write('Yuuri and Chito took a hot bath.').

do_fun_activity(taking_a_hot_bath) :-
    write('They can\'t take a hot bath here!').

do_fun_activity(_) :-
    write('Nothing happened...').


% search loot

:- dynamic(loot_list/1). % loot_list([loot(Item, Quantity)])

add_to_loot_list(loot(Item, Quantity)) :-
    ensure_game_running,
    loot_list(CurrentLoot),
    retract(loot_list(_)),
    assertz(loot_list([loot(Item, Quantity) | CurrentLoot])).

remove_from_loot_list(Item) :-
    ensure_game_running,
    loot_list(_),
    take_one_loot(Item, List, NewList),
    retract(loot_list(List)),
    assertz(loot_list(NewList)).
    
take_one_loot(Item, [loot(Item, 1)|Tail], Tail).
take_one_loot(Item, [loot(Item, Quantity)|Tail], [loot(Item, Q1)|Tail]) :-
    Quantity > 1,
    Q1 is Quantity - 1.
take_one_loot(Item, [Head|Tail], [Head|NewTail]) :-
    take_one_loot(Item, Tail, NewTail).
take_one_loot(_, [], _) :-
    write('They don\'t have that item.'), nl,
    fail.

clean_loot_list :-
    retractall(loot_list(_)),
    assertz(loot_list([])).
    
search_for_loot :-
    ensure_game_running,
    current_place(Place),
    forall(drop_loot(Place, Item), (
        drop_rate(Item, Min, Max), 
        random(Min, Max, Amount),
        (Amount =\= 0 -> 
            add_to_loot_list(loot(Item, Amount))
            ;
            true
        )
        )).


% others

depletion :-
    depletion_implement(chito),
    depletion_implement(yuuri).

depletion_implement(Character) :-
    modify_stats(Character, hunger, -10),
    modify_stats(Character, thirst, -15),
    modify_stats(Character, energy, -20),
    modify_stats(Character, happiness, -10).

happy_ending :-
    day(30), !,
    write('They reached Day 30!'),
    retract(game_over(_)),
    assertz(game_over(true)).

happy_ending.

bad_ending :-
    bad_ending_checker, !,
    write('Bad ending. Try again?'), nl,
    retract(game_over(_)),
    assertz(game_over(true)).

bad_ending.

bad_ending_checker :-
    stats(Character, hunger, 0),
    format("~w dies from starvation!~n", [Character]), fail.

bad_ending_checker :-
    stats(Character, thirst, 0),
    format("~w dies from dehydration!~n", [Character]), fail.

bad_ending_checker :-
    stats(Character, health, 0),
    format("~w dies from illness!~n", [Character]), fail.

bad_ending_checker :-
    stats(Character, energy, 0),
    format("~w dies from exhaustion!~n", [Character]), fail.

bad_ending_checker :-
    stats(Character, happiness, 0),
    format("~w lost all hope and dies!~n", [Character]), fail.

bad_ending_checker.

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