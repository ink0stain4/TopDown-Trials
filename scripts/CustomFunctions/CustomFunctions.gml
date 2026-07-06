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
	
	game_restart();
};


function cameraShake(_duration){
	with objCameraManager
	{
		alarm[0] = _duration
	}
}



function takeDamage(_debuff, _amount){
	
	if (state == PlayerState.ROLL)
	exit;
	
	if (!iFrames)
	{
		id.debuff = _debuff;
		id.healthCurrent -= _amount;
		id.iFrames = true;
		id.alarm[1] = game_get_speed(gamespeed_fps);
		audio_play_sound(sndEnemyHurt, 1, false, 1, 0, random_range(0.8, 1.2))
		cameraShake(5)
		
		with objHealthBar
		{
			part_particles_create(global.partSystemHUD, random_range(bbox_left + healthbarX, bbox_right + healthbarX), random_range(bbox_top + healthbarY, bbox_bottom + healthbarY), global.particleTypeHealthLoss, 24)
		};
		
	};
	
};

function healPlayer(_target, _amount){
	
	if (_target.healthCurrent + _amount) > global.healthMax
	{
		_target.healthCurrent = global.healthMax;
	}
	else
	{
		_target.healthCurrent = _target.healthCurrent + _amount;
	}
	
	with objHealthBar
	{
		part_particles_create(global.partSystemHUD, random_range(bbox_left + healthbarX, bbox_right + healthbarX), random_range(bbox_top + healthbarY, bbox_bottom + healthbarY), global.particleTypeHealthGain, 16)
	}
}


function applyDamageFromPlayer(){

	var _relativeToPlayer = point_direction(objPlayer.x, objPlayer.y, x, y)
	var _particleSpread = 30
	
	enemyHealth -= objPlayer.attackDamage
	direction = _relativeToPlayer
	speed = objPlayer.knockbackPower - weight
	// state = EnemyState.STUNNED
	instance_create_layer(x, y - (bbox_bottom - bbox_top)/2, "Attacks", objHitEffect)
	part_type_direction(global.particleTypeBasic, _relativeToPlayer, _relativeToPlayer + 30, 0, 0); //knockback
	part_particles_create(global.partSystem, x, y, global.particleTypeBasic, 6);

}

function applyRangedDamageFromPlayer(){
	enemyHealth -= objPlayer.attackDamage
	part_type_direction(global.particleTypeBasic, 0, 360, 0, 0); //knockback
	part_particles_create(global.partSystem, x, y, global.particleTypeBasic, 6);
}


function dropSmallEXP(_multiplier)
{
	for (var i = 0; i < _multiplier; ++i) {
		instance_create_layer(x, y, "Instances", objEXPSmall)
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



#region Menu Functions

function menu(_x, _y, _options, _description = -1)
{
	with (instance_create_layer(_x, _y, "HUD_Elements", objMenu))
	{
		options = _options;
		description = _description;
		optionsCount = array_length(_options);
		hovermarker = "* ";
		
		// Set up size
		margin = 9;
		draw_set_font(fontSmall);
		
		width = 1;
		if (description != -1) width = max(width, string_width(_description));
		for (var i = 0; i < optionsCount; i++)
		{
			width = max(width, string_width(_options[i][0]));
		}
		width += string_width(hovermarker);
		
		heightLine = 17;
		height = heightLine * (optionsCount + !(description == -1));
		
		widthFull = width + margin * 2;
		heightFull = height + margin * 2;
	}
}
		
		
function mainMenu()
{
	if file_exists("save_file.ini")
		menu
		(
			0,
			0,
			[
				["Continue", loadGame],
				["New Game", newGame],
				["Quit", function()
							{quitAsk(mainMenu)}]
			],
			"Main Menu"
		);
	else
		menu
		(
			0,
			0,
			[
				["New Game", loadGame],
				["Quit", function()
							{quitAsk(mainMenu)}]
			],
			"Main Menu"
		);
}


function quitAsk(_prevMenu = -1)
{
	menu (0, 0,
	[
		["Yes", game_end],
		["No", _prevMenu]
	],
	"Are you sure?");
}


function pauseMenu()
{
	menu (0, 0,		
		[
			["Resume", -1],
			["Stats", -1],
			["Equipment", -1],
			["Save Game", saveGame],
			["Quit to Title", function()
								{quitAsk(game_restart())}]
		],
		"Menu"
	);
}


#endregion


function saveGame(){
	ini_open("save_file.ini")

		ini_write_real("Room", "Room", room)

		ini_write_real("Stats", "Health", global.healthMax);
		ini_write_real("Stats", "Stamina", global.staminaMax);
		ini_write_real("Stats", "Money", global.playerMoney);
		ini_write_real("Stats", "Level", global.playerLevel);
		ini_write_real("Stats", "EXP", global.playerXP);
		ini_write_real("Stats", "NextLvlUp", global.expRequiredLvlUP);
		ini_write_real("Stats", "Strength", global.playerStrength);
		ini_write_real("Stats", "Knockback", global.playerKnockback);
		ini_write_real("Stats", "Speed", global.playerSpeed);
		
		ini_write_real("Config", "SFX", global.SFX_vol)
		ini_write_real("Config", "Music", global.Music_vol)
			
		ini_write_real("Coordinates", "x", objPlayer.x);
		ini_write_real("Coordinates", "y", objPlayer.y);

		ini_close()
		
}



function roomSetup()
{
	instance_create_layer(0, 0, "HUD_Elements", objHealthBar)
	instance_create_layer(0, 0, "HUD_Elements", objStaminaBar)
	
	instance_create_layer((camera_get_view_width(view_camera) - 16), 0, "HUD_Elements", objEXPBar)
}


function loadGame(){
	if file_exists("save_file.ini")
	{
		ini_open("save_file.ini")
	
		global.playerBenched = ini_read_real("PlayerState", "playerBenched", false)

		global.healthMax		= ini_read_real("Stats", "Health", 100);
		global.staminaMax		= ini_read_real("Stats", "Stamina", 20);
		global.playerMoney		= ini_read_real("Stats", "Money", 0);
		global.playerLevel		= ini_read_real("Stats", "Level", 0);
		global.playerXP			= ini_read_real("Stats", "EXP", 0);
		global.expRequiredLvlUP = ini_read_real("Stats", "NextLvlUp", 100);
		global.playerStrength	= ini_read_real("Stats", "Strength", 5);
		global.playerSpeed		= ini_read_real("Stats", "Speed", 1);
		global.playerKnockback	= ini_read_real("Stats", "Knockback", 4);
		
		global.SFX_vol			= ini_read_real("Config", "SFX", 1);
		global.Music_vol		= ini_read_real("Config", "Music", 1);
		
		if (!audio_group_is_loaded(SFX))
			{
				audio_group_load(SFX)
			}
		if (!audio_group_is_loaded(Music))
			{
				audio_group_load(Music)
			}
		
		audio_group_set_gain(SFX, global.SFX_vol)
		audio_group_set_gain(Music, global.Music_vol)
	
	
		playerSpawnX = ini_read_real("Coordinates", "x", 0);
		playerSpawnY = ini_read_real("Coordinates", "y", 0);
	
		targetRoom = (ini_read_real("Room", "Room", Room1))

		ini_close()
		
		
		instance_create_layer(playerSpawnX, playerSpawnY, "Instances", objPlayer)
		roomSetup()
		room_goto(targetRoom)
	} else
	{
		global.playerBenched = false
	
		global.healthMax = 100
		global.staminaMax = 20
		global.playerMoney = 0
		global.playerLevel = 0
		global.playerXP = 0
		global.expRequiredLvlUP = 100
		global.playerStrength = 5
		global.playerSpeed = 1
		global.playerKnockback = 4
		
		global.SFX_vol = 1
		global.Music_vol = 1
		
		if (!audio_group_is_loaded(SFX))
		{
			audio_group_load(SFX)
		}
		if (!audio_group_is_loaded(Music))
		{
			audio_group_load(Music)
		}

		
		playerSpawnX = 480 // Default Location for Game Beginning
		playerSpawnY = 336 // ^^^
		
		audio_group_set_gain(SFX, 0.5)
		audio_group_set_gain(Music, 0.5)
		
		instance_create_layer(playerSpawnX, playerSpawnY, "Instances", objPlayer)
		roomSetup()
		room_goto(Room1)
	}
}


function newGame()
{
	if file_exists("save_file.ini")
	{
		file_delete("save_file.ini")
		loadGame()
	}
}