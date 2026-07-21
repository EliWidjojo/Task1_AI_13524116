:- dynamic(bag_list/2). % bag_list(Item, BagIdx)

start_inventory :-
    retractall(bag_list(_,_)),
    forall(between(0, 1, Idx), assertz(bag_list(water, Idx))),
    forall(between(2, 3, Idx), assertz(bag_list(ration, Idx))),
    forall(between(4, 19, Idx), assertz(bag_list(empty, Idx))).

add_item(Item) :-
    bag_list(empty, FirstEmpty),
    retract(bag_list(_, FirstEmpty)),
    assertz(bag_list(Item, FirstEmpty)),
    format("SUCCESS: Insert ~w in slot ~d ~n", [Item, FirstEmpty]),
    !.

add_item(_) :-
    write("FAIL: Your inventory is full!"), nl.

remove_item(Idx) :-
    bag_list(Item, Idx), !,
    retract(bag_list(_, Idx)),
    assertz(bag_list(empty, Idx)),

remove_item(Idx) :-
    bag_list(empty, Idx),

