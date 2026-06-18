depth = objPlayer.depth + 1

var _hitList = ds_list_create();
var _instance_amount = instance_place_list(x, y, all, _hitList, false)

for (var i = 0; i < _instance_amount; ++i)
{
	var _target = _hitList[| i];
	
	if (variable_instance_exists(_target, "is_invulnerable"))
	{
		if (_target.is_invulnerable == true)
		{
			continue
		}
	}
	
	if asset_has_tags(_target.object_index, "Damageable", asset_object)
	{
		_target.hurt = true;
	
		with (_target)
		{
			applyDamageFromPlayer()
		}
	}
}

ds_list_destroy(_hitList);