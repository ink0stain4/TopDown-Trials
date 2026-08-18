if (destroyed)
{
	instance_destroy();
}

if instance_place(x, y, objBasicAttackHB) || instance_place(x, y, objRangedAttackBullet)
	stage++;
	
if (stage >= 4)
{
	destroyed = true;
}
