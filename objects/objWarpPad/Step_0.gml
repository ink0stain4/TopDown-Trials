anim_index += anim_speed;
if (anim_index >= sprite_get_number(sprPrompt_Space)) {
	anim_index = 0;
}

var _player = instance_place(x, y, objPlayer);

// Player stepped off the pad -> full reset
if (_player == noone)
{
	idleTimer = IdleTimeOnPlatform;
	PlatformInUse = false;
	ExhaustedTurn = false;
	exit;
}

// Count down only while the player is idle; pauses otherwise
if (!PlatformInUse)
{
	if (_player.state == PlayerState.IDLE)
	{
		idleTimer -= 1;
		if (idleTimer <= 0)
		{
			PlatformInUse = true;
			show_debug_message("On the platform now");
		}
	}
	// else: player is moving/acting -> timer just holds where it is
}

if (ExhaustedTurn) exit;

if (PlatformInUse)
{
	_player.x = lerp(_player.x, x, 0.08);
	_player.y = lerp(_player.y, y, 0.08);
	_player.sprite_index = sprPlayerWalk;
	


    if (point_distance(_player.x, _player.y, x, y) < 0.5)
	{
		_player.sprite_index = sprPlayer;
		_player.x = x;
		_player.y = y;
		fastTravelMenu();
		ExhaustedTurn = true;
	}
}