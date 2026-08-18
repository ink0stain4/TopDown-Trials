//objGridSystem Draw
// Placement only happens via right-click while the inventory panel is
// closed (see objInventoryManager Step), so only show the outline then.
if (!objPlayer.showInventory)
{
	if (PendingConveyor != noone)
	{
		drawConveyorPlacementPreview();
	}
	else
	{
		var _hotbarItem = objInventoryManager.inventory[3][objInventoryManager.hotbarIndex];
		if (_hotbarItem != noone && variable_struct_exists(global.tileDictionary, _hotbarItem.ItemID))
		{
			var _tile = getReachableTile(mouse_x, mouse_y);
			if (isTileInBounds(_tile.row, _tile.col))
			{
				var _pos = tileToWorld(_tile.row, _tile.col);
				var _occupied = (TileGrid[_tile.row][_tile.col] != noone);
				draw_set_color(_occupied ? c_red : c_lime);
				draw_rectangle(_pos.x, _pos.y, _pos.x + TileSize, _pos.y + TileSize, true);
				draw_set_color(c_white);
			}
		}
	}
}