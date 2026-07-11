enum PlayerState
{
	FADEIN,
	IDLE,
	WALKING,
	ROLL,
	CUTSCENE,
	FADEOUT
}


enum Weapon
{
	MELEE,
	RANGED
}



class = Weapon.MELEE // type of weapon currently held

state = PlayerState.FADEIN

facing = 1 // (1 LEFT), (-1 RIGHT)


xspd = 0;
yspd = 0;

target_x = 0 // For teleporting
target_y = 0 // ^^

movementSpeed = 1;
slowMultiplier = 0.5; // the value enemies set player movement speed to on-contact

interactDistance = 10 // hard-set magic number for the player's interact distance


// Stats // Player stats received from save files
strength = global.playerStrength // attack power
knockbackPower = global.playerKnockback // negative velocity applied to enemies (scales with enemy type)
baseMovementSpeed = global.playerSpeed // speed the player is reset to

attackDamage = 1 * strength
attackTimer = 0
attackRate = 0.5 * game_get_speed(gamespeed_fps)

walking = false

healthCurrent = global.healthMax

staminaCurrent = global.staminaMax
staminaRecharge = 5 // make changeable dependent on equipment

staggered = false // displays damage alert over health bar
debuff = debuffType.NONE
iFrames = false


collectionDistance = 36 // dependent on magnet accessory


moveLock = false

direction = 270;
speed = 0
friction = 0.2

image_speed = 0

instance_create_layer // Handles pickup collection, eg. health orbs, EXP orbs, items, etc.
					(
					x,y,
					"Invisible_Assets",
					objPlayerSpecialHitbox
					)
					

