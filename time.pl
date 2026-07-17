:- dynamic(day/1).
day(1).

% time_of_day(Time, Idx)
time_of_day(morning, 0).
time_of_day(noon, 1).
time_of_day(evening, 2).
time_of_day(night, 3).

:- dynamic(current_time/1).
current_time(morning).

change_time :-
    current_time(night), !,
    retract(current_time(night)),
    assertz(current_time(morning)),
    retract(day(CurrentDay)),
    NextDay is CurrentDay + 1,
    assertz(day(NextDay)),
    change_weather,
    blizzard_debuff(chito),
    blizzard_debuff(yuuri),
    happy_ending.

change_time :-
    current_time(Current),
    time_of_day(Current, Idx),
    NextIdx is (Idx+1),
    time_of_day(Next, NextIdx),
    retract(current_time(Current)),
    assertz(current_time(Next)).


