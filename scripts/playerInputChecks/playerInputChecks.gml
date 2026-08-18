
//playerInputChecks.gml

function playerInputChecks(){
	if ((instance_exists(objMenu)) || (global.cutsceneMovelock) || (showInventory) || (equipmentOpen))
	{
		global.playerBusy = true
	} else
	{
		global.playerBusy = false
	}
	
	if (global.playerBusy)
	{
		moveRight		= 0
		moveLeft		= 0
		moveUp			= 0
		moveDown		= 0
		
		interactPressed	= 0
		dashPressed		= 0
		
		dropItemPressed = 0
	
		attackPressed	= 0
		rollPressed		= 0
	
		scroll_up		= 0
		scroll_down		= 0
	exit
	}
	
	moveRight		= keyboard_check(ord("D"))
	moveLeft		= keyboard_check(ord("A"))
	moveUp			= keyboard_check(ord("W"))
	moveDown		= keyboard_check(ord("S"))
	
	interactPressed	= keyboard_check_pressed(vk_space)
	rollPressed		= keyboard_check_pressed(vk_shift)

	dropItemPressed = keyboard_check_pressed(ord("Q"))
	
	attackPressed	= mouse_check_button_pressed(mb_left)
	
	scroll_up		= mouse_wheel_up()
	scroll_down		= mouse_wheel_down()
	
	
// CHANGE PLAYER FACING DIRECTION
if state != PlayerState.ROLL
{
	if (mouse_x >= x)
	{
		facing = -1
	} else
	facing = 1
}

	

}