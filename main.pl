start_game :-
    change_place,
    change_weather,
    start_inventory,
    write('SUCCEES: Starting game...'),nl,
    retract(game_started(_)),
    assertz(game_started(true)).

