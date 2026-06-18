playerInputChecks()



// set walking variable
if (abs(xspd) > 0 || abs(yspd) > 0)
{walking = true;}
else
{walking = false}


playerStateLibrary() // determine playerState


// move left right up down
xspd = (moveRight - moveLeft) * movementSpeed;
yspd = (moveDown - moveUp) * movementSpeed;

if walking
{
	state = PlayerState.WALKING
} else { state = PlayerState.IDLE }


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

debuffDictionary()


// kill player
if healthCurrent <= 0
{
	playerDie();
}
	

if place_meeting(x, y, objCheckpoint)
{
	if (interactPressed){
		saveGame();
	}
}


WeaponChecks()

WeaponDictionary()

playerStatsUpdate()


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
