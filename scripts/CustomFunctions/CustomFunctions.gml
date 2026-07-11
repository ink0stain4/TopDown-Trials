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



function takeDamage(_debuff = -1, _amount){
	
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



function saveAlert()
{
	// show_debug_message("save should appear ig");
	instance_create_layer(0, 0, "HUD_Elements", objGameSaved)
}



#region Menu Functions

function menu(_x_offset, _y_offset, _options, _description = -1)
{
	with (instance_create_layer(0, 0, "HUD_Elements", objMenu))
	{
		options = _options;
		description = _description;
		optionsCount = array_length(_options);
		hovermarker = "* ";
		x_offset = _x_offset;
		y_offset = _y_offset;
		
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
		(0, 0,
			[
				["Continue", loadGame],
				["New Game", newGame],
				["Quit", function()
							{areYouSure(game_end, mainMenu)}]
			],
			"Main Menu"
		);
	else
		menu
		(0, 0,
			[
				["New Game", loadGame],
				["Quit", function()
							{areYouSure(game_end, mainMenu)}]
			],
			"Main Menu"
		);
}


function areYouSure(_targetFunction = -1, _prevMenu = -1)
{
	menu (0, 0,
	[
		["Yes", _targetFunction],
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
								{areYouSure(game_restart, pauseMenu)}]
		],
		"Menu"
	);
}




function fastTravelMenu()
{
	var leftSideScreen = (-camera_get_view_width(view_camera) / 2);
	var xOffset = 40;
	var yOffset = 0;
	
	var menuOptions = [];
	
	for (var i = 1; i <= 10; i++)
	{
		if (global.Location[i] == true)
		{
			//dynamic function that remembers the "i" count to apply to the location ID
			var _travelFunction = method({ loc_id: i }, function()
			{
				travelToLocation(loc_id);
			});
			
			show_debug_message(string(_travelFunction))

			array_push(menuOptions, ["Location " + string(i), _travelFunction]);
		}
	}
	
	array_push(menuOptions, ["Cancel", -1]);

	menu(
		leftSideScreen + xOffset,	// x
		0 + yOffset,				// y
		menuOptions,				// done in array ^^
		
		"Fast Travel"
	);
}

function travelToLocation(_id)
{
	with objPlayer
	{	
		switch(_id)
		{
			case 1:
				{
					targetRoom = Room1;
					state = PlayerState.FADEOUT;
					show_debug_message("targetRoom = " + string(targetRoom));
					target_x = 432
					target_y = 288
				}
			break;
		
			case 2:
				{
					targetRoom = Room2;
					state = PlayerState.FADEOUT;
					show_debug_message("targetRoom = " + string(targetRoom));
					target_x = 376;
					target_y = 136;
				}
			break;
		
			case 3:
			// room_goto(Room1)
			// x = ((room start position))
			// y = ((room start position))
			break;

			case 4:
			// room_goto(Room1)
			// x = ((room start position))
			// y = ((room start position))
			break;
		
			case 5:
			// room_goto(Room1)
			// x = ((room start position))
			// y = ((room start position))
			break;
		
			case 6:
			// room_goto(Room1)
			// x = ((room start position))
			// y = ((room start position))
			break;
		
			case 7:
			// room_goto(Room1)
			// x = ((room start position))
			// y = ((room start position))
			break;
		
			case 8:
			// room_goto(Room1)
			// x = ((room start position))
			// y = ((room start position))
			break;

			case 9:
			// room_goto(Room1)
			// x = ((room start position))
			// y = ((room start position))
			break;
		
			case 10:
			// room_goto(Room1)
			// x = ((room start position))
			// y = ((room start position))
			break;

		}
		
	}
}


#endregion





#region // save system

function saveGame(){
	ini_open("save_file.ini")
	
	var write_int = function(section, key, value)
	{
		ini_write_string(section, key, string_format(value, 0, 0));
	}

		write_int("Room", "Room", room)

		write_int("Stats", "Health", global.healthMax);
		write_int("Stats", "Stamina", global.staminaMax);
		write_int("Stats", "Money", global.playerMoney);
		write_int("Stats", "Level", global.playerLevel);
		write_int("Stats", "EXP", global.playerXP);
		write_int("Stats", "NextLvlUp", global.expRequiredLvlUP);
		write_int("Stats", "Strength", global.playerStrength);
		write_int("Stats", "Knockback", global.playerKnockback);
		write_int("Stats", "Speed", global.playerSpeed);
		
		ini_write_real("Config", "SFX", global.SFX_vol)
		ini_write_real("Config", "Music", global.Music_vol)
			
		write_int("Coordinates", "x", objPlayer.x);
		write_int("Coordinates", "y", objPlayer.y);
		
		
		// Unlocked fast travel locations
		write_int("Locations", "Location 1", global.Location[1]);
		write_int("Locations", "Location 2", global.Location[2]);
		write_int("Locations", "Location 3", global.Location[3]);
		write_int("Locations", "Location 4", global.Location[4]);
		write_int("Locations", "Location 5", global.Location[5]);
		write_int("Locations", "Location 6", global.Location[6]);
		write_int("Locations", "Location 7", global.Location[7]);
		write_int("Locations", "Location 8", global.Location[8]);
		write_int("Locations", "Location 9", global.Location[9]);
		write_int("Locations", "Location 10", global.Location[10]);
		


		ini_close()
		
		saveAlert()
		
}



function roomSetup()
{
	if !instance_exists(objHealthBar)
	instance_create_layer(0, 0, "HUD_Elements", objHealthBar)
	
	if !instance_exists(objStaminaBar)
	instance_create_layer(0, 0, "HUD_Elements", objStaminaBar)

	
	if !instance_exists(objEXPBar)
	instance_create_layer((camera_get_view_width(view_camera) - 16), 0, "HUD_Elements", objEXPBar)
	
	
	objPlayer.state = PlayerState.FADEIN
}

function spawnPlayerAndSetup(_spawnX, _spawnY, _room)
{
	if !instance_exists(objPlayer)
	with instance_create_layer(_spawnX, _spawnY, "Instances", objPlayer)
	{
		targetRoom = _room
		target_x = _spawnX
		target_y = _spawnY
	}
	
	instance_create_depth(_spawnX, _spawnY, -999999, objFadeIn)
	//show_debug_message("fading in!!")
	room_goto(rmInit)
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
		
		
		global.Location[1]		= ini_read_real("Locations", "Location 1", false);
		global.Location[2]		= ini_read_real("Locations", "Location 2", false);
		global.Location[3]		= ini_read_real("Locations", "Location 3", false);
		global.Location[4]		= ini_read_real("Locations", "Location 4", false);
		global.Location[5]		= ini_read_real("Locations", "Location 5", false);
		global.Location[6]		= ini_read_real("Locations", "Location 6", false);
		global.Location[7]		= ini_read_real("Locations", "Location 7", false);
		global.Location[8]		= ini_read_real("Locations", "Location 8", false);
		global.Location[9]		= ini_read_real("Locations", "Location 9", false);
		global.Location[10]		= ini_read_real("Locations", "Location 10", false);
		
		ini_close()
		
		spawnPlayerAndSetup(playerSpawnX, playerSpawnY, targetRoom)
		
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
		
		global.Location[1] = false
		global.Location[2] = false
		global.Location[3] = false
		global.Location[4] = false
		global.Location[5] = false
		global.Location[6] = false
		global.Location[7] = false
		global.Location[8] = false
		global.Location[9] = false
		global.Location[10] = false
		
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
		
		targetRoom = (Room1)
		audio_group_set_gain(SFX, 0.5)
		audio_group_set_gain(Music, 0.5)
		
		spawnPlayerAndSetup(playerSpawnX, playerSpawnY, targetRoom)
	}
}




function newGame()
{
	if file_exists("save_file.ini")
	{
		file_delete("save_file.ini")
		loadGame()
	} else
	menu(0, 0,
	[
		["Ok", game_restart]
	],
	
	"File not found"
	)
}

#endregion