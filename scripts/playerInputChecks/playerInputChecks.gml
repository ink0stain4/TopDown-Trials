function playerInputChecks(){
	
	
	moveRight		= keyboard_check(ord("D"))
	moveLeft		= keyboard_check(ord("A"))
	moveUp			= keyboard_check(ord("W"))
	moveDown		= keyboard_check(ord("S"))
	
	interactPressed	= keyboard_check_pressed(vk_space)
	dashPressed		= keyboard_check_pressed(vk_shift)
	
	attackPressed	= mouse_check_button_pressed(mb_left)
	rollPressed		= mouse_check_button_pressed(mb_right)
	
	scrollUp		= mouse_wheel_up()
	scrollDown		= mouse_wheel_down()
	

}