if keyboard_check(vk_escape)
{
	hold++
} else
hold--

hold = clamp(hold, 0, 30)



//show_debug_message(string(hold))

if keyboard_check_released(vk_escape)
{
	hold = (5)
	image_speed = 0
	image_index = 0
}