update_airborne_physics()


#region // Physics
if instance_place(x + hspeed, y, objHitbox)
{
	hspeed = -hspeed
}

if instance_place(x, y + vspeed, objHitbox)
{
	vspeed = -vspeed
}


// clip item out of walls
if place_meeting(x, y, objHitbox)
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
			if !place_meeting(_check_x, _check_y, objHitbox)
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

for (var i = 0; i < objInventoryManager.invRows; i++)
{
	for (var j = 0; j < objInventoryManager.invColumns; j++)
	{
		if (objInventoryManager.inventory[i][j] == noone)
		{
			if (distance_to_object(objPlayerSpecialHitbox) <= (objPlayer.collectionDistance /2))
			{
				direction = point_direction(x, y, objPlayer.x, objPlayer.y-14)
				speed = lerp(speed, 5, 0.25)
			}

			if instance_place(x, y, objPlayerSpecialHitbox)
			{
				addItemToInventory(item)
				audio_play_sound(sndXPOrb, 1, false)
	
				instance_destroy()
			}


		}
	}
}

	
