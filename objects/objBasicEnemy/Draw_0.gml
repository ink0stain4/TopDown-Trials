//objBasicEnemy enemy placeholder draw event

// draw shadow
draw_set_color(c_black);
draw_set_alpha(0.3); // Semi-transparent
    
//  height change shadow size
var _shadow_scale = max(0.12, 0.6 - (z / 100)); 
draw_ellipse(x - (12 * _shadow_scale), (y - (4 * _shadow_scale)), x + (12 * _shadow_scale), y + (10 * _shadow_scale), false);

draw_set_alpha(1.0); // Reset alpha


// 2. Draw the actual sprite offset by the Z height
if (invulnerable)
{
	shader_set(shdHitFlash);
	draw_sprite_ext(sprite_index, image_index, x, y - z, image_xscale * facing, image_yscale, image_angle, image_blend, image_alpha);
	shader_reset();

} else
	draw_sprite_ext(sprite_index, image_index, x, y - z, image_xscale * facing, image_yscale, image_angle, image_blend, image_alpha);

var _sprH = sprite_get_height(sprite_index);

var _hbW = 8
var _hbH = 2


healthbar_draw(healthBar, (x - 4) -_hbW, y-_sprH-z, (x + 8) +_hbW, y-_sprH-_hbH-z, (Health/MaxHealth) * 100, c_dkgrey, c_yellow, c_lime, c_red, 0, true, true, true)


if global.debug
{
	draw_set_colour(c_blue)
	draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, false)
	
	if state = EnemyState.ROAMING
	{
		draw_set_colour(c_yellow)
		draw_circle(x, y, AggroRange, true)
	}
	
	if state = EnemyState.AGGRO
	{
		draw_set_colour(c_red)
		draw_circle(x, y, TrackingRange, true)
	}
	

	if (hasPath && array_length(currentPath) > 0)
	{
		draw_set_colour(c_lime);
		
		// draw a line through all remaining waypoints
		var _prevX = x;
		var _prevY = y;
		for (var i = pathNodeIndex; i < array_length(currentPath); i++)
		{
			draw_line(_prevX, _prevY, currentPath[i].x, currentPath[i].y);
			draw_circle(currentPath[i].x, currentPath[i].y, 2, false);
			_prevX = currentPath[i].x;
			_prevY = currentPath[i].y;
		}
		
		// highlight the immediate next waypoint (moveGoalX/Y) distinctly
		draw_set_colour(c_yellow);
		draw_circle(moveGoalX, moveGoalY, 3, false);
		
		draw_set_colour(c_white); // reset so it doesn't bleed into other draw calls
	}
}