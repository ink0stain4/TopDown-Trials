depth = objPlayer.depth + 1

var _hitList = ds_list_create();
var _instance_amount = instance_place_list(x, y, all, _hitList, false)

for (var i = 0; i < _instance_amount; ++i)
{
	var _target = _hitList[| i];
	
	if (variable_instance_exists(_target, "invulnerable"))
	{
		if (_target.invulnerable == true)
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
			audio_play_sound(sndEnemyHurt, 1, false, 1, 0, random_range(0.8, 1.2))
		}
	}
}

ds_list_destroy(_hitList);