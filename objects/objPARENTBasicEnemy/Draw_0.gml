
// draw shadow
draw_set_color(c_black);
draw_set_alpha(0.3); // Semi-transparent
    
//  height change shadow size
var _shadow_scale = max(0.12, 0.6 - (z / 200)); 
draw_ellipse(x - (12 * _shadow_scale), y - (4 * _shadow_scale), x + (12 * _shadow_scale), y + (10 * _shadow_scale), false);
    
draw_set_alpha(1.0); // Reset alpha


// 2. Draw the actual sprite offset by the Z height
if (invulnerable)
{
	shader_set(shdHitFlash);
	draw_sprite_ext(sprite_index, image_index, x, y - z, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
	shader_reset();

} else
	draw_sprite_ext(sprite_index, image_index, x, y - z, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
