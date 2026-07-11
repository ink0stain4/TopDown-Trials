function itemGain(_item, _amount = 1)
{
	for (var i = 0; i < _amount; i++)
		array_push(objInventoryManager.inventory, _item);
}


function dropItem(_index, _amount = 1)
{
	var _item = objInventoryManager.inventory[_index];
	var _gem = instance_create_layer(objPlayer.x, objPlayer.y, "Instances", objItemGem, { item: _item });
	
	with (_gem)
	{
		direction = point_direction(objPlayer.x, objPlayer.y, mouse_x, mouse_y);
		speed = 4;
		friction = 0.2;

		
		item = objInventoryManager.inventory[objInventoryManager.selected_item];
	}
	
	array_delete(objInventoryManager.inventory, _index, _amount)
}