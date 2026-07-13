// draw shadow
draw_set_color(c_black);
draw_set_alpha(0.3); // Semi-transparent
    
//  height change shadow size
var _heightOffset = 3 // i change depending on sprite
var _shadow_scale = max(0.12, 0.4 - (z / 200)); 
draw_ellipse(x - (12 * _shadow_scale), (y - (4 * _shadow_scale)) +_heightOffset, x + (12 * _shadow_scale), y + (10 * _shadow_scale)+_heightOffset, false);
    
draw_set_alpha(1.0); // Reset alpha


draw_set_colour(c_white)

draw_sprite(sprite_index, 0, x, y - z);


if (hovered)
{
	var _pad = 4; // pixels
	var _txt = string(item.ItemName);
	var _tw = string_width(_txt) + _pad*2;   // full box pixel width
	var _th = string_height(_txt) + _pad*2;  // full box pixel height
	
	var _cx = mouse_x + _tw/2; // box center x, offset from cursor
	var _cy = mouse_y - _th/2;      // box center y
	
	draw_sprite_ext(
		sprInventoryBackground,
		0,
		_cx,
		_cy,
		_tw / sprite_get_width(sprInventoryBackground),
		_th / (sprite_get_height(sprInventoryBackground) + 4),
		0,
		c_white,
		1)
	
	draw_text(_cx - _tw/2 + _pad, _cy - _th/2 + _pad, _txt)
}