staminaBarX = camera_get_view_x(view_camera) + padding_x
staminaBarY = camera_get_view_y(view_camera) + padding_y

draw_sprite(
			sprStaminaBar,
			63 - (objPlayer.staminaCurrent * (63 / global.staminaMax)),
			staminaBarX,
			staminaBarY
			)



if global.debug
{
	draw_set_halign(fa_left)
	draw_set_font(fontSmall)
	draw_text_ext_colour(
						text_padding_x + staminaBarX + sprite_get_width(sprite_index),
						staminaBarY, (string(objPlayer.staminaCurrent)),
						0.5,
						32,
						c_white,
						c_white,
						c_white,
						c_white,
						1)
}