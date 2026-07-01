var camera_x = objPlayer.x - (camera_get_view_width(view_camera) / 2)
var camera_y = objPlayer.y - (camera_get_view_height(view_camera) / 2)

if (alarm[0] << 0)
{
camera_x += (random_range(-2, 2) * (alarm[0] * 0.1))
camera_y += (random_range(-2, 2) * (alarm[0] * 0.1))
}

target_x = camera_x
target_y = camera_y

camera_set_view_pos(
					view_camera,
					clamp(target_x, 0, room_width - camera_get_view_width(view_camera)),
					clamp(target_y, 0, room_height - camera_get_view_height(view_camera))
					)

