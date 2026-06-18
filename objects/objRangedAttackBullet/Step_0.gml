var _enemiesHit = instance_place(x, y, objPARENTBasicEnemy)

with _enemiesHit
{
	if !invulnerable
	{
		hurt = true
		applyRangedDamageFromPlayer()
		
		var bulletInstance = instance_place(x, y, objRangedAttackBullet)
		with bulletInstance
		{
			instance_destroy()
		}
	}
}