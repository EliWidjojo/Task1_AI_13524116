start_game :-
    change_place,
    change_weather,
    start_inventory,
    write('SUCCESS: Starting game...'),nl,
    retract(game_started(_)),
    assertz(game_started(true)).

