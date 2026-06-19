if !clickEnable
exit


if image_alpha <= 1
    {image_alpha += 0.2}
	
	
if mouse_check_button(mb_left)
{
	room_goto(rmStartMenu)
}