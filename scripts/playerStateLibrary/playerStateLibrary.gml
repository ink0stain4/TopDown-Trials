function playerStateLibrary()
{
	switch (state)
	{
		
		case PlayerState.IDLE:
		sprite_index = sprPlayer;
		break;

		case PlayerState.WALKING:
		sprite_index = sprPlayerWalk;
		break;
		
		case PlayerState.ROLL:
		sprite_index = sprPlayerRoll;
		break;
		
		
	}

}


function checkXP()
{
	var bankedXP = (global.playerXP - global.expRequiredLvlUP)
	
	if (bankedXP >= 0)
	{
	global.playerLevel++
	global.playerXP = bankedXP	
	global.expRequiredLvlUP = round(63 + (global.playerLevel * 20))

	audio_play_sound(choose(sndYummy1, sndYummy2), 1, false, 3, 0, random_range(0.6, 1.4))
	
	show_debug_message(string(global.playerXP))
	show_debug_message(string(global.playerLevel))
	show_debug_message(string(global.expRequiredLvlUP))

	}
}




function playerStatsUpdate()
{
	checkXP()
}


// Weapons
function WeaponChecks()
{
	if scrollUp
	{
		class = Weapon.MELEE
	}
	
	if scrollDown
	{
		class = Weapon.RANGED
	}
}


function UpdateAccessories()
{
	function MagnetAccessory(_true = false)
	{
		if _true == true
		collectionDistance = 52
		else collectionDistance = 36
	}
}

function debuffDictionary()
{
	switch (debuff)
	{
		case debuffType.SLOWED:
		{
			debuff = debuffType.NONE;
			alarm[0] = game_get_speed(gamespeed_fps);
			movementSpeed *= slowMultiplier;
		}
		break;
		
		case debuffType.BURNED:
		{
			var _targetHealth = (objPlayer.healthCurrent - 10) // health to burn away
			for (var i = 0; i < _targetHealth; ++i)
			{objPlayer.healthCurrent--}
		}
		
		break;
			

	}
}


function WeaponDictionary()
{
	switch (class)
	{
		case Weapon.MELEE:
		{
			//show_debug_message("MELEE")
			// 1. Reduce attack cooldown timer frame by frame
			if (attackTimer > 0) && (state != PlayerState.ROLL)
			{
			    attackTimer--;
			}

			// 2. Perform the 360-degree attack when left click is pressed
			if (attackPressed && attackTimer <= 0)
			{
    
			    // Reset the attack timer
			    attackTimer = attackRate;
    
				// Calculate the angle from player center to mouse cursor
				var attackDirection = point_direction(x, y, mouse_x, mouse_y);
    
				// Spawn the attack hitbox object
				var myAttack = instance_create_layer(x, y, "Attacks", objBasicAttackHB);
				audio_play_sound(sndSwing, 1, false, 1, 0, random_range(1, 1.2))
    

				myAttack.image_angle = attackDirection;
				myAttack.direction = attackDirection;
			}
		}
		break;
		
		case Weapon.RANGED:
		{
			// tick cd timer
			if (attackTimer > 0) && (state != PlayerState.ROLL)
			{
			    attackTimer--;
			}

			// shoot on left click
			if (attackPressed && attackTimer <= 0)
			{
    
			    // Reset attack timer
			    attackTimer = attackRate;
    
				// angle from player center to mouse cursor
				var attackDirection = point_direction(x, y, mouse_x, mouse_y);
    
				// spawn bullet
				var myAttack = instance_create_layer(x, y, "Attacks", objRangedAttackBullet);
    

				myAttack.image_angle = attackDirection;
				myAttack.direction = attackDirection;
				myAttack.speed = 3
			}
		}
		break;
	}
}
		