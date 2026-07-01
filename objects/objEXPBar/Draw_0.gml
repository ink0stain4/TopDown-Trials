x = camera_get_view_x(view_camera) + (camera_get_view_width(view_camera) - padding_x)
y = camera_get_view_y(view_camera) + yLevel

draw_self()



if (!global.debug)
exit

draw_set_font(fontSmall)
draw_text_ext_colour(
					x - (text_padding_x + padding_x) - sprite_get_width(sprite_index),
					y, (string(global.playerXP)),
					0.5,
					32,
					c_white,
					c_white,
					c_white,
					c_white,
					1)