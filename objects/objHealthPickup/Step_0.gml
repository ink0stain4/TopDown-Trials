if (distance_to_object(objPlayer) <= (objPlayer.playerRange /2))
{
	direction = point_direction(x, y, objPlayer.x, objPlayer.y-14)
	speed = lerp(speed, 5, 0.25)
	part_particles_create(global.partSystem, x, y, global.particleTypeHealthTrail, 2);
}
else
oscillate(0.2, 2)


if instance_place(x, y, objPlayerSpecialHitbox)
{
	healPlayer(objPlayer, healWorth)
	audio_play_sound(sndHeal, 1, false)
	
	instance_destroy()
}