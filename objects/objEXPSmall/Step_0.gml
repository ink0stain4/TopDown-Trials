if startUp
exit

if (distance_to_object(objPlayer) <= objPlayer.collectionDistance)
{
	direction = point_direction(x, y, objPlayer.x, objPlayer.y-14)
	speed = lerp(speed, 5, 0.25)
	part_particles_create(global.partSystem, x, y, global.particleTypeExpTrail, 1);
}



if instance_place(x, y, objPlayerSpecialHitbox)
{
	global.playerXP += expWorth
	objEXPBar.toastXPBar = true
	audio_play_sound(sndXPOrb, 1, false, 1, 0, random_range(0.6, 1.2))
	
	with objPlayerSpecialHitbox
	{
		part_particles_create(global.partSystemHUD, random_range(x + (sprite_width / 2), x - (sprite_width / 2)), random_range(y + (sprite_height / 2), y - (sprite_height / 2)), global.particleTypeExpBar, 3)
	}
	instance_destroy()
}