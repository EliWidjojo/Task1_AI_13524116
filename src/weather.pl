% weather(Weather, Idx),
weather(sunny, 0).
weather(rain, 1).
weather(light_snow, 2).
weather(heavy_snow, 3).
weather(blizzard, 4).

:- dynamic(current_weather/1).
current_weather(empty).

change_weather :-
    random(0, 5, NextIdx),
    weather(NextWeather, NextIdx),
    retractall(current_weather(_)),
    assertz(current_weather(NextWeather)).

blizzard_debuff(Character) :-
    current_weather(blizzard), !,
    random(0, 10, Chance),
    (
        Chance =:= 0 -> 
            is_hypothermic(Character, false) ->
                give_hypothermia(Character)
    ).

blizzard_debuff(_).