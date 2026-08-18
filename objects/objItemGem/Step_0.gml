//itemGem step

if (state != ItemState.TRASHING)
update_airborne_physics()


var _trashCan = instance_place(x, y, objTrash);
	
if (z <= 1)
{
	var _found = instance_place(x, y, objTrash)
	if (_found != noone)
	{
		state = ItemState.TRASHING;
		trash_phase = TrashPhase.HOVER;
		trash_target = _found
	}
}

if state == ItemState.TRASHING
{
	speed = 0;
	if (!instance_exists(trash_target))
	{
		state = ItemState.DEFAULT;
		exit;
	}
	
	switch (trash_phase)
	{
		case TrashPhase.HOVER:
			trash_target.trash_open = true;
			x = lerp(x, trash_target.goal_x, 0.2);
			y = lerp(y, trash_target.y, 0.2);
			z = lerp(z, trash_target.hover_z, 0.2);
			
			// wait until it's basically at the hover spot AND the lid is fully open
			if (point_distance(x, y, trash_target.goal_x, trash_target.y) < 2
				&& abs(z - trash_target.hover_z) < 1
				&& trash_target.image_index >= 4)
			{
				trash_phase = TrashPhase.DROP;
				trash_drop_timer = 0;
			}
		break;
		
		case TrashPhase.DROP:
			trash_drop_timer++;
			z = lerp(z, 0, 0.3);
			image_alpha = lerp(image_alpha, 0, 0.3);
			image_xscale = lerp(image_xscale, 0, 0.3);
			image_yscale = lerp(image_yscale, 0, 0.3);
			
			if (trash_drop_timer >= 4)
			{
				trash_target.trash_item_dropped = true;
				instance_destroy();
			}
		break;
	}
	
	exit;
}

#region // Physics
if instance_place(x + hspeed, y, objCollision)
hspeed = -hspeed

if instance_place(x, y + vspeed, objCollision)
vspeed = -vspeed



// clip item out of walls
if place_meeting(x, y, objCollision)
{
	var _spot_found = false;
	
	// search outwards
	for (var _radius = 1; _radius <= 32; ++_radius)
	{
		// Check 8 directions around the item
		for (var _angle = 0; _angle < 360; _angle += 45)
		{
			var _check_x = x + lengthdir_x(_radius, _angle);
			var _check_y = y + lengthdir_y(_radius, _angle);
			
			// If free space is found, move here
			if !place_meeting(_check_x, _check_y, objCollision)
			{
				x = _check_x;
				y = _check_y;
				_spot_found = true;
				break;
			}
		}
		if (_spot_found) break;
	}
}

#endregion

if (alarm[0] > 0) exit;


if instance_place(x, y, objPlayerSpecialHitbox)
{
	if (addItemToInventory(cloneItem(item, item.Count)))
	{
		audio_play_sound(sndXPOrb, 1, false);
		instance_destroy();
	}
}
else if (point_distance(x, y, objPlayerSpecialHitbox.x, objPlayerSpecialHitbox.y) <= (objPlayer.playerRange)
	&& inventoryHasSpaceForItem(item))
{
	direction = point_direction(x, y, objPlayerSpecialHitbox.x, objPlayerSpecialHitbox.y);
	speed = lerp(speed, MagnetSpeed, 0.1);
}