//objGridSystem Room Start
// (Re)build the tile grid for THIS room, then repopulate it with anything
// already occupying a tile - both objects placed via the room editor and
// tiles restored from a previous visit - so placeTile() can never place a
// new tile on top of either.
PendingConveyor = noone; // resetting per room so u cheeky shit dont try to break my game.

TileRows = ceil(room_height / TileSize);
TileColumns = ceil(room_width / TileSize);

TileGrid = array_create(TileRows);
for (var i = 0; i < TileRows; i++)
{
	TileGrid[i] = array_create(TileColumns, noone);
}


var _current_rules = global.room_properties[$ room_get_name(room)];

if (_current_rules.nature_spawn == true)
{spawnAtRandomTileInRoom(irandom_range(6, 10))} // Spawn nature collectables


roomKey = room_get_name(room);
if (!variable_struct_exists(global.placedTiles, roomKey))
{
	global.placedTiles[$ roomKey] = []; // array of { row, col, tileId }
}

// Register anything already sitting in the room (placed via the room editor)
function registerRoomEditorTiles()
{
	var _tileIds = variable_struct_get_names(global.tileDictionary);
	for (var t = 0; t < array_length(_tileIds); t++)
	{
		var _id = _tileIds[t];
		var _def = global.tileDictionary[$ _id];
		if (_def.objectIndex == noone) continue;
		
		with (_def.objectIndex)
		{
			// skip anything already grid-tracked (shouldn't happen here, but
			// guards against re-processing if this ever gets called twice)
			if (variable_instance_exists(id, "TileID")) continue;
			
			// snap to the grid - protects against imprecise room-editor placement
			x = round(x / other.TileSize) * other.TileSize;
			y = round(y / other.TileSize) * other.TileSize;
			
			var _tilePos = other.worldToTile(x, y);
			
			if (!other.isTileInBounds(_tilePos.row, _tilePos.col))
			{
				if (global.debug) show_debug_message($"[Grid] {object_get_name(object_index)} at ({x},{y}) placed outside grid bounds.");
				continue;
			}
			
			if (other.TileGrid[_tilePos.row][_tilePos.col] != noone)
			{
				if (global.debug) show_debug_message($"[Grid] {object_get_name(object_index)} at tile ({_tilePos.row},{_tilePos.col}) overlaps another grid object - staying live but untracked.");
				continue;
			}
			
			TileID = _id;
			other.TileGrid[_tilePos.row][_tilePos.col] = id;
		}
	}
}

registerRoomEditorTiles();

// Recreate anything placed dynamically on a previous visit to this room
var _placed = global.placedTiles[$ roomKey];
for (var i = 0; i < array_length(_placed); i++)
{
	var _p = _placed[i];
	if (variable_struct_exists(_p, "row2"))
		restoreConveyorBelt(_p.row, _p.col, _p.row2, _p.col2, _p.tileId);
	else
		restoreTile(_p.row, _p.col, _p.tileId);
}