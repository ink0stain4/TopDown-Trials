//objGridSystem Create
TileSize = 16;
PendingConveyor = noone; // { row, col, itemId } while awaiting the second click

if (!variable_global_exists("placedTiles")) global.placedTiles = {};

// TileGrid / TileRows / TileColumns / roomKey are (re)built in the Room Start
// event instead of here, since objGridSystem is persistent and Create only
// ever runs once - Room Start re-fires every time a new room loads.

function createTile(_id, _name, _desc, _spr, _dropItem, _isMachine = false, _objectIndex = noone, _energyStorage = 0) constructor
{
	ItemID = _id;
	TileName = _name;
	TileDesc = _desc;
	TileSprite = _spr;
	DropItem = _dropItem;
	isMachine = _isMachine;
	objectIndex = _objectIndex;
	EnergyStorage = _energyStorage;
}



global.tileDictionary = 
{
	#region Special Blocks
	chest: new createTile(
		"chest",
		"Wooden Chest",
		"Storage!",
		sprChestItem,
		"chest",
		true,
		objChest
		),
		
	craftingtable: new createTile(
		"craftingtable",
		"Crafting Table",
		"The beginning.",
		sprCraftingItem,
		"craftingtable",
		true,
		objCraftingTable
		),
		
	trashcan: new createTile(
		"trashcan",
		"Trash Can",
		"NOT a recycling bin!",
		sprTrash,
		"trashcan",
		true,
		objTrash
		),
		
		#region Conveyor
		conveyor: new createTile(
			"conveyor",
			"Conveyor Belt",
			"Place 2 in a straight line, up to 12 tiles away.",
			sprConveyorLeft1,
			"conveyor",
			true,
			objConveyorBelt
			),



		#endregion
	#endregion
	
	#region Basic Blocks
	wood: new createTile(
		"wood",
		"Log Block",
		"Morning.",
		sprWoodBlock,
		"wood",
		true,
		objWood
		)
		,
		
	#endregion
	
	#region Nature
	twig: new createTile(
		"twig",
		"Twig",
		"Harvestable",
		sprRockWorld,
		"rock",
		true,
		objTwig
		),
		
	stone: new createTile(
		"stone",
		"Stone",
		"Harvestable",
		sprRockWorld,
		"rock",
		true,
		objRock
		),
		
};

init_recipes() // load crafting recipe library


function createTileInstance(_row, _col, _tileId)
{
	var _def = global.tileDictionary[$ _tileId];
	
	//if (_def.isMachine)
	//{
	var _pos = tileToWorld(_row, _col);
	var _inst = instance_create_layer(_pos.x, _pos.y, "Instances", _def.objectIndex);
	_inst.TileID = _tileId;
	TileGrid[_row][_col] = _inst;
		
	with (_inst) event_perform(ev_other, ev_room_start);
}

// Player places a NEW tile - registers it so it persists on future room visits.
function placeTile(_row, _col, _tileId)
{
	if (!isTileInBounds(_row, _col)) return false;
	if (TileGrid[_row][_col] != noone) return false;
	
	createTileInstance(_row, _col, _tileId);
	array_push(global.placedTiles[$ roomKey], { row: _row, col: _col, tileId: _tileId });
	
	if (instance_exists(objPathGridManager)) objPathGridManager.rebuild_path_grid();
	
	return true;
}


function placeTempTile(_row, _col, _tileId)
{
	if (!isTileInBounds(_row, _col)) return false;
	if (TileGrid[_row][_col] != noone) return false;
	
	createTileInstance(_row, _col, _tileId);
	
	if (instance_exists(objPathGridManager)) objPathGridManager.rebuild_path_grid();
	
	return true;
}

// Recreates a tile that was already placed in a previous visit - does NOT
// register it again, it's already in global.placedTiles.
function restoreTile(_row, _col, _tileId)
{
	createTileInstance(_row, _col, _tileId);
}

function breakTile(_row, _col)
{
	if (!isTileInBounds(_row, _col)) return noone;
	
	var _tile = TileGrid[_row][_col];
	if (_tile == noone) return noone;
	
	if (!is_string(_tile) && variable_instance_exists(_tile, "BeltTiles"))
	{
		return breakConveyorBelt(_tile);
	}
	
	var _tileId, _dropX, _dropY;
	
	if (is_string(_tile))
	{
		_tileId = _tile;
		var _worldPos = tileToWorld(_row, _col);
		_dropX = _worldPos.x;
		_dropY = _worldPos.y;
	}
	else
	{
		_tileId = _tile.TileID;
		_dropX = _tile.x;
		_dropY = _tile.y;
		instance_destroy(_tile); // any content-specific dump (chest items etc.) is the caller's job, done BEFORE calling this
	}
	
	TileGrid[_row][_col] = noone;
	
	// forget this room's persisted record of the placement
	var _placed = global.placedTiles[$ roomKey];
	for (var i = 0; i < array_length(_placed); i++)
	{
		if (_placed[i].row == _row && _placed[i].col == _col)
		{
			array_delete(_placed, i, 1);
			break;
		}
	}
	
	// drop the placeable item itself
	with (instance_create_layer(_dropX, _dropY, "Instances", objItemGem))
	{
		item = cloneItem(global.itemDictionary[$ _tileId], 1);
	}
	
	if (instance_exists(objPathGridManager)) objPathGridManager.rebuild_path_grid();
	
	return _tileId;
}


function worldToTile(_x, _y)
{
	return { row: floor(_y / TileSize), col: floor(_x / TileSize) };
}

function tileToWorld(_row, _col)
{
	return { x: _col * TileSize, y: _row * TileSize };
}

function isTileInBounds(_row, _col)
{
	return (_row >= 0 && _row < TileRows && _col >= 0 && _col < TileColumns);
}

// Is this tile close enough to the player to place on / interact with?
// Measured from the player to the tile's centre, against objPlayer.playerTileReach.
function isTileInRange(_row, _col)
{
	var _pos = tileToWorld(_row, _col);
	var _cx = _pos.x + TileSize/2;
	var _cy = _pos.y + TileSize/2;
	
	return (point_distance(objPlayerSpecialHitbox.x, objPlayerSpecialHitbox.y, _cx, _cy) <= objPlayer.playerTileReach);
}

// Given a world-space point (typically the mouse), returns the tile to act
// on: the tile under that point if it's within reach, otherwise the tile at
// the furthest reachable spot along the line from the player toward it.
// Lets the player aim past their max range and still place at the edge of it,
// instead of the action just failing.
function getReachableTile(_x, _y)
{
	var _px = objPlayerSpecialHitbox.x;
	var _py = objPlayerSpecialHitbox.y;
	var _range = objPlayer.playerTileReach;
	
	if (point_distance(_px, _py, _x, _y) <= _range)
	{
		return worldToTile(_x, _y);
	}
	
	var _dir = point_direction(_px, _py, _x, _y);
	var _cx = _px + lengthdir_x(_range, _dir);
	var _cy = _py + lengthdir_y(_range, _dir);
	
	return worldToTile(_cx, _cy);
}

// Clears a grid cell + its persisted record, if any exists. Safe to call
// even if this cell was never grid-tracked to begin with (e.g. a chest
// placed directly in the room editor) - just does nothing in that case.
function removeFromGrid(_row, _col)
{
	if (!isTileInBounds(_row, _col)) return;
	
	TileGrid[_row][_col] = noone;
	
	var _placed = global.placedTiles[$ roomKey];
	for (var i = 0; i < array_length(_placed); i++)
	{
		if (_placed[i].row == _row && _placed[i].col == _col)
		{
			array_delete(_placed, i, 1);
			break;
		}
	}
	
	if (instance_exists(objPathGridManager)) objPathGridManager.rebuild_path_grid();
}


// Places a straight belt from (_row1,_col1) to (_row2,_col2) inclusive.
// Caller must have already validated the span is straight, in bounds, ≤12 tiles, and empty.
function placeConveyorBelt(_row1, _col1, _row2, _col2, _tileId)
{
	if (!createConveyorBeltInstance(_row1, _col1, _row2, _col2, _tileId)) return false;

	array_push(global.placedTiles[$ roomKey], {
		row: _row1, col: _col1,
		row2: _row2, col2: _col2,
		tileId: _tileId
	});

	return true;
}

// Recreates a belt that was already placed in a previous visit - does NOT
// register it again, it's already in global.placedTiles.
function restoreConveyorBelt(_row1, _col1, _row2, _col2, _tileId)
{
	return createConveyorBeltInstance(_row1, _col1, _row2, _col2, _tileId);
}

// Shared instance-creation logic, no save-record bookkeeping.
function createConveyorBeltInstance(_row1, _col1, _row2, _col2, _tileId)
{
	var _def = global.tileDictionary[$ _tileId];

	var _dir;
	if (_row1 == _row2)
		_dir = (_col2 > _col1) ? "right" : "left";
	else
		_dir = (_row2 > _row1) ? "down" : "up";

	var _rowStep = sign(_row2 - _row1);
	var _colStep = sign(_col2 - _col1);

	var _tiles = [];
	var _r = _row1, _c = _col1;
	while (true)
	{
		array_push(_tiles, { row: _r, col: _c });
		if (_r == _row2 && _c == _col2) break;
		_r += _rowStep;
		_c += _colStep;
	}

	var _startPos = tileToWorld(_row1, _col1);
	var _inst = instance_create_layer(_startPos.x, _startPos.y, "Instances", _def.objectIndex);
	_inst.TileID = _tileId;
	_inst.Direction = _dir;
	_inst.BeltTiles = _tiles;
	_inst.initBeltSlots();

	for (var i = 0; i < array_length(_tiles); i++)
	{
		TileGrid[_tiles[i].row][_tiles[i].col] = _inst;
	}

	with (_inst) event_perform(ev_other, ev_room_start);

	if (instance_exists(objPathGridManager)) objPathGridManager.rebuild_path_grid();

	return true;
}

// Whole belt breaks together: every carried item drops as a loose gem,
// every grid cell it occupied is cleared, then the belt item itself drops.
function breakConveyorBelt(_inst)
{
	var _tileId = _inst.TileID;
	var _tiles = _inst.BeltTiles;
	
	for (var i = 0; i < array_length(_inst.Slots); i++)
	{
		var _slot = _inst.Slots[i];
		if (_slot == noone) continue;
	
		var _pos = tileToWorld(_tiles[i].row, _tiles[i].col);
		instance_create_layer(_pos.x, _pos.y, "Instances", objItemGem, { item: _slot.item });
	}
	
	for (var i = 0; i < array_length(_tiles); i++)
	{
		TileGrid[_tiles[i].row][_tiles[i].col] = noone;
	}
	
	var _placed = global.placedTiles[$ roomKey];
	var _anchor = _tiles[0];
	for (var i = 0; i < array_length(_placed); i++)
	{
		var _p = _placed[i];
		if (variable_struct_exists(_p, "row2") && _p.row == _anchor.row && _p.col == _anchor.col)
		{
			array_delete(_placed, i, 1);
			break;
		}
	}
	
	var _dropX = _inst.x, _dropY = _inst.y;
	instance_destroy(_inst);
	
	with (instance_create_layer(_dropX, _dropY, "Instances", objItemGem))
	{
		item = cloneItem(global.itemDictionary[$ _tileId], 1);
	}
	
	if (instance_exists(objPathGridManager)) objPathGridManager.rebuild_path_grid();
	
	return _tileId;
}