save_game :-
    open('../data/save.txt', write, Stream),
    forall(
        stats(Character, Stat, Value), 
        (write(Stream, stats(Character, Stat, Value)),
        period_new_line(Stream))
        ),
    forall(
        is_hypothermic(Character, Sickness),
        (write(Stream, is_hypothermic(Character, Sickness)),
        period_new_line(Stream))
    ),
    day(Day),
    write(Stream, day(Day)),
    period_new_line(Stream),
    current_time(Time),
    write(Stream, current_time(Time)),
    period_new_line(Stream),
    current_weather(Weather),
    write(Stream, current_weather(Weather)),
    period_new_line(Stream),
    current_place(Place),
    write(Stream, current_place(Place)),
    period_new_line(Stream), 
    forall(
        bag_list(Item, Idx),
        (write(Stream, bag_list(Item, Idx)),
        period_new_line(Stream))
    ),
    loot_list(List),
    write(Stream, loot_list(List)),
    period_new_line(Stream),
    game_started(GameStarted),
    write(Stream, game_started(GameStarted)),
    period_new_line(Stream), 
    game_over(GameOver),
    write(Stream, game_over(GameOver)),
    period_new_line(Stream),         
    close(Stream),
    write('SUCCESS: save game...').

    
period_new_line(Stream) :-
    write(Stream, '.'),
    nl(Stream).

load_game :-
    clean,
    open('../data/save.txt', read, Stream),
    read_file(Stream),
    close(Stream),
    write('SUCCESS: load game...').

read_file(Stream) :-
    at_end_of_stream(Stream), !.

read_file(Stream) :-
    read(Stream, Fact),
    assertz(Fact),
    read_file(Stream).

clean :-
    retractall(stats(_,_,_)),
    retractall(is_hypothermic(_,_)),
    retractall(day(_)),
    retractall(current_time(_)),
    retractall(current_weather(_)),
    retractall(current_place(_)),
    retractall(bag_list(_,_)),
    retractall(loot_list(_)),
    retractall(game_started(_)),
    retractall(game_over(_)).
