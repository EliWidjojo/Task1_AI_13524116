% place(Place, Idx)
place(military_base, 0).
place(river, 1).
place(aquarium, 2).
place(apartment, 3).
place(farm, 4).
place(onsen, 5).
place(temple, 6).

% drop_loot(Place, Item)
drop_loot(military_base, ration).
drop_loot(military_base, bullets).
drop_loot(military_base, medicine).
drop_loot(river, water).
drop_loot(river, fish).
drop_loot(aquarium, water).
drop_loot(apartment, beer).
drop_loot(apartment, soup).
drop_loot(apartment, book).
drop_loot(farm, potato).
drop_loot(onsen, water).

:- dynamic(current_place/1).
current_place(empty).

change_place :-
    random(0, 7, NextIdx),
    place(NextPlace, NextIdx),
    retractall(current_place(_)),
    assertz(current_place(NextPlace)).