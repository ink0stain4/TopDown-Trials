selected_item = -1;
xx = camera_get_view_x(view_camera) + sep;
yy = camera_get_view_y(view_camera) + (camera_get_view_height(view_camera)/2) - sep;

for (var i = 0; i < array_length(inventory); i++)
{
	var _itemSprite = inventory[i].ItemSprite;
	var _w = sprite_get_width(_itemSprite);
	var _h = sprite_get_height(_itemSprite);
	var _iyy = yy + sep*i;
	
	if mouse_x > xx && mouse_x < xx + _w && mouse_y > _iyy && mouse_y < _iyy + _h
	{
		selected_item = i;
	}
}

if selected_item != -1
{
	// use its effect if any
	if mouse_check_button_pressed(mb_left)
	{
		inventory[selected_item].ItemEffect();
	}
	
	if mouse_check_button_pressed(mb_right)
	{
		dropItem(selected_item)
	}
}