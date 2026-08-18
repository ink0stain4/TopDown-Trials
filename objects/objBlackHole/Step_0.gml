var _victimList = ds_list_create();
var _num = instance_place_list(x, y, all, _victimList, false);

for (var i = 0; i < _num; i++)
{
	var _victim = _victimList[| i];
	
	if (!asset_has_tags(_victim.object_index, "Pullable", asset_object)) continue;
	
	with (_victim)
	{
		var _dist = point_distance(x, y, other.x, other.y);
		if (_dist <= 0) continue;
		
		var _pullDir = point_direction(x, y, other.x, other.y);
		var _falloff = other.pullStrength / max(_dist, 4);
		
		var _radialX = lengthdir_x(_falloff, _pullDir);
		var _radialY = lengthdir_y(_falloff, _pullDir);
		
		var _swirlDir = _pullDir + 90;
		var _swirlMag = _falloff * other.swirlStrength;
		var _tangentX = lengthdir_x(_swirlMag, _swirlDir);
		var _tangentY = lengthdir_y(_swirlMag, _swirlDir);
		
		hspeed += _radialX + _tangentX;
		vspeed += _radialY + _tangentY;
		
		var _spd = point_distance(0, 0, hspeed, vspeed);
		if (_spd > other.maxPullSpeed)
		{
			var _dir = point_direction(0, 0, hspeed, vspeed);
			hspeed = lengthdir_x(other.maxPullSpeed, _dir);
			vspeed = lengthdir_y(other.maxPullSpeed, _dir);
		}
		
		if (variable_instance_exists(id, "Health"))
			Health -= (0.02 * objPlayer.attackDamage);
		if (variable_instance_exists(id, "state"))
			state = EnemyState.DISPLACED;
	}
}

ds_list_destroy(_victimList);