enum PlayerState
{
	IDLE,
	WALKING,
	ROLL
}


enum Weapon
{
	MELEE,
	RANGED
}



class = Weapon.MELEE

state = PlayerState.IDLE

facing = 1 // (1 LEFT), (-1 RIGHT)


xspd = 0;
yspd = 0;

movementSpeed = 1;
slowMultiplier = 0.5; // the value enemies set player movement speed to on-contact


// Stats // Player stats received from save files
strength = global.playerStrength // attack power
knockbackPower = global.playerKnockback // negative velocity applied to enemies (scales with enemy type)
baseMovementSpeed = global.playerSpeed // speed the player is reset to

attackDamage = 1 * strength
attackTimer = 0
attackRate = 0.5 * game_get_speed(gamespeed_fps)

walking = false

healthMax = 100
healthCurrent = 100

staggered = false // displays damage alert over health bar
debuff = debuffType.NONE
iFrames = false


collectionDistance = 36 // dependent on magnet accessory


moveLock = false

direction = 270;
speed = 0
friction = 0.2


draw_set_font(Determination)

instance_create_layer(x,y,"Invisible_Assets", objPlayerSpecialHitbox)