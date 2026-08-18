global.camera_x = objPlayer.x - (camera_get_view_width(view_camera) / 2)
global.camera_y = objPlayer.y - (camera_get_view_height(view_camera) / 2)

var cam_w = camera_get_view_width(view_camera)
var cam_h = camera_get_view_height(view_camera)

var GameSpeed = game_get_speed(gamespeed_fps)

// -- shake: decay trauma, then derive angle + offset from it --
trauma = max(trauma - trauma_decay * (1 / GameSpeed), 0)
var _shake = trauma * trauma // quadratic ramp: subtle at low trauma, punchy at high

// two sine waves per axis at unrelated frequencies, summed — cheap stand-in for
// perlin noise, reads as chaotic shake instead of a metronome
var _t = current_time * 0.001 + shake_seed
var _noiseAngle	= (sin(_t * 13)        + sin(_t * 27.3)        * 0.5) / 1.5
var _noiseX		= (sin(_t * 19 + 100)  + sin(_t * 31.7 + 100)  * 0.5) / 1.5
var _noiseY		= (sin(_t * 23 + 200)  + sin(_t * 29.1 + 200)  * 0.5) / 1.5

angle = max_angle_shake * _shake * _noiseAngle
var shake_offset_x = max_offset_shake * _shake * _noiseX
var shake_offset_y = max_offset_shake * _shake * _noiseY

target_x = lerp(target_x, global.camera_x, 0.2)
target_y = lerp(target_y, global.camera_y, 0.2)

final_x = clamp(target_x + shake_offset_x, 0, room_width - cam_w)
final_y = clamp(target_y + shake_offset_y, 0, room_height - cam_h)
camera_set_view_pos(
					view_camera,
					final_x,
					final_y
					)

camera_set_view_angle(view_camera, angle)