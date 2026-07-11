// objMenu draw

var _cam_x = camera_get_view_x(view_camera);
var _cam_y = camera_get_view_y(view_camera);
var _cam_w = camera_get_view_width(view_camera);
var _cam_h = camera_get_view_height(view_camera);


// center menu
final_x = _cam_x + (_cam_w / 2) - (widthFull / 2) + x_offset;
final_y = _cam_y + (_cam_h / 2) - (heightFull / 2) + y_offset;

// draw menu box
draw_sprite_stretched(sprMenuBox, -1, final_x, final_y, widthFull, heightFull);

// draw text
draw_set_font(fontSmall);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// consider margins
var _text_x = final_x + margin;
var _text_y = final_y + margin;
var _has_desc = (description != -1);

for (var l = 0; l < (optionsCount + _has_desc); l++) {
	draw_set_colour(c_white);
	
	if (l == 0) && (_has_desc) {
		// draw the description
		draw_text(_text_x, _text_y, description);
	} else {
		// change offset for description
		var _option_index = l - _has_desc;
		var _str = options[_option_index][0];
		
		// highlight hovered option
		if (hover == _option_index) {
			draw_set_colour(c_yellow);
			_str = hovermarker + _str;
		}
		
		// draw optino text lines
		draw_text(_text_x, _text_y + (l * heightLine), _str);
	}
}













//x =	camera_get_view_x(view_camera) + (camera_get_view_width(view_camera) / 2) - sprite_width - 6
//y =	camera_get_view_y(view_camera) + (camera_get_view_height(view_camera) / 2) - sprite_height

//draw_sprite_stretched(sprMenuBox, 0, x-margin, y-margin, widthFull, heightFull)

//draw_set_colour(c_white);
//draw_set_font(fontSmall);
//draw_set_halign(fa_left);
//draw_set_valign(fa_top);

//var _desc = !(description == -1);
//for (l = 0; l < (optionsCount + _desc); l++)
//{
//	draw_set_colour(c_white);
//	if (l == 0) && (_desc)
//	{
//		draw_text(x, y, description)
//	}
//	else
//	{
//		var _str = options[l-_desc][0]
//		if (hover == l - _desc)
//		{
//			draw_set_colour(c_yellow);
//			_str = hovermarker+_str;
//		}
//		draw_text(x, y + l * heightLine, _str);
//	}
//}

