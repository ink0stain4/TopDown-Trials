update_airborne_physics()


if is_airborne // air/ground friction
friction = air_friction
else
friction = ground_friction

if hurt == true // iFrames
{
	alarm[0] = iFrame_dur;
	invulnerable = true;
	hurt = false;
}

if enemyHealth <= 0 // kill enemy
{
	instance_destroy();
}


var _aggroLength = 64 // set aggro alert range

if state == EnemyState.AGGRO // double range if enemy has seen player
{ _aggroLength = trackingRange }
else { _aggroLength = aggroRange }


var _enemyTarget = (objPlayer)

if state != EnemyState.STUNNED
{
	if (distance_to_object(_enemyTarget) <= _aggroLength)
	{
		state = EnemyState.AGGRO
	} else {
		state = EnemyState.ROAMING
	}
}



var _towardPlayer = point_direction(x, y, _enemyTarget.x, _enemyTarget.y)
var _randomDeviance = random_range(_towardPlayer - 1, _towardPlayer + 1)


if alarm[2] <= 0
{
	switch (state)
	{
		case EnemyState.ROAMING:
		{
			if alarm[2] <= 0
			{

				direction = random(359);
				launch_airborne(random_range(1, 2))
				speed = random_range(2, 3);
				alarm[2] = random_range(40, 60); // between 2 and 6 second intervals between hops
			}
		}
		break;
	
		case EnemyState.AGGRO:
		{
				direction = _randomDeviance
				launch_airborne(random_range(2, 4))
				speed = 3;
				alarm[2] = 20

		}
		break;
	
		case EnemyState.STUNNED:
		{
			if abs(speed) <= 0
			{
				alarm[2] = 20
				state = EnemyState.AGGRO
			}
		}
		break;
	}
}


if instance_place(x + hspeed, y, objHitbox)
{
	hspeed = -hspeed
}

if instance_place(x, y + vspeed, objHitbox)
{
	vspeed = -vspeed
}
	

// clip enemies out of walls
if place_meeting(x, y, objHitbox)
{
	var _spot_found = false;
	
	// search outwards
	for (var _radius = 1; _radius <= 32; ++_radius)
	{
		// Check 8 directions around the player
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