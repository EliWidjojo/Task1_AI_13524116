:- dynamic(bagList/2). % bagList(Item, BagIdx)

start_inventory :-
    retractall(bagList(_,_)),
    forall(between(0, 1, Idx), assertz(bagList(water, Idx))),
    forall(between(2, 3, Idx), assertz(bagList(ration, Idx))),
    forall(between(4, 19, Idx), assertz(bagList(empty, Idx))).

add_item(Item) :-
    bagList(empty, FirstEmpty),
    retract(bagList(_, FirstEmpty)),
    assertz(bagList(Item, FirstEmpty)),
    format("SUCCESS: Insert ~w in slot ~d ~n", [Item, FirstEmpty]),
    !.

add_item(_) :-
    write("FAIL: Your inventory is full!"), nl.

remove_item(Idx) :-
    bagList(Item, Idx), !,
    retract(bagList(_, Idx)),
    assertz(bagList(empty, Idx)),

remove_item(Idx) :-
    bagList(empty, Idx),

