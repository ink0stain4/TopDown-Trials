///@description Menu Exists Check?
if instance_exists(objMenu) exit;
if state = PlayerState.FADEIN exit;
if state = PlayerState.FADEOUT exit;

global.cutsceneMovelock = false

