for (var i = 0; i < array_length(inventory); i++)
{
	var _col = c_white
	var _itemSprite = (inventory[i].ItemSprite)
	var _iyy = yy + sep*i;
	
	draw_sprite(_itemSprite, 0, xx, _iyy);
	
	if selected_item == i { _col = c_yellow; };
	draw_set_colour(_col)
	draw_text(xx + sprite_get_width(_itemSprite), _iyy, " - " + string(inventory[i].ItemName));
}

draw_set_colour(c_white);