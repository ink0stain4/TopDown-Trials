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
{ _aggroLength = 96 }
else { _aggroLength = 64 }


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
var _randomDeviance = random_range(_towardPlayer - 3, _towardPlayer + 3)


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
				alarm[2] = random_range(40, 160); // between 2 and 6 second intervals between hops
			}
		}
		break;
	
		case EnemyState.AGGRO:
		{
				direction = _towardPlayer
				launch_airborne(random_range(2, 4))
				speed = 3;
				alarm[2] = 30

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