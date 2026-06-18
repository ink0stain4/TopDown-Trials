function checkFullscreenShortcut()
{
	if keyboard_check_pressed(vk_f11)
		{
			window_set_fullscreen(!window_get_fullscreen())
			if (window_get_fullscreen() == false)
			{
				window_center()
			}
		}
}
	

function playerDie(){
	game_restart()
}

function takeDamage(_debuff, _amount){
	
	if !iFrames
	{
		self.debuff = _debuff
		self.healthCurrent -= _amount
		self.iFrames = true
		self.alarm[1] = game_get_speed(gamespeed_fps)
	}
	
}

function healPlayer(_target, _amount){
	
	if (_target.healthCurrent + _amount) > _target.healthMax
		_target.healthCurrent = _target.healthMax;
	else
		_target.healthCurrent = _target.healthCurrent + _amount;
}


function applyDamageFromPlayer(){
	enemyHealth -= objPlayer.attackDamage
	direction = point_direction(objPlayer.x, objPlayer.y, x, y)
	speed = objPlayer.knockbackPower - weight
	state = EnemyState.STUNNED
	instance_create_layer(x, y, "Attacks", objHitEffect)
	
}

function applyRangedDamageFromPlayer(){
	enemyHealth -= objPlayer.attackDamage
}


function dropSmallEXP(_multiplier)
{
	for (var i = 0; i < _multiplier; ++i) {
		instance_create_layer(x, y, "High_Instances", objEXPSmall)
	}
}

/// @description	Will use a sine wave to oscillate the object. Higher "_speed" will make oscillations faster, higher "_displacement" will make the object move further.
function oscillate(_speed, _displacement){
	y = ystart + dsin(current_time * _speed) * _displacement
	
}

function init_airborne_properties(_z_gravity = 0.4, _bounce_multiplier = 0.4) {
	z = 0;              // Current height above the ground (0 = on the ground)
	z_speed = 0;        // Vertical velocity on the fake Z axis
	z_gravity = _z_gravity; // How fast gravity pulls the object down
	z_bounce = _bounce_multiplier; // How much energy it keeps when landing (0 = no bounce)
	is_airborne = false; // Flag to easily check if the asset is in the air
}


function update_airborne_physics() {
	// Only run physics if the object is elevated or moving upward
	if (z > 0 || z_speed != 0) {
		is_airborne = true;

		z_speed -= z_gravity;	// Apply downward gravity force
		z += z_speed;			// Adjust current altitude

		// Check if the object has hit or passed below ground level (z <= 0)
		if (z <= 0) {
			z = 0; // Snap to ground floor

			// if it has enough force left, make it bounce
			if (abs(z_speed) > 1.5) {
				z_speed = -z_speed * z_bounce; // Reverse force and reduce it
			} else {
				z_speed = 0; // Come to a complete stop
				is_airborne = false;
			}
		}
	} else {
		is_airborne = false;
	}
}


function launch_airborne(_upward_force) {
	z_speed = _upward_force; // + fake visual height
	is_airborne = true;
}


function saveGame(){
	ini_open("save_file.ini")

		ini_write_real("Room", "Room", room)

		ini_write_real("Stats", "Money", global.playerMoney);
		ini_write_real("Stats", "Level", global.playerLevel);
		ini_write_real("Stats", "EXP", global.playerXP);
		ini_write_real("Stats", "NextLvlUp", global.expRequiredLvlUP);
		ini_write_real("Stats", "Strength", global.playerStrength);
		ini_write_real("Stats", "Knockback", global.playerKnockback);
		ini_write_real("Stats", "Speed", global.playerSpeed);
		
		ini_write_real("Coordinates", "x", objPlayer.x);
		ini_write_real("Coordinates", "y", objPlayer.y);

		ini_close()
}



function roomSetup()
{
	instance_create_layer(0, 0, "HUD_Elements", objHealthBar)
	instance_create_layer((camera_get_view_width(view_camera) - 8), 0, "HUD_Elements", objEXPBar)
}


function loadGame(){
	if file_exists("save_file.ini")
	{
		ini_open("save_file.ini")
	
		global.playerBenched = ini_read_real("PlayerState", "playerBenched", false)

		global.playerMoney		= ini_read_real("Stats", "Money", 0);
		global.playerLevel		= ini_read_real("Stats", "Level", 0);
		global.playerXP			= ini_read_real("Stats", "EXP", 0);
		global.expRequiredLvlUP = ini_read_real("Stats", "NextLvlUp", 100);
		global.playerStrength	= ini_read_real("Stats", "Strength", 25);
		global.playerSpeed	= ini_read_real("Stats", "Speed", 1);
		global.playerKnockback = ini_read_real("Stats", "Knockback", 3);
	
		playerSpawnX = ini_read_real("Coordinates", "x", 0);
		playerSpawnY = ini_read_real("Coordinates", "y", 0);
	
		targetRoom = (ini_read_real("Room", "Room", room))

		ini_close()
		
		instance_create_layer(playerSpawnX, playerSpawnY, "Instances", objPlayer)
		roomSetup()
		room_goto(targetRoom)
	} else
	{
		global.playerBenched = false
	
		global.playerMoney = 0
		global.playerLevel = 0
		global.playerXP = 0
		global.expRequiredLvlUP = 100
		global.playerStrength = 25
		global.playerSpeed = 1
		global.playerKnockback = 3
		
		playerSpawnX = 480 // Default Location for Game Beginning
		playerSpawnY = 336 // ^^^
		
		instance_create_layer(playerSpawnX, playerSpawnY, "Instances", objPlayer)
		roomSetup()
		room_goto_next()
	}
}


