function interaction()
{
	if (instance_exists(objGridSystem))
	{
		var _pos = objGridSystem.worldToTile(x, y);
		objGridSystem.removeFromGrid(_pos.row, _pos.col);
	}
	instance_destroy()
	dropItemLoot(global.itemDictionary.stick, 1, false, true)
};

anim_index = 0;
anim_speed = 0.05; 