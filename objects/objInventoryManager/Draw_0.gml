//objInventoryManager Draw

updateGridPositions(); // recalc fresh so a chest opened this frame draws in the right spot immediately

draw_set_colour(c_white)
draw_set_halign(fa_left)
draw_set_valign(fa_top)


// (the bottom inventory row is already visible there instead)
if (!objPlayer.showInventory) {
	if !instance_exists(objFadeIn) && !instance_exists(objFadeOut)
	{
	    var _hotbarW = invColumns * pitchX - padding; 
	    var _hotbarX = camera_get_view_x(view_camera) + (camera_get_view_width(view_camera) - _hotbarW) / 2; 
    
	    var _baseHotbarY = camera_get_view_y(view_camera) + (camera_get_view_height(view_camera) - pitchY - 4);
    
	    var playerOverlapHotbar = (objPlayer.y >= _baseHotbarY); 
		
	    var _targetRoom = playerOverlapHotbar ? 15 : 0; // Negative moves it up out of the way
    
	    makeRoomForPlayer = lerp(makeRoomForPlayer, _targetRoom, 0.1); 
    
	    var _hotbarY = _baseHotbarY + makeRoomForPlayer;

	    draw_sprite(sprHotbar, 0, _hotbarX, _hotbarY); 
    
	    // Draw the slots and items
	    for (var j = 0; j < invColumns; j++) { 
	        var _sx = _hotbarX + j * pitchX; 
	        var _slotColour = c_white; 
        
	        draw_sprite_ext(sprSlot, 0, _sx, _hotbarY, 1, 1, 0, _slotColour, 1); 
        
	        if (j == hotbarIndex) {
	            draw_sprite(sprSlotIndex, 0, _sx, _hotbarY); 
	        }
        
	        var _item = inventory[invRows - 1][j]; 
	        if (_item == noone) continue; 
        
	        drawItemAt(_item, _sx, _hotbarY); 
	    } 
	}
}


if !objPlayer.showInventory exit;


draw_set_valign(fa_top);
draw_set_colour(c_white)

var _showCrafting = (activeChest == noone) && craftingOpen;
var _showChestInv = (activeChest != noone);

var _bgSprite, _bgHeight;
if (_showCrafting)
{
	_bgSprite = sprBackground;
	_bgHeight = bgHeightCraft;
}
else if (_showChestInv)
{
	_bgSprite = sprBackgroundChestInv;
	_bgHeight = bgHeightChestInv;
}
else
{
	_bgSprite = sprBackgroundInvOnly;
	_bgHeight = bgHeightInvOnly;
}

var _bgX = gridX + (invColumns * pitchX - padding) / 2;
var _bgY = (gridY + (invRows * pitchY - padding) / 2) - (_bgHeight - bgHeightInvOnly) / 2;
draw_sprite_ext(_bgSprite, 0, _bgX, _bgY, 1, 1, 0, c_white, 1);

if (activeChest != noone)
{
	for (var i = 0; i < activeChest.chestRows; i++)
	{
		for (var j = 0; j < activeChest.chestColumns; j++)
		{
			var _pos = getChestSlotPos(i, j);
			var _sx = _pos[0];
			var _sy = _pos[1];
			var _slotColour = getSlotDragColour("chest", i, j, (i == chestSelectedRow && j == chestSelectedColumn));
			draw_sprite_ext(sprSlot, 0, _sx, _sy, 1, 1, 0, _slotColour, 1);
			var _item = activeChest.containerInventory[i][j];
			if (_item == noone) continue;
			drawItemAt(_item, _sx, _sy);
		}
	}
}

for (var i = 0; i < invRows; i++)
{
	for (var j = 0; j < invColumns; j++)
	{
		var _pos = getSlotPos(i, j);
		var _sx = _pos[0];
		var _sy = _pos[1];
		
		var _isHotbarSlot = (i == invRows - 1 && j == hotbarIndex);
		var _slotColour = getSlotDragColour("inv", i, j, (i == selectedRow && j == selectedColumn));
		draw_sprite_ext(sprSlot, 0, _sx, _sy, 1, 1, 0, _slotColour, 1);
		
		var _item = inventory[i][j];
		if (_item == noone) continue;
		drawItemAt(_item, _sx, _sy);
	}
}

if (_showCrafting)
{
	for (var i = 0; i < craftRows; i++)
	{
		for (var j = 0; j < craftColumns; j++)
		{
			var _pos = getCraftSlotPos(i, j);
			var _sx = _pos[0];
			var _sy = _pos[1];
			
			var _slotColour = getSlotDragColour("craft", i, j, (i == craftSelectedRow && j == craftSelectedColumn));
			draw_sprite_ext(sprSlot, 0, _sx, _sy, 1, 1, 0, _slotColour, 1);
			
			var _item = craftInventory[i][j];
			if (_item == noone) continue;
			
			drawItemAt(_item, _sx, _sy);
		}
	}
	
	draw_sprite_ext(sprSlot, 0, outputSlotX, outputSlotY, 1, 1, 0, c_white, 1);
	if (craftOutput != noone)
	{
		drawItemAt(craftOutput, outputSlotX, outputSlotY);
	}
}

if (heldItem != noone)
{
	draw_sprite(heldItem.SlotSprite, 0, mouse_x, mouse_y);
	
	if (heldItem.Count > 1)
	{
		draw_set_halign(fa_right);
		draw_set_valign(fa_bottom);
		draw_text(mouse_x + slotW/2, mouse_y + slotH/2, string(heldItem.Count));
		draw_set_halign(fa_left);
		draw_set_valign(fa_top);
	}
}
draw_set_colour(c_white)
