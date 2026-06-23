// Health bar overlays are controlled in their own seperate objects.
// The flashing damage overlay is the only exception to this.

draw_sprite(sprShadow, 0, x, y+2)

if ((iFrames) && alarm[2] <= 0)
{
	alarm[2] = 5;
	shader_set(shdHitFlash);
	draw_sprite_ext(sprite_index, -1, x, y, facing, 1, 0, c_white, 1)
	shader_reset();

} else
	draw_sprite_ext(sprite_index, -1, x, y, facing, 1, 0, c_white, 1)




