global.camera_x = objPlayer.x - (camera_get_view_width(view_camera) / 2)
global.camera_y = objPlayer.y - (camera_get_view_height(view_camera) / 2)

if (alarm[0] >= 1)
{
angle += lerp(-dsin((current_time *  0.5) * (alarm[0])), dsin((current_time *  0.5) * (alarm[0])), 0.2)
} else 
{
angle = lerp(angle, 0, 0.8)
}


target_x = lerp(target_x, global.camera_x, 0.2)
target_y = lerp(target_y, global.camera_y, 0.2)



camera_set_view_pos(
					view_camera,
					clamp(target_x, 0, room_width - camera_get_view_width(view_camera)),
					clamp(target_y, 0, room_height - camera_get_view_height(view_camera))
					)

camera_set_view_angle(view_camera, angle)