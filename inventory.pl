:- include('item.pl')
:- dynamic(bagList/2) % bagList(Item, BagIdx)

startBag :-
    retractall(bagList(_,_))
    forall(between(0, 1, Idx), assertz(bagList(bottle_of_water, Idx))),
    forall(between(2, 3, Idx), assertz(bagList(ration, Idx))),
    forall(between(4, 19, Idx), assertz(bagList(empty, Idx))).

addItem(Item) :-
    bagList(empty, FirstEmpty),
    retract(bagList(_, FirstEmpty)),
    assertz(bagList(Item, FirstEmpty)),
    format("SUCCESS: Insert ~w in slot ~d ~n", [Item, FirstEmpty]),
    !.

addItem(_) :-
    write("FAIL: Your inventory is full!"), nl.


removeItem(Idx) :-
    retract(bagList(_, Idx))
    assertz(bagList(empty, Idx))
    
showBag :-
    write("INVENTORY"), nl,
    forall(between(0,19, Idx),
        (bagList(empty, Idx) -> 
            format("Slot ~d: [Empty Slot]~n", [Idx]))
        ;
        (bagList(Item, Idx) ->
            format("Slot ~d: ~w~n", [Idx, Item]))
    )