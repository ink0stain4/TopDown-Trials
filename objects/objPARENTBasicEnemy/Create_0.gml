init_airborne_properties(0.5, 0.1)

iFrame_dur = 5

damageDebuff = debuffType.SLOWED
damageAmount = 25

enemyHealth = 20

invulnerable = false
hurt = false

expDropMultiplier = 4 // 1 = [1-2] 2 = [2-4]

weight = 1	// property that decides how significantly they are affected by knockback
			// [1 = light, 5 = heavy]
			// (this number is deducted from the knockback speed)

enum EnemyState
{
	ROAMING,
	AGGRO,
	STUNNED
}

state = EnemyState.ROAMING

speed = 0
direction = 0

air_friction = 0.1
ground_friction = 0.5

