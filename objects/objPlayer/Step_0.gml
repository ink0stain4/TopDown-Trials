playerInputChecks()

debuffDictionary()

WeaponChecks()

WeaponDictionary()

playerStatsUpdate()


// CHANGE PLAYER FACING DIRECTION
if state != PlayerState.ROLL
{
	if (mouse_x >= x)
	{
		facing = -1
	} else
	facing = 1
}


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

if (state != PlayerState.ROLL)
{
	if (walking)
	{
		state = PlayerState.WALKING
	} else { state = PlayerState.IDLE }
}


if (state != PlayerState.ROLL) && (alarm[4] <= 0)
{
	if rollPressed
	{
		direction = point_direction(x, y, mouse_x, mouse_y)
		speed = 4
		image_index = 0
		state = PlayerState.ROLL
		alarm[3] = 22
	}
}


// x collision
if place_meeting(x + xspd, y, objHitbox)
{
	xspd = 0;
}
// y collision
if place_meeting(x, y + yspd, objHitbox)
{
	yspd = 0;
}

	x += xspd;
	y += yspd;

// clip player to pixel-perfect positioning

if (!walking)
{
	x = round(x);
	y = round(y);
}


// kill player
if healthCurrent <= 0
{
	playerDie();
}
	

if place_meeting(x, y, objCheckpoint)
{
	if (interactPressed){
		saveGame();
		show_debug_message("Saved!")
	}
}





var stack = new ItemStack(global.item_apple, 32)


//show_debug_message(stack.item.name); // should be apple
//show_debug_message(stack.amount); // should be 32 of them



//// get the direction
//if speed == 0
//{
//	direction = point_direction(x, y, mouse_x, mouse_y)
//	isDashing = false


//	// dash logic
//	if dashPressed
//	{
//		show_debug_message(direction)
//		isDashing = true
//		speed = 6
//	}
//}




// currentHealth = current frame * 0.63

//draw_healthbar(0, 0, 100, 4, 100, c_grey, c_red, c_lime, 0, false, false)
