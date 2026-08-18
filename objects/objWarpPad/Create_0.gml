anim_index = 0;
anim_speed = 0.05;

IdleTimeOnPlatform = 40	// frames
idleTimer = IdleTimeOnPlatform
PlatformInUse = false
ExhaustedTurn = false	// if player has already declined the platform once,
						// they should leave the platform and get back on it
						// to open the fast travel menu again.