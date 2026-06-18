// Health bar overlays are controlled in their own seperate objects.
// The flashing damage overlay is the only exception to this.

draw_sprite(sprShadow, 0, x, y+2)

if ((iFrames) && alarm[2] <= 0)
{
	alarm[2] = 5;
	shader_set(shdHitFlash);
	draw_self();
	shader_reset();

} else
	draw_self()




