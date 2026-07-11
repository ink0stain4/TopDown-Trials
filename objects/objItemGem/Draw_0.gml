draw_self()

if (hovered)
{
	var _pad = 4; // pixels
	var _txt = string(item.ItemName);
	var _tw = string_width(_txt) + _pad*2;   // full box pixel width
	var _th = string_height(_txt) + _pad*2;  // full box pixel height
	
	var _cx = mouse_x + _tw/2; // box center x, offset from cursor
	var _cy = mouse_y - _th/2;      // box center y
	
	draw_sprite_ext(
		sprMenuBox,
		0,
		_cx,
		_cy,
		_tw / sprite_get_width(sprMenuBox),
		_th / (sprite_get_height(sprMenuBox) + 4),
		0,
		c_white,
		1)
	
	draw_text(_cx - _tw/2 + _pad, _cy - _th/2 + _pad, _txt)
}

