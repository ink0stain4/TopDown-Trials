//update_airborne_physics()

playerInputChecks()

debuffDictionary()

WeaponChecks()

WeaponDictionary()

playerStatsUpdate()


interactableInRange = noone // for drawing button prompts on interactable objects

playerInteractChecks()


// Alarm[0] = Slow status effect duration
// Alarm[1] = iFrames timer
// Alarm[2] = iFrame blinking-effect interval
// Alarm[3] = Roll invincibility timer
// Alarm[4] = Roll cooldown timer


// move left right up down (calculate movement FIRST)
xspd = (moveRight - moveLeft) * movementSpeed;
yspd = (moveDown - moveUp) * movementSpeed;

// set walking variable from ts frame's movement
if (abs(xspd) > 0 || abs(yspd) > 0)
	walking = true;
else
	walking = false;

// Define what Rolling, Walking, or Idling means
if (global.playerBusy)
{
	state = PlayerState.IDLE;
}
else if (state != PlayerState.ROLL) && (state != PlayerState.TRANSITIONING) && (state != PlayerState.STUNNED) && (global.cutsceneMovelock == false)
{
	if (walking)
		state = PlayerState.WALKING;
	else
		state = PlayerState.IDLE;
}


// Handle the tumble dodge roll thing
if (state != PlayerState.ROLL) && (state != PlayerState.TRANSITIONING) && (alarm[4] <= 0) && (staminaCurrent > 10)
{
	if rollPressed
	{
		direction = point_direction(x, y, mouse_x, mouse_y);
		speed = 3;
		friction = 0.1;
		image_index = 0;
		state = PlayerState.ROLL;
		alarm[3] = 44;
		staminaCurrent -= 10;
	}
}


playerStateLibrary() // determine what playerStates mean


// x collision
if place_meeting(x + xspd, y, objBlockerParent)
{
	xspd = 0;
	hspeed = 0;

}
// y collision
if place_meeting(x, y + yspd, objBlockerParent)
{
	yspd = 0;
	vspeed = 0;

}

x += xspd;
y += yspd;


// Un-stuck the player
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



if (healthCurrent != previousHealth)
{
	var _delta = healthCurrent - previousHealth
	var _type = (_delta < 0) ? DamageType.DAMAGE : DamageType.HEAL
	var _width = sprite_get_width(sprite_index)
	var _height = sprite_get_height(sprite_index)
	
	numberParticle(random_range(x - (_width/2), x + (_width/2)), random_range((y-_height/2) - (_height/2), (y-_height) + (_height)), ceil(abs(_delta)), _type)
	
	previousHealth = healthCurrent
}

// clip player to pixel-perfect positioning

//if (!walking)
//{
//	x = round(x);
//	y = round(y);
//}



//show_debug_message(BreakSpeed)
