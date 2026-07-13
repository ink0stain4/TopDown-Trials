if !objPlayer.showInventory exit;

var _bgX = gridX + (invColumns * pitchX - padding) / 2;
var _bgY = gridY + (invRows * pitchY - padding) / 2;
draw_sprite_ext(sprInventoryBackground, 0, _bgX, _bgY, 11, 5, 0, c_white, 1)

var _cbgX = craftGridX + (craftColumns * pitchX - padding) / 2;
var _cbgY = craftGridY + (craftRows * pitchY - padding) / 2;
draw_sprite_ext(sprInventoryBackground, 0, _cbgX, _cbgY, 4, 4, 0, c_white, 1)
	
for (var i = 0; i < invRows; i++)
{
	for (var j = 0; j < invColumns; j++)
	{
		var _pos = getSlotPos(i, j);
		var _sx = _pos[0];
		var _sy = _pos[1];
		
		var _slotColour = (i == selectedRow && j == selectedColumn) ? c_ltgrey : c_white;
		draw_sprite_ext(sprInventorySlot, 0, _sx, _sy, 1, 1, 0, _slotColour, 1);
		
		var _item = inventory[i][j];
		if (_item == noone) continue;

		draw_sprite(_item.ItemSprite, 0, _sx + (slotW / 2), _sy + (slotH / 2));
	}
}

for (var i = 0; i < craftRows; i++)
{
	for (var j = 0; j < craftColumns; j++)
	{
		var _pos = getCraftSlotPos(i, j);
		var _sx = _pos[0];
		var _sy = _pos[1];
		
		var _slotColour = (i == craftSelectedRow && j == craftSelectedColumn) ? c_ltgrey : c_white;
		draw_sprite_ext(sprInventorySlot, 0, _sx, _sy, 1, 1, 0, _slotColour, 1);
		
		var _item = craftInventory[i][j];
		if (_item == noone) continue;
		
		draw_sprite(_item.ItemSprite, 0, _sx + (slotW / 2), _sy + (slotH / 2));
	}
}

draw_sprite_ext(sprInventorySlot, 0, outputSlotX, outputSlotY, 1, 1, 0, c_white, 1);

if (craftOutput != noone)
{
	draw_sprite(craftOutput.ItemSprite, 0, outputSlotX + slotW/2, outputSlotY + slotH/2);
}

if (heldItem != noone)
{
	draw_sprite(heldItem.ItemSprite, 0, mouse_x, mouse_y);
}

draw_set_colour(c_white)
