var _targets = ds_list_create();
var _hitCount = instance_place_list(x, y, all, _targets, false);

speedPrev = speed;

for (var i = 0; i < _hitCount; ++i)
{
	var _target = _targets[| i];
	
	if (ds_list_find_index(hitList, _target) != -1)
	{
		continue;
	}
	
	if (!asset_has_tags(_target.object_index, "Damageable", asset_object))
	{
		continue;
	}
	
	if (variable_instance_exists(_target, "invulnerable") && _target.invulnerable)
	{
		continue;
	}
	
	_target.hurt = true;
	
	with (_target)
	{
		var finalDamage = (objPlayer.attackDamage/5) + (ceil(other.speedPrev / 5));
		applyRangedDamageFromPlayer(finalDamage); // ranged placeholder
	}
	
	ds_list_add(hitList, _target);
	
	if (!piercing)
	{
		ds_list_destroy(_targets);
		instance_destroy();
		return;
	}
}

ds_list_destroy(_targets);

if (instance_place(x, y, objBlackHole))
{
	refreshed = true;
}

if instance_place(x, y, objCollision)
{
	instance_destroy()
}



show_debug_message((objPlayer.attackDamage/5) + (ceil(other.speedPrev) / 5))