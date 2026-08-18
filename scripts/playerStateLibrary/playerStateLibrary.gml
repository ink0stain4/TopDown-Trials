function playerStateLibrary()
{
	var _prevSprite = sprite_index;
	
	switch (state)
	{		
		case PlayerState.IDLE:
		{
			sprite_index = sprPlayer;
			
			rightClickPlaceBlock()
			show_debug_message("IDLE")
		}
		break;

		case PlayerState.WALKING:
		{
			sprite_index = sprPlayerWalk;
		
			rightClickPlaceBlock()
			show_debug_message("WALKING")
		}
		break;
		
		case PlayerState.ROLL:
		{
			if (sprite_index != sprPlayerRoll)
			{
				sprite_index = sprPlayerRoll;
				image_index = 0;
			}
			show_debug_message("ROLL")
		}
		break;
		
		case PlayerState.STUNNED:
		{
			if (sprite_index != sprPlayer)
			{
				sprite_index = sprPlayer;
				image_index = 0;
			}
			
			if alarm[6] <= 0
			{
				alarm[6] = 10
			}
			
			show_debug_message("STUN")
		}
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
	global.expRequiredLvlUP = floor(63 + (global.playerLevel * 50))
	global.healthMax = floor(global.healthMax * 1.1)
	
	with objHealthBar
	{}
		

	audio_play_sound(choose(sndLvlup1, sndLvlup2), 1, false, 3, 0, random_range(0.6, 1.4))
	
	show_debug_message(string(global.playerXP))
	show_debug_message(string(global.playerLevel))
	show_debug_message(string(global.expRequiredLvlUP))

	}
}


function checkHealth()
{
	// kill player
	if healthCurrent <= 0
	{
		playerDie();
	}
}


function gainStamina()
{
	if state == PlayerState.ROLL exit;
	
	if (staminaCurrent < global.staminaMax) // always make stamina gain take 10 seconds
	{
		staminaCurrent += global.staminaMax / (staminaRecharge * game_get_speed(gamespeed_fps));
	}

	if (staminaCurrent > global.staminaMax) // no going over stamina limit
	staminaCurrent = global.staminaMax;
}


function playerStatsUpdate()
{
	checkXP()
	checkHealth()
	gainStamina()
	
	//Dynamic attack damage
	attackDamage = (strength * swordPower)
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

// Weapons
function WeaponChecks()
{
	if (swordPower > 0)
	equippedWeapon = Weapon.MELEE
	else
	equippedWeapon = noone
}

function WeaponDictionary()
{
	switch (equippedWeapon)
	{
		case Weapon.MELEE:
		{
			// 1. Reduce attack cooldown timer frame by frame
			if (attackTimer > 0) && (state != PlayerState.ROLL)
			{
			    attackTimer--;
			}

			// 2. attack when left click is pressed
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
			if (attackTimer > 0) //&& (state != PlayerState.ROLL)
			{
			    attackTimer--;
			}

			// shoot on left click
			if (attackPressed && attackTimer <= 0)
			{
    
			    // Reset attack timer
			    attackTimer = attackRate;
    
				// angle from player center to mouse cursor
				var attackDirection = point_direction(x, y - 6, mouse_x, mouse_y);
    
				// spawn bullet
				var rangedAttack = instance_create_layer(x, y - 6, "Attacks", objRangedAttackBullet);
    

				rangedAttack.image_angle = attackDirection;
				rangedAttack.direction = attackDirection;
				rangedAttack.speed = 3 //default
			}
		}
		break;
	}
}
		