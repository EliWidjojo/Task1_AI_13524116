show_condition :-
    ensure_game_running,
    day(Day),
    current_time(Time),
    current_place(Place),
    current_weather(Weather),
    format("Day ~d: ~w~n", [Day, Time]),
    format("~w~n", [Weather]),
    write('==========================='), nl,
    format("You are currently in '~w'~n", [Place]).

show_character_stats(Character) :-
    ensure_game_running,
    stats(Character, hunger, Hunger),
    stats(Character, thirst, Thirst),
    stats(Character, energy, Energy),
    stats(Character, health, Health),
    stats(Character, happiness, Happiness),
    is_hypothermic(Character, Sickness),
    format("~w~n===========================~n", [Character]),
    format("Hunger: ~d~n", [Hunger]),
    format("Thirst: ~d~n", [Thirst]),
    format("Energy: ~d~n", [Energy]),
    format("Health: ~d~n", [Health]),
    format("Happiness: ~d~n", [Happiness]),
    format("Hypothermia: ~w~n", [Sickness]).

show_stats :-
    ensure_game_running,
    show_character_stats(chito), nl,
    show_character_stats(yuuri).

show_inventory :-
    ensure_game_running,
    write('Inventory'), nl,
    write('==========================='), nl,
    forall(between(0,19, Idx),
        (
            bag_list(empty, Idx) -> format("Slot ~d: [Empty Slot]~n", [Idx]);
            bag_list(Item, Idx) -> format("Slot ~d: ~w~n", [Idx, Item])
        )
    ).



