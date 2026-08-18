//objConveyor Step
if (UpdateBreakableConveyor()) exit; // belt was just mined - don't run belt logic on a dying instance


var _dx = 0, _dy = 0;
switch (Direction)
{
	case "left":  _dx = -1; break;
	case "right": _dx =  1; break;
	case "up":    _dy = -1; break;
	case "down":  _dy =  1; break;
}

// pick up loose, conveyable item gems sitting on any empty tile of the belt
for (var i = 0; i < array_length(BeltTiles); i++)
{
	if (Slots[i] != noone) continue;
	
	var _t = BeltTiles[i];
	var _pos = objGridSystem.tileToWorld(_t.row, _t.col);
	
	var _gem = collision_rectangle(_pos.x, _pos.y, _pos.x + objGridSystem.TileSize, _pos.y + objGridSystem.TileSize, objItemGem, false, true);
	if (_gem == noone) continue;
	if (_gem.alarm[0] > 0) continue; // respect the spill cooldown
	if (!asset_has_tags(_gem.object_index, "Conveyable", asset_object)) continue;
	
	Slots[i] = { item: _gem.item, progress: 0 };
	instance_destroy(_gem);
}

// pull from a container sitting behind the belt's input tile
if (Slots[0] == noone)
{
	var _startTile = BeltTiles[0];
	var _prevRow = _startTile.row - _dy;
	var _prevCol = _startTile.col - _dx;
	
	if (objGridSystem.isTileInBounds(_prevRow, _prevCol))
	{
		var _prev = objGridSystem.TileGrid[_prevRow][_prevCol];
		if (_prev != noone && variable_instance_exists(_prev, "containerInventory"))
		{
			var _pulled = extractItemFromContainer(_prev); // ASSUMPTION - see below
			if (_pulled != noone) Slots[0] = { item: _pulled, progress: 0 };
		}
	}
}

// advance items back-to-front so nothing overtakes the slot ahead of it
for (var i = array_length(Slots) - 1; i >= 0; i--)
{
	if (Slots[i] == noone) continue;
	var _slot = Slots[i];
	
	if (i == array_length(Slots) - 1)
	{
		_slot.progress += Speed;
		if (_slot.progress >= 1)
		{
			if (tryConveyorOutput(_slot))   // pass the slot, not just the item
				Slots[i] = noone;
			else
				_slot.progress = 1; // jammed at the end
		}
	}
	else if (Slots[i + 1] == noone)
	{
		_slot.progress += Speed;
		if (_slot.progress >= 1)
		{
			Slots[i + 1] = { item: _slot.item, progress: 0 };
			Slots[i] = noone;
		}
	}
}

function tryConveyorOutput(_slot)
{
	var _item = _slot.item;
	
	var _dx = 0, _dy = 0;
	switch (Direction)
	{
		case "left":  _dx = -1; break;
		case "right": _dx =  1; break;
		case "up":    _dy = -1; break;
		case "down":  _dy =  1; break;
	}
	
	var _endTile = BeltTiles[array_length(BeltTiles) - 1];
	var _nextRow = _endTile.row + _dy;
	var _nextCol = _endTile.col + _dx;
	
	var _next = noone;
	if (objGridSystem.isTileInBounds(_nextRow, _nextCol))
		_next = objGridSystem.TileGrid[_nextRow][_nextCol];
	
	if (_next != noone && variable_instance_exists(_next, "BeltTiles"))
	{
		for (var i = 0; i < array_length(_next.BeltTiles); i++)
		{
			var _t = _next.BeltTiles[i];
			if (_t.row == _nextRow && _t.col == _nextCol)
			{
				if (_next.Slots[i] != noone) return false; // downstream tile occupied - hold here
				_next.Slots[i] = { item: _item, progress: 0 };
				return true;
			}
		}
	}
	else if (_next != noone && variable_instance_exists(_next, "containerInventory"))
	{
		if (insertItemIntoContainer(_next, _item)) return true;
		return false; // container full - hold here
	}
	
	// nothing downstream (open air / out of bounds) - pop out as a gem from
	// wherever it's currently drawn (i.e. the far edge of the end tile,
	// same formula Draw uses), with a bit of momentum away from the belt
	var _pos = objGridSystem.tileToWorld(_endTile.row, _endTile.col);
	var _spawnX = _pos.x + objGridSystem.TileSize / 2 + (_dx * objGridSystem.TileSize * _slot.progress);
	var _spawnY = _pos.y + objGridSystem.TileSize / 2 + (_dy * objGridSystem.TileSize * _slot.progress);
	
	var _gem = instance_create_layer(_spawnX, _spawnY, "Instances", objItemGem, { item: _item });
	_gem.alarm[0] = 15;
	_gem.hspeed = _dx * 1.5;
	_gem.vspeed = _dy * 1.5;
	return true;
}