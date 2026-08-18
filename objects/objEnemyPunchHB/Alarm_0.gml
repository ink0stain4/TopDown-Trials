if place_meeting(x, y, objPlayerSpecialHitbox)
{
	with objPlayer
	takeDamage(other.EnemyDamage, other.DamageDebuff, true, thorns)
}
instance_destroy()