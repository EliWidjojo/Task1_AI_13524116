% item(Item)
item(ration).
item(water).
item(fish).
item(beer).
item(soup).
item(potato)
item(medicine).
item(book).
item(bullets).

% item_stats(Item, Hunger, Thirst, Health, Happiness)
item_stats(ration, 20, 0, 0, 0).
item_stats(water, 0, 40, 0, 0).
item_stats(fish, 30, 0, 0, 10).
item_stats(beer, 0, -10, 0, 50).
item_stats(soup, 20, 20, 0, 0).
item_stats(potato, 40, 0, 0, 0).
item_stats(medicine, 0, 0, 100, 0).

% drop_rate(Item, Min, Max)
drop_rate(ration, 4, 12).
drop_rate(water, 4, 12).
drop_rate(fish, 0, 2).
drop_rate(beer, 0, 4).
drop_rate(soup, 0, 6).
drop_rate(potato, 2, 6).
drop_rate(medicine, 0, 4).
drop_rate(book, 0, 3).
drop_rate(bullets, 0, 10).