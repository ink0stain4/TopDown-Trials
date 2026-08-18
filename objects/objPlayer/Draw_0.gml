// objPlayer draw event
// Health bar overlays are handled by their own objects.
// The iFrame flash overlay is the only exception drawn here.



draw_sprite_ext(sprShadow, 0, x, y+2, facing, 1, 0, c_white, 1);

var _flashing = (iFrames) && (alarm[2] <= 0);
if (_flashing)
{
	alarm[2] = 8;
	shader_set(shdHitFlash);
}

draw_sprite_ext(sprite_index, -1, x, y, facing, 1, 0, c_white, 1);

if (_flashing)
	shader_reset();

if (global.debug)
{
	draw_set_colour(c_blue)
	draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, false)

	with (objPlayerSpecialHitbox)
	{
		draw_set_colour(c_fuchsia)
		draw_circle(x, y, objPlayer.playerRange, true)
	}
}