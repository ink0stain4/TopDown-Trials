var _conveyorList = ds_list_create();
var _instance_amount = instance_place_list(x, y, all, _conveyorList, false)

for (var i = 0; i < _instance_amount; ++i)
{
	var _target = _conveyorList[| i];
	
	if variable_instance_exists(_target, "is_airborne")
	{
		if (_target.is_airborne = true)
		continue
	}
	
	if asset_has_tags(_target.object_index, "Conveyable", asset_object)
	_target.x -=2
}

ds_list_destroy(_conveyorList);