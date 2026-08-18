if startUp
exit


var _targetDir = point_direction(x, y, objPlayer.x, objPlayer.y - 14);

if !overdue
direction += angle_difference(_targetDir, direction) * 0.15;
else
direction = _targetDir;

speed = lerp(speed, MagnetSpeed, 0.03)
part_particles_create(global.partSystem, x, y, global.particleTypeExpTrail, 1);


if instance_place(x, y, objPlayerSpecialHitbox)
{
	global.playerXP += expWorth
	objEXPBar.toastXPBar = true
	audio_play_sound(sndXPOrb, 1, false, 1, 0, random_range(0.6, 1.2))
	
	with objPlayerSpecialHitbox
	{
		part_particles_create(global.partSystemHUD, random_range(x + (sprite_width / 2), x - (sprite_width / 2)), random_range(y + (sprite_height / 2), y - (sprite_height / 2)), global.particleTypeExpBar, 1)
	}
	instance_destroy()
}