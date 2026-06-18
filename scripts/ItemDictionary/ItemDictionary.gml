function Item(_name, _sprite, _max_stack) constructor { // Existence of the item
	name = _name;
	sprite = _sprite;
	max_stack = _max_stack;
}



global.item_apple = new Item("Apple", sprApple, 64);





function ItemStack(_item, _amount) constructor { // Presence of the item
	item = _item;
	amount = _amount;
}








global.items = {};

//global.items.apple = new Item("Apple", spr_apple, 64);



