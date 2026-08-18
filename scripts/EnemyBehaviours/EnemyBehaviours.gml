function enemy_behaviour_slime()
{
	MoveSpeed = 0.5
	air_friction = 0.02 
	ground_friction = 0.1
	
	if (!is_airborne) || (state == EnemyState.STUNNED) // air/ground friction
	friction = ground_friction
	else
	friction = air_friction

	if hurt == true // iFrames
	{
		alarm[0] = iFrame_dur;
		invulnerable = true;
		hurt = false;
	}

	if Health <= 0 // kill enemy
	{
		instance_destroy();
	}


	var _AggroLength = 64 // set aggro alert range

	if state == EnemyState.AGGRO // double range if enemy has seen player
	{ _AggroLength = TrackingRange }
	else { _AggroLength = AggroRange }


	var _enemyTarget = (objPlayer)

	if (state != EnemyState.STUNNED) && (state != EnemyState.DISPLACED)
	{
		if (distance_to_object(_enemyTarget) <= _AggroLength)
		{
			state = EnemyState.AGGRO
		}
		else
			state = EnemyState.ROAMING
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
					speed = random_range(MoveSpeed, MoveSpeed*2);
					alarm[2] = random_range(100, 160); // between 2 and 6 second intervals between hops
				}
			}
			break;
	
			case EnemyState.AGGRO:
			{
					direction = _randomDeviance
					launch_airborne(random_range(1.5, 2.5))
					speed = MoveSpeed*3;
					alarm[2] = 60

			}
			break;
	
			case EnemyState.STUNNED:
			{
				if abs(speed) <= 0
				{
					alarm[2] = 80

				}
			}
			break;
	
			case EnemyState.DISPLACED:
			{
			}
			break;
		}
	}


	if instance_place(x + hspeed, y, objBlockerParent)
	{
		hspeed = -hspeed
	}

	if instance_place(x, y + vspeed, objBlockerParent)
	{
		vspeed = -vspeed
	}
	

	// clip enemies out of walls
	if place_meeting(x, y, objBlockerParent)
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
				if !place_meeting(_check_x, _check_y, objBlockerParent)
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

	if (Health != previousHealth)
	{
		var _delta = Health - previousHealth
		var _type = (_delta < 0) ? DamageType.DAMAGE : DamageType.HEAL
	
		numberParticle(x, y - (bbox_bottom - bbox_top), ceil(abs(_delta)), _type)
	
		previousHealth = Health
	}
}

function enemy_behaviour_celly_enemy()
{
	air_friction = 0.02
	ground_friction = 0.5
	PunchSpawnOffsetY = sprite_get_height(sprCellyEnemyIdle) / 2;

	if (!is_airborne) || (state == EnemyState.STUNNED)
		friction = ground_friction
	else
		friction = air_friction

	if hurt == true // iFrames
	{
		alarm[0] = iFrame_dur;
		invulnerable = true;
		hurt = false;
	}

	if Health <= 0 // kill enemy
	{
		instance_destroy();
	}

	var _AggroLength = AggroRange

	if state == EnemyState.AGGRO
	{ _AggroLength = TrackingRange }
	else { _AggroLength = AggroRange }

	var _enemyTarget = (objPlayer)
	var _distToPlayer = distance_to_object(_enemyTarget)

	var _wasAggro = (state == EnemyState.AGGRO);

	// freeze state transitions while STUNNED, DISPLACED, or mid-punch
	if (state != EnemyState.STUNNED) && (state != EnemyState.DISPLACED) && (action == EnemyAction.NONE)
	{
		if (_distToPlayer <= _AggroLength)
		{
			state = EnemyState.AGGRO;
		}
		else
		{
			if (_wasAggro)
			{
				hasPath = false;
				speed = 0;
				alarm[2] = LostAggroPause;
			}
			state = EnemyState.ROAMING;
		}
	}

	var _towardPlayer = point_direction(x, y, _enemyTarget.x, _enemyTarget.y)

	switch (state)
	{
		case EnemyState.ROAMING:
		{
			if (action == EnemyAction.NONE)
			{
				if (!hasPath && alarm[2] <= 0)
				{
					pick_roam_goal();
				}

				if (hasPath)
				{
					var _arrived = follow_path_to(roamTargetX, roamTargetY, MoveSpeed, 0); // 0 = static target, path once
					if (_arrived)
					{
						alarm[2] = random_range(120, 280);
					}
				}
			}
		}
		break;

		case EnemyState.AGGRO:
		{
			if (action == EnemyAction.NONE)
			{
				if (_distToPlayer > AttackRange)
				{
					var _reachedEnd = follow_path_to(_enemyTarget.x, _enemyTarget.y, MoveSpeed * 1.2, RepathInterval);
			
					// no path exists at all, but we're still within aggro range - drift toward
					// the player directly rather than standing frozen (padding/corner edge case)
					if (!hasPath && array_length(currentPath) == 0)
					{
						direction = _towardPlayer;
						speed = MoveSpeed;
					}
				}
				else
				{
					hasPath = false;
					speed = 0;

					if (attackTimer <= 0)
					{
						action = EnemyAction.ATTACKING;
						punchDirection = _towardPlayer;
						alarm[1] = 15;
					}
				}
			}
		}
		break;

		case EnemyState.STUNNED:
		{
			hasPath = false;
			if (abs(speed) <= 0) && (alarm[2] <= 0)
				alarm[2] = 40
		}
		break;

		case EnemyState.DISPLACED:
		{
			hasPath = false;
		}
		break;
	}

		// handle the punch itself, independent of state
	if (action == EnemyAction.ATTACKING)
	{
		speed = 0;

		if (alarm[1] <= 0) && (!punchLanded)
		{
			var _punch = instance_create_layer(x, y - (PunchSpawnOffsetY), "Attacks", objEnemyPunchHB);
			_punch.image_angle	= punchDirection;
			_punch.direction	= punchDirection;
			_punch.EnemyDamage	= EnemyDamage;
			_punch.DamageDebuff	= DamageDebuff;
			_punch.source_enemy = id

			attackTimer = AttackRate;
			punchLanded = true;
			alarm[1] = punchRecoverFrames;
		}
		else if (alarm[1] <= 0) && (punchLanded)
		{
			action = EnemyAction.NONE;
			punchLanded = false;
		}
	}

	// walking sprite flag + facing
	walking = hasPath;

	if (state != EnemyState.STUNNED) && (abs(hspeed) > 0.05)
		facing = sign(hspeed);

	if (attackTimer > 0)
		attackTimer--;

	if instance_place(x + hspeed, y, objBlockerParent)
		hspeed = 0

	if instance_place(x, y + vspeed, objBlockerParent)
		vspeed = 0

	// clip enemies out of walls
	if place_meeting(x, y, objBlockerParent)
	{
		var _spot_found = false;

		for (var _radius = 1; _radius <= 32; ++_radius)
		{
			for (var _angle = 0; _angle < 360; _angle += 45)
			{
				var _check_x = x + lengthdir_x(_radius, _angle);
				var _check_y = y + lengthdir_y(_radius, _angle);

				if !place_meeting(_check_x, _check_y, objBlockerParent)
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

	if (Health != previousHealth)
	{
		var _delta = Health - previousHealth
		var _type = (_delta < 0) ? DamageType.DAMAGE : DamageType.HEAL

		numberParticle(x, y - (bbox_bottom - bbox_top), ceil(abs(_delta)), _type)

		previousHealth = Health
	}
	
		// --- animation swap ---
	if (state == EnemyState.STUNNED)
	{
		if (sprite_index != sprCellyEnemyHurt)
		{
			sprite_index = sprCellyEnemyHurt;
			image_index = 0;
		}
	}
	else if (action == EnemyAction.ATTACKING)
	{
		if (sprite_index != sprCellyEnemyPunch)
		{
			sprite_index = sprCellyEnemyPunch;
			image_index = 0;
		}
	}
	else if (walking)
	{
		if (sprite_index != sprCellyEnemyRun)
		{
			sprite_index = sprCellyEnemyRun;
			image_index = 0;
		}
	}
	else
	{
		if (sprite_index != sprCellyEnemyIdle)
		{
			sprite_index = sprCellyEnemyIdle;
			image_index = 0;
		}
	}
	

}