function interaction()
{
	global.cutsceneMovelock = true
	
	with (objPlayer)
	{
		state = PlayerState.CUTSCENE
		x = other.x;
		y = other.y;
	};
	
	fastTravelMenu()
};

promptOffsetX = 0
promptOffsetY = 18