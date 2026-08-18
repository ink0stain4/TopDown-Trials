healthbarX = camera_get_view_x(view_camera) + padding_x
healthbarY = camera_get_view_y(view_camera) + padding_y

draw_sprite(
			sprHealthBar,
			63 - (objPlayer.healthCurrent * (63 / global.healthMax)),
			healthbarX,
			healthbarY
			)

if objPlayer.staggered // statemachine change this to just a state called "staggered" or something
{
	draw_sprite(sprDamageOverlay, 0, healthbarX, healthbarY)
}


if global.debug
{
	draw_set_halign(fa_left)
	draw_set_font(fontSmall)
	draw_text_ext_colour(
						text_padding_x + healthbarX + sprite_get_width(sprite_index),
						healthbarY, (string(objPlayer.healthCurrent)),
						0.5,
						32,
						c_white,
						c_white,
						c_white,
						c_white,
						1)
}