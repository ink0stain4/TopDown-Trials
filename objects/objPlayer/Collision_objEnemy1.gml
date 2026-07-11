if (state = PlayerState.FADEIN) || (state = PlayerState.FADEOUT)
exit;

if (other.z >= 10) // if the enemy is NOT in the air, damage player on contact
exit;

takeDamage(other.damageDebuff, other.damageAmount)
