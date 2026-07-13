if !(objPlayer.showInventory) exit;

// Inventory
selectedRow = -1
selectedColumn = -1;

// center the grid in camera
var _gridW = invColumns * pitchX - padding;
var _gridH = invRows * pitchY - padding;
gridX = camera_get_view_x(view_camera) + ((camera_get_view_width(view_camera) - _gridW) /2) + xOffsetInv;
gridY = camera_get_view_y(view_camera) + ((camera_get_view_height(view_camera) - _gridH) /2) + yOffsetInv;

for (var i = 0; i < invRows; i++)
{
	for (var j = 0; j < invColumns; j++)
	{
		var _pos = getSlotPos(i, j);
		var _sx = _pos[0];
		var _sy = _pos[1];
		
		if (mouse_x > _sx-2 && mouse_x < _sx + slotW+2 && mouse_y > _sy-2 && mouse_y < _sy + slotH+2)
		{
			selectedRow = i;
			selectedColumn = j;
		}
	}
}


// Crafting
var _craftGridW = craftColumns * pitchX - padding;
var _craftGridH = craftRows * pitchY - padding;
craftGridX = camera_get_view_x(view_camera) + ((camera_get_view_width(view_camera) - _craftGridW) /2) + xOffsetCraft;
craftGridY = camera_get_view_y(view_camera) + ((camera_get_view_height(view_camera) - _craftGridH) /2) + yOffsetCraft;

craftSelectedRow = -1;
craftSelectedColumn = -1;

for (var i = 0; i < craftRows; i++)
{
	for (var j = 0; j < craftColumns; j++)
	{
		var _pos = getCraftSlotPos(i, j);
		var _sx = _pos[0];
		var _sy = _pos[1];
		
		if (mouse_x > _sx-2 && mouse_x < _sx + slotW+2 && mouse_y > _sy-2 && mouse_y < _sy + slotH+2)
		{
			craftSelectedRow = i;
			craftSelectedColumn = j;
		}
	}
}

// Output
outputSlotX = craftGridX + (craftColumns * pitchX) + outputGapX;
outputSlotY = craftGridY + (_craftGridH - slotH) / 2;

var _hoveringOutput = (mouse_x > outputSlotX-2 && mouse_x < outputSlotX + slotW+2 && mouse_y > outputSlotY-2 && mouse_y < outputSlotY + slotH+2);
 

// --Input handling--

// Inventory Slots
if (selectedRow != -1)
{
	if (mouse_check_button_released(mb_left))
	{
		var _slotItem = inventory[selectedRow][selectedColumn];
		
		if (heldItem == noone)
		{
			heldItem = _slotItem;
			inventory[selectedRow][selectedColumn] = noone;
		}
		else
		{
			inventory[selectedRow][selectedColumn] = heldItem;
			heldItem = _slotItem;
		}
	}
	
	if (keyboard_check_pressed(ord("Q")) && (inventory[selectedRow][selectedColumn] != noone))
	{
		dropItemSlot(inventory, selectedRow, selectedColumn);
	}
	
	if (mouse_check_button_pressed(mb_right) && (inventory[selectedRow][selectedColumn] != noone))
	{
		inventory[selectedRow][selectedColumn].ItemEffect();
	}
}

// Crafting Slots
if (craftSelectedRow != -1)
{
	if (mouse_check_button_released(mb_left))
	{
		var _slotItem = craftInventory[craftSelectedRow][craftSelectedColumn];
		
		if (heldItem == noone)
		{
			heldItem = _slotItem;
			craftInventory[craftSelectedRow][craftSelectedColumn] = noone;
		}
		else
		{
			craftInventory[craftSelectedRow][craftSelectedColumn] = heldItem;
			heldItem = _slotItem;
		}
		
		craftOutput = checkForRecipe(); // grid changed, recheck for a match
	}
	
	if (keyboard_check_pressed(ord("Q")) && (craftInventory[craftSelectedRow][craftSelectedColumn] != noone))
	{
		dropItemSlot(craftInventory, craftSelectedRow, craftSelectedColumn);
		craftOutput = checkForRecipe();
	}
}

// Output Slot
if (_hoveringOutput && mouse_check_button_released(mb_left) && heldItem == noone && craftOutput != noone)
{
	heldItem = craftOutput
	
	for (var i = 0; i < craftRows; i++)
	{
		for (var j = 0; j < craftColumns; j++)
		{
			craftInventory[i][j] = noone;
		}
	}
	
	craftOutput = checkForRecipe();
}

// Drop on empty space
var _hoveringAnySlot = (selectedRow != -1) || (craftSelectedRow != -1) || _hoveringOutput;

if (!_hoveringAnySlot && mouse_check_button_released(mb_left) && heldItem != noone)
{
	dropItemHeld();
}