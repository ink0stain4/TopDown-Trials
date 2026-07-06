playerInputChecks()

debuffDictionary()

WeaponChecks()

WeaponDictionary()

playerStatsUpdate()



// Alarm[0] = Slow status effect duration
// Alarm[1] = iFrames timer
// Alarm[2] = iFrame blinking-effect interval
// Alarm[3] = Roll invincibility timer
// Alarm[4] = Roll cooldown timer

// set walking variable
if (abs(xspd) > 0 || abs(yspd) > 0)
{walking = true;}
else
{walking = false}



playerStateLibrary() // determine playerState


// move left right up down
xspd = (moveRight - moveLeft) * movementSpeed;
yspd = (moveDown - moveUp) * movementSpeed;


// Define what Rolling, Walking, or Idling means
if (state != PlayerState.ROLL)
{
	if (walking)
	{
		state = PlayerState.WALKING
	} else { state = PlayerState.IDLE }
}



// Handle the tumble dodge roll thing
if (state != PlayerState.ROLL) && (alarm[4] <= 0) && (staminaCurrent > 10) // 10 magic number will change ig
{
	if rollPressed
	{
		direction = point_direction(x, y, mouse_x, mouse_y)
		speed = 4
		image_index = 0
		state = PlayerState.ROLL
		alarm[3] = 22
		staminaCurrent -= 10 // magic number
	}
}


// x collision
if place_meeting(x + xspd, y, objHitbox)
{
	xspd = 0;
	hspeed = 0;

}
// y collision
if place_meeting(x, y + yspd, objHitbox)
{
	yspd = 0;
	vspeed = 0;

}

x += xspd;
y += yspd;


// Un-stuck the player
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



// clip player to pixel-perfect positioning

//if (!walking)
//{
//	x = round(x);
//	y = round(y);
//}




if place_meeting(x, y, objCheckpoint)
{
	if (interactPressed){
		saveGame();
		show_debug_message("Saved!")
	}
}



var stack = new ItemStack(global.item_apple, 32)


