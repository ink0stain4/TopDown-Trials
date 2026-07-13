// objPlayer draw event

// Health bar overlays are controlled in their own seperate objects.
// The flashing damage overlay is the only exception to this.

if instance_exists(objFadeIn)
exit;

if instance_exists(objFadeOut)
exit;


if (state != PlayerState.FADEIN) && (state != PlayerState.FADEOUT)
draw_sprite(sprShadow, 0, x, y+2)
//{
//	// draw shadow
//	draw_set_color(c_black);
//	draw_set_alpha(0.3); // Semi-transparent
//	//  height change shadow size
//	var _heightOffset = 0 // i change depending on sprite
//	var _shadow_scale = max(0.12, 0.6 - (z / 200)); 
//	draw_ellipse(x - (12 * _shadow_scale), (y - (4 * _shadow_scale)) +_heightOffset, x + (12 * _shadow_scale), y + (10 * _shadow_scale)+_heightOffset, false);
    
//	draw_set_alpha(1.0); // Reset alpha


//	draw_set_colour(c_white)


//}


if ((iFrames) && alarm[2] <= 0)
{
	alarm[2] = 5;
	shader_set(shdHitFlash);
	draw_sprite_ext(sprite_index, -1, x, y, facing, 1, 0, c_white, 1)
	shader_reset();

} else
	draw_sprite_ext(sprite_index, -1, x, y, facing, 1, 0, c_white, 1)

