//playerInteractChecks.gml

function playerInteractChecks()
{
	if global.cutsceneMovelock exit;
	if instance_exists(objMenu) exit;
	
	if (state == PlayerState.IDLE || state == PlayerState.WALKING) // figure out a way to make these 2 only let the function happen
	{
		
	
		var _list = ds_list_create();
		var _num = collision_rectangle_list
						(
							x - interactDistance,
							y - interactDistance,
							x + interactDistance,
							y + interactDistance,
							all,
							false,
							false,
							_list,
							false
						);
						
		for (var i = 0; i < _num; i++)
		{
			var _inst = _list[| i ];
		
			if (asset_has_tags(_inst.object_index, "Interactable", asset_object))
			{
				interactableInRange = _inst;
				
				if interactPressed
					{
						state = PlayerState.IDLE
						_inst.interaction()

						
					}
					
					break;
			}
		}
	
		ds_list_destroy(_list);
	}
}



