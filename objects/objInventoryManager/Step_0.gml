//objInventoryManager Step

updateGridPositions();

// Hotbar selection - always active regardless of whether the panel is open
for (var i = 1; i <= 9; i++)
{
	if (keyboard_check_pressed(ord(string(i))))
	{
		hotbarIndex = i - 1;
	}
}
if (!objPlayer.showInventory)
{
	if (objPlayer.scroll_up)	hotbarIndex = (hotbarIndex - 1 + invColumns) mod invColumns
	if (objPlayer.scroll_down)	hotbarIndex = (hotbarIndex + 1) mod invColumns;
	
	// Q drop selected hotbar slot
	if keyboard_check_pressed(ord("Q")) && !(keyboard_check(vk_control))
	{
		var _hotbarSlotItem = inventory[invRows - 1][hotbarIndex];
		if (_hotbarSlotItem != noone)
		{
			dropItemSlot(inventory, invRows - 1, hotbarIndex);
		}
	}
	
	if keyboard_check_pressed(ord("Q")) && (keyboard_check(vk_control))
		{
		var _hotbarSlotItem = inventory[invRows - 1][hotbarIndex];
		if (_hotbarSlotItem != noone)
		{
			dropItemSlot(inventory, invRows - 1, hotbarIndex, _hotbarSlotItem.Count);
		}
	}
	
}

updateHotbarEquip();

var _showCrafting = (activeChest == noone) && craftingOpen;


if !(objPlayer.showInventory) exit;
// Inventory grid hover
selectedRow = -1;
selectedColumn = -1;
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

// Crafting grid hover — only when no chest is open
craftSelectedRow = -1;
craftSelectedColumn = -1;
if (_showCrafting)
{
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
}

// Chest grid hover — only when a chest is open
chestSelectedRow = -1;
chestSelectedColumn = -1;
if (activeChest != noone)
{
	for (var i = 0; i < activeChest.chestRows; i++)
	{
		for (var j = 0; j < activeChest.chestColumns; j++)
		{
			var _pos = getChestSlotPos(i, j);
			var _sx = _pos[0];
			var _sy = _pos[1];
			if (mouse_x > _sx-2 && mouse_x < _sx + slotW+2 && mouse_y > _sy-2 && mouse_y < _sy + slotH+2)
			{
				chestSelectedRow = i;
				chestSelectedColumn = j;
			}
		}
	}
}

var _hoveringOutput = _showCrafting && (mouse_x > outputSlotX-2 && mouse_x < outputSlotX + slotW+2 && mouse_y > outputSlotY-2 && mouse_y < outputSlotY + slotH+2);

// hovered slot
var _hoveredSlot = noone;
if (selectedRow != -1) _hoveredSlot = { grid: "inv", row: selectedRow, col: selectedColumn };
else if (craftSelectedRow != -1) _hoveredSlot = { grid: "craft", row: craftSelectedRow, col: craftSelectedColumn };
else if (activeChest != noone && chestSelectedRow != -1) _hoveredSlot = { grid: "chest", row: chestSelectedRow, col: chestSelectedColumn };

craftOutput = _showCrafting ? checkForRecipe() : noone;

// things Lefft mouse button
if (mouse_check_button_pressed(mb_left) && _hoveredSlot != noone && !keyboard_check(vk_shift))
{
	if (heldItem == noone)
	{
		var _item = getSlotItem(_hoveredSlot);
		heldItem = _item;
		setSlotItem(_hoveredSlot, noone);
	}
	else
	{
		dragMode = eDragMode.EVEN;
		dragStartSlot = _hoveredSlot;
		dragMoved = false;
		dragSlots = [];
		
		var _slotItem = getSlotItem(_hoveredSlot);
		if (_slotItem == noone || _slotItem.ItemID == heldItem.ItemID)
		{
			array_push(dragSlots, _hoveredSlot);
		}
	}
}

if (dragMode == eDragMode.EVEN && mouse_check_button(mb_left))
{
	if (_hoveredSlot != noone && !slotsEqual(_hoveredSlot, dragStartSlot))
	{
		dragMoved = true;
		
		var _alreadyIn = false;
		for (var k = 0; k < array_length(dragSlots); k++)
		{
			if (slotsEqual(dragSlots[k], _hoveredSlot)) { _alreadyIn = true; break; }
		}
		
		if (!_alreadyIn)
		{
			var _slotItem = getSlotItem(_hoveredSlot);
			if (_slotItem == noone || _slotItem.ItemID == heldItem.ItemID)
			{
				array_push(dragSlots, _hoveredSlot);
			}
		}
	}
}

// shift click shortcuts (eg. quick move)
if (keyboard_check(vk_shift) && mouse_check_button_pressed(mb_left) && _hoveredSlot != noone && heldItem == noone)
{
	shiftDragActive = true;
	quickMoveSlot(_hoveredSlot);
}

if (shiftDragActive && mouse_check_button(mb_left) && _hoveredSlot != noone)
{
	quickMoveSlot(_hoveredSlot);
}

if (shiftDragActive && mouse_check_button_released(mb_left))
{
	shiftDragActive = false;
}

if (dragMode == eDragMode.EVEN && mouse_check_button_released(mb_left))
{
	if (heldItem == noone)
	{
		dragMode = eDragMode.NONE;
		dragSlots = [];
		dragStartSlot = noone;
	}
	else if (!dragMoved)
	{
		var _slotItem = getSlotItem(dragStartSlot);
		
		if (_slotItem != noone && _slotItem.ItemID == heldItem.ItemID && _slotItem.Count < _slotItem.MaxStack)
		{
			var _space = _slotItem.MaxStack - _slotItem.Count;
			var _move = min(_space, heldItem.Count);
			
			_slotItem.Count += _move;
			heldItem.Count -= _move;
			
			if (heldItem.Count <= 0) heldItem = noone;
		}
		else
		{
			setSlotItem(dragStartSlot, heldItem);
			heldItem = _slotItem;
		}
	}
	else if (array_length(dragSlots) > 0)
	{
		var _n = array_length(dragSlots);
		var _perSlot = heldItem.Count div _n;
		var _remainder = heldItem.Count mod _n;
	
		for (var k = 0; k < _n; k++)
		{
			var _amount = _perSlot + (k < _remainder ? 1 : 0);
			if (_amount <= 0) continue;
		
			var _slot = dragSlots[k];
			var _slotItem = getSlotItem(_slot);
		
			if (_slotItem == noone)
			{
				var _place = min(_amount, heldItem.MaxStack);
				setSlotItem(_slot, cloneItem(heldItem, _place));
				heldItem.Count -= _place;
			}
			else
			{
				var _space = _slotItem.MaxStack - _slotItem.Count;
				var _move = min(_space, _amount);
				_slotItem.Count += _move;
				heldItem.Count -= _move;
			}
		}
	
		if (heldItem.Count <= 0) heldItem = noone;
	}
	
	dragMode = eDragMode.NONE;
	dragSlots = [];
	dragStartSlot = noone;
}

// right click - split half aand single-drag
if (mouse_check_button_pressed(mb_right) && _hoveredSlot != noone)
{
	if (heldItem == noone)
	{
		var _slotItem = getSlotItem(_hoveredSlot);
		
		if (_slotItem != noone)
		{
			var _half = ceil(_slotItem.Count / 2);
			
			heldItem = cloneItem(_slotItem, _half);
			_slotItem.Count -= _half;
			
			if (_slotItem.Count <= 0) setSlotItem(_hoveredSlot, noone);
		}
	}
	else
	{
		dragMode = eDragMode.SINGLE;
		dragSlots = [];
		place_single_item(_hoveredSlot);
	}
}

if (dragMode == eDragMode.SINGLE && mouse_check_button(mb_right) && _hoveredSlot != noone)
{
	var _alreadyIn = false;
	for (var k = 0; k < array_length(dragSlots); k++)
	{
		if (slotsEqual(dragSlots[k], _hoveredSlot)) { _alreadyIn = true; break; }
	}
	if (!_alreadyIn) place_single_item(_hoveredSlot);
}

if (dragMode == eDragMode.SINGLE && mouse_check_button_released(mb_right))
{
	dragMode = eDragMode.NONE;
	dragSlots = [];
}

// Q drop hovered slot
if (_hoveredSlot != noone && keyboard_check_pressed(ord("Q")))
{
	var _slotItem = getSlotItem(_hoveredSlot);
	if (_slotItem != noone && _hoveredSlot.grid != "chest")
	{
		var _arr = (_hoveredSlot.grid == "inv") ? inventory : craftInventory;
		dropItemSlot(_arr, _hoveredSlot.row, _hoveredSlot.col);
	}
}

// Output Slot
if (_showCrafting && _hoveringOutput && mouse_check_button_pressed(mb_left) && keyboard_check(vk_shift) && craftOutput != noone)
{
	while (craftOutput != noone)
	{
		var _crafted = cloneItem(craftOutput, craftOutput.Count);
		var _fullyMoved = addItemToInventory(_crafted);
		
		if (!_fullyMoved) break;
		
		consumeCraftIngredients();
		craftOutput = checkForRecipe();
	}
}
if (_showCrafting && _hoveringOutput && mouse_check_button_released(mb_left) && !keyboard_check(vk_shift) && craftOutput != noone)
{
	if (heldItem == noone)
	{
		heldItem = cloneItem(craftOutput, craftOutput.Count);
		consumeCraftIngredients();
		craftOutput = checkForRecipe();
	}
	else if (heldItem.ItemID == craftOutput.ItemID && heldItem.Count + craftOutput.Count <= heldItem.MaxStack)
	{
		heldItem.Count += craftOutput.Count;
		consumeCraftIngredients();
		craftOutput = checkForRecipe();
	}
}

//Drop on empty space
var _hoveringAnySlot = (_hoveredSlot != noone) || _hoveringOutput;

if (!_hoveringAnySlot && heldItem != noone && dragMode == eDragMode.NONE)
{
	if (mouse_check_button_released(mb_right))
	{
		dropItemHeld(1);
	}
	
	if (mouse_check_button_pressed(mb_left))
	{
		dropItemHeld(heldItem.Count);
	}
}

if (mouse_check_button_pressed(mb_middle))
{
	sortInventory();
	
	dragSlots = [];
	dragMoved = false;
	
	if (dragMode == eDragMode.EVEN)
	{
		dragStartSlot = _hoveredSlot;
		
		if (_hoveredSlot != noone)
		{
			var _slotItem = getSlotItem(_hoveredSlot);
			if (_slotItem == noone || _slotItem.ItemID == heldItem.ItemID)
			{
				array_push(dragSlots, _hoveredSlot);
			}
		}
	}
}