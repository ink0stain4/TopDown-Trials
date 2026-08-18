//objPlayer Create

//init_airborne_properties(0.3, 0)

equippedWeapon = Weapon.MELEE // type of weapon currently held

facing = 1 // (1 LEFT), (-1 RIGHT)


xspd = 0;
yspd = 0;

target_x = 0 // For teleporting
target_y = 0 // ^^

scroll_up = 0
scroll_down = 0

movementSpeed = 0.5;
slowMultiplier = 0.5; // the value enemies set player movement speed to on-contact

interactDistance = 10 // hard-set magic number for the player's interact distance
BreakSpeed = 0 // changes with equipped tool

showInventory = false
equipmentOpen = false

// Stats // Player stats received from save files
strength = global.playerStrength // attack power
knockbackPower = global.playerKnockback // negative velocity applied to enemies (scales with enemy type)
baseMovementSpeed = global.playerSpeed // speed the player is reset to


swordPower = 0 // Default
attackDamage = (strength * swordPower)
attackTimer = 0
attackRate = 0.5 * game_get_speed(gamespeed_fps)

walking = false

healthCurrent = global.healthMax
previousHealth = healthCurrent

staminaCurrent = global.staminaMax
staminaRecharge = 5 // make changeable dependent on equipment

staggered = false // displays damage alert over health bar
debuff = debuffType.NONE
iFrames = false


#region Trinket variables
playerRange = 34 // dependent on magnet accessory
playerTileReach = 36
thorns = false // ^^
#endregion


moveLock = false

direction = 270;
speed = 0
DefaultFriction = 0.2
friction = DefaultFriction

global.cutsceneMovelock = true

instance_create_layer // Handles pickup collection, eg. health orbs, EXP orbs, items, etc.
					(
					x,y,
					"Instances",
					objPlayerSpecialHitbox
					)
					

