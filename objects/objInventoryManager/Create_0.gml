//objInventoryManager Create

depth = -9999999

enum eDragMode
{
	NONE,
	EVEN, // left drag- commit on release
	SINGLE // right click- single distribution, commit per-slot
}


function getSlotItem(_slot)
{
	switch (_slot.grid)
	{
		case "inv":   return inventory[_slot.row][_slot.col];
		case "craft": return craftInventory[_slot.row][_slot.col];
		case "chest": return activeChest.containerInventory[_slot.row][_slot.col];
	}
}

function setSlotItem(_slot, _item)
{
	switch (_slot.grid)
	{
		case "inv":   inventory[_slot.row][_slot.col] = _item; break;
		case "craft": craftInventory[_slot.row][_slot.col] = _item; break;
		case "chest": activeChest.containerInventory[_slot.row][_slot.col] = _item; break;
	}
}

function slotsEqual(_a, _b)
{
	if (_a == noone || _b == noone) return (_a == _b);
	return (_a.grid == _b.grid && _a.row == _b.row && _a.col == _b.col);
}

function place_single_item(_slot)
{
	if (objInventoryManager.heldItem == noone) return;
	
	var _slotItem = getSlotItem(_slot);
	
	if (_slotItem == noone)
	{
		setSlotItem(_slot, cloneItem(objInventoryManager.heldItem, 1));
		objInventoryManager.heldItem.Count -= 1;
	}
	else if (_slotItem.ItemID == objInventoryManager.heldItem.ItemID && _slotItem.Count < _slotItem.MaxStack)
	{
		_slotItem.Count += 1;
		objInventoryManager.heldItem.Count -= 1;
	}
	else
	{
		return; // incompatible
	}
	
	array_push(objInventoryManager.dragSlots, _slot);
	
	if (objInventoryManager.heldItem.Count <= 0)
	{
		objInventoryManager.heldItem = noone;
		objInventoryManager.dragMode = eDragMode.NONE;
		objInventoryManager.dragSlots = [];
	}
}


function addItemToGrid(_item, _arr, _rows, _cols, _rowOrder = noone)
{
	if (_item == noone || _item.Count <= 0) return true;
	
	// visit rows in this order (e.g. hotbar row first); defaults to top-to-bottom
	var _order = _rowOrder;
	if (_order == noone)
	{
		_order = array_create(_rows);
		for (var r = 0; r < _rows; r++) _order[r] = r;
	}
	
	// Pass 1: top up existing matching stacks
	for (var oi = 0; oi < _rows; oi++)
	{
		var i = _order[oi];
		for (var j = 0; j < _cols; j++)
		{
			var _slotItem = _arr[i][j];
			if (_slotItem == noone) continue;
			if (_slotItem.ItemID != _item.ItemID) continue;
			if (_slotItem.Count >= _slotItem.MaxStack) continue;
			
			var _space = _slotItem.MaxStack - _slotItem.Count;
			var _move = min(_space, _item.Count);
			
			_slotItem.Count += _move;
			_item.Count -= _move;
			
			if (_item.Count <= 0) return true;
		}
	}
	
	// Pass 2: fall back to empty slots
	for (var oi = 0; oi < _rows; oi++)
	{
		var i = _order[oi];
		for (var j = 0; j < _cols; j++)
		{
			if (_arr[i][j] != noone) continue;
			
			var _place = min(_item.Count, _item.MaxStack);
			_arr[i][j] = cloneItem(_item, _place);
			_item.Count -= _place;
			
			if (_item.Count <= 0) return true;
		}
	}
	
	return (_item.Count <= 0);
}

// Row visiting order for the player inventory: hotbar row (bottom) first,
// then the rest top-to-bottom - so new items land in/top-up the hotbar first.
function getInvRowOrder()
{
	var _order = array_create(invRows);
	_order[0] = invRows - 1;
	var _k = 1;
	for (var r = 0; r < invRows - 1; r++)
	{
		_order[_k] = r;
		_k += 1;
	}
	return _order;
}

// Shift-click sends a slot's item to whichever grid makes sense given current context:
//	craft slot				-> player inventory (existing quickMoveCraftSlot)
//	chest slot				-> player inventory
//	inv slot = chest open	-> chest inventory
//	inv slot = no chest	-> no-op (nowhere else for it to go)
function quickMoveSlot(_slot)
{
	if (_slot.grid == "craft")
	{
		quickMoveCraftSlot(_slot);
		return;
	}
	
	if (_slot.grid == "chest")
	{
		var _item = getSlotItem(_slot);
		if (_item == noone) return;
		
		var _fullyMoved = addItemToGrid(_item, inventory, invRows, invColumns, getInvRowOrder());
		setSlotItem(_slot, _fullyMoved ? noone : _item);
		return;
	}
	
	if (_slot.grid == "inv" && activeChest != noone)
	{
		var _item = getSlotItem(_slot);
		if (_item == noone) return;
		
		var _fullyMoved = addItemToGrid(_item, activeChest.containerInventory, activeChest.chestRows, activeChest.chestColumns);
		setSlotItem(_slot, _fullyMoved ? noone : _item);
		return;
	}
	
	// inv slot with no chest open — nothing to quick-move into
}


// item constructor
function createItem(_id, _name, _desc, _spr, _slotSpr = _spr, _type = "misc", _smeltable = false, _stats = -1, _effect = -1, _maxStack = 64) constructor
{
	ItemID = _id;
	ItemName = _name;
	ItemDesc = _desc;
	ItemSprite = _spr;
	SlotSprite = _slotSpr;
	ItemType = _type; // "melee", "food", "key", "block"
	Smeltable = _smeltable;
	Stats = _stats;
	ItemEffect = _effect;
	MaxStack = _maxStack;
	Count = 1;
}

global.itemDictionary = 
{
	#region Consumables

	burger : new createItem(
		"burger",
		"Burger",
		"It's a buger, YIPPEE!!!",
		sprBurger,
		sprBurger,
		"food",
		false,
		-1,
		
		function()
		{
			healPlayer(objPlayer, 20);
			var _slot = inventory[selectedRow][selectedColumn];
			_slot.Count -= 1;
			if (_slot.Count <= 0) inventory[selectedRow][selectedColumn] = noone;
		}
	),
		
		
	apple : new createItem(
		"apple",
		"Apple",
		"Doctor-Immunity",
		sprApple,
		sprApple,
		"food",
		false,
		-1,
		function()
		{
			healPlayer(objPlayer, 10);
			var _slot = inventory[selectedRow][selectedColumn];
			_slot.Count -= 1;
			if (_slot.Count <= 0) inventory[selectedRow][selectedColumn] = noone;
		}
	),
		
	#endregion
	
	#region Placeables
	
	wood : new createItem(
		"wood",
		"Wood",
		"Crafting material",
		sprWoodBlock,
		sprWood,
		"block"
	),
	
	craftingtable : new createItem(
		"craftingtable",
		"Crafting Table",
		"The beginning.",
		sprCrafting,
		sprCraftingItem,
		"block"
	),
	
	trashcan : new createItem(
		"trashcan",
		"Trash Can",
		"NOT a recycling bin.",
		sprTrash,
		sprTrashItem,
		"block"
	),
	
	chest : new createItem(
		"chest",
		"Wooden Chest",
		"Storage!",
		sprChest,
		sprChestItem,
		"block"
	),
	
	conveyor : new createItem(
		"conveyor",
		"Conveyor Belt",
		"Automation!",
		sprConveyorItem,
		sprConveyorItem,
		"block"
	),
	
	#endregion
		
	#region Materials
	
	stick : new createItem(
		"stick",
		"Stick",
		"Crafting material",
		sprStick,
		sprStick,
		"melee",
		false,
		global.SwordStats.stick
		),
		
	flint : new createItem(
		"flint",
		"Flint",
		"Crafting material",
		sprFlint,
		sprFlint,
		"material",
		false,
		),
		
	rock : new createItem(
		"rock",
		"Rock",
		"Crafting material",
		sprRock,
		sprRock,
		"material",
		false,
		),
		
	iron_bar : new createItem(
		"iron_bar",
		"Iron Bar",
		"Sturdy, malleable, useful.",
		sprIron,
		sprIron,
		"material",
		false,
		),
		
	gold_bar : new createItem(
		"gold_bar",
		"Gold Bar",
		"More valuable, therefore stronger.",
		sprGold,
		sprGold,
		"material",
		false,
		),
		
	conductive_powder : new createItem(
		"conductive_powder",
		"Conductive Powder",
		"It buzzes in your hand.",
		sprConductivePowder,
		sprConductivePowder,
		"material",
		false,
		),
		
	#endregion
		
	#region Weapons
		
	sword_wooden : new createItem(
		"sword_wooden",
		"Wooden Sword",
		"Beginner friendly. Gets the job done.",
		sprWoodenSword,
		sprWoodenSwordSlot,
		"melee",
		false,
		global.SwordStats.swordWooden,
		-1,
		1
	),
		
	sword_stone : new createItem(
		"sword_stone",
		"Stone Sword",
		"Now we're getting somewhere.",
		sprStoneSword,
		sprStoneSwordSlot,
		"melee",
		false,
		global.SwordStats.swordStone,
		-1,
		1
	),
		
	sword_iron : new createItem(
		"sword_iron",
		"Iron Sword",
		"The ideal sword.",
		sprIronSword,
		sprIronSwordSlot,
		"melee",
		false,
		global.SwordStats.swordIron,
		-1,
		1
	),
		
		
	sword_gold: new createItem(
		"sword_gold",
		"Gold Sword",
		"Stronger.",
		sprGoldSword,
		sprGoldSwordSlot,
		"melee",
		false,
		global.SwordStats.swordGold,
		-1,
		1
	),
		
	#endregion
		
	#region Tools
	
	pickaxe_wooden : new createItem(
		"pickaxe_wooden",
		"Wooden Pickaxe",
		"Breaks things, albeit slowly.",
		sprWoodPickaxe,
		sprWoodPickaxe,
		"tools",
		false,
		global.ToolStats.pickaxeWooden,
		-1,
		1
	),
		
	pickaxe_stone : new createItem(
		"pickaxe_stone",
		"Stone Pickaxe",
		"Stone Vs. Stone.",
		sprStonePickaxe,
		sprStonePickaxe,
		"tools",
		false,
		global.ToolStats.pickaxeStone,
		-1,
		1
	),
		
	pickaxe_iron : new createItem(
		"pickaxe_iron",
		"Iron Pickaxe",
		"this is what they're SUPPOSED to be made out of...",
		sprIronPickaxe,
		sprIronPickaxe,
		"tools",
		false,
		global.ToolStats.pickaxeIron,
		-1,
		1
	),
		
	#endregion
		
	#region Trinkets
		
	magnet : new createItem(
		"magnet",
		"Magnet",
		"Most of these items aren't even magnetic...",
		sprMagnet,
		sprMagnet,
		"trinket",
		false,
		{
			onEquip: function() { playerRange = 52; },
			onUnequip: function() { playerRange = 36; }
		},
		-1,
		1
	),
	
	thorn_ring : new createItem(
		"thorn_ring",
		"Thorn Ring",
		"They get what they deserve",
		sprThornRing,
		sprThornRing,
		"trinket",
		false,
		{
			onEquip: function() { thorns = true; },
			onUnequip: function() { thorns = false; },
		},
		-1,
		1
	),
	
	#endregion
		
};


init_recipes() // load crafting recipe library

makeRoomForPlayer = false

// grid setup
invColumns = 9;
invRows = 4;
padding = 2; // gap between slots

craftColumns = 3;
craftRows = 3;

slotW = sprite_get_width(sprSlot);
slotH = sprite_get_height(sprSlot);
pitchX = slotW + padding;
pitchY = slotH + padding;


gridX = 0; gridY = 0;
craftGridX = 0; craftGridY = 0;
chestGridX = 0; chestGridY = 0;
outputSlotX = 0; outputSlotY = 0;

xOffsetInv = 0
yOffsetInv = 55

xOffsetCraft = 0;
yOffsetCraft = -22;

outputGapX = 24;

// background art 
bgWidthInvOnly  = 176;
bgHeightInvOnly = 86;

bgWidthCraft  = 176;
bgHeightCraft = 174;

bgWidthChestInv  = 176;
bgHeightChestInv = 174;


selectedRow = -1;
selectedColumn = -1;

craftSelectedRow = -1;
craftSelectedColumn = -1;

heldItem = noone; // attached to cursor

dragMode = eDragMode.NONE;
dragSlots = [];		// slots painted during current drag
dragStartSlot = noone;
dragMoved = false; // did the mouse leave dragStartSlot before release?

shiftDragActive = false;

hotbarIndex = 0; // which column of inventory[invRows - 1] (bottom row) is the active held item

////
	craftingOpen = false;
////


craftOutput = noone

// Loot chests
activeChest = noone;
chestSelectedRow = -1;
chestSelectedColumn = -1;

// create inventory
inventory = array_create(invRows);
for (var i = 0; i < invRows; i++)
{
	inventory[i] = array_create(invColumns, noone);
}

// create crafting grid
craftInventory = array_create(craftRows);
for (var i = 0; i < craftRows; i++)
{
	craftInventory[i] = array_create(craftColumns, noone);
}


// apply any inventory loaded from save_inventory.json
if (variable_global_exists("pendingInventoryLoad") && global.pendingInventoryLoad != noone)
{
	inventory = deserializeInventoryGrid(global.pendingInventoryLoad.inventory, invRows, invColumns);
	
	global.pendingInventoryLoad = noone; // consume it so later room transitions don't reapply old data
}

// Recalculates gridX/gridY, craftGridX/Y, outputSlotX/Y and chestGridX/Y.
// Called from Step (for hover/input logic) AND from the top of Draw, so that
// if activeChest changes anywhere after this object's Step has already run,
// Draw still renders the chest in its correct spot instead of last frame's.
function updateGridPositions()
{
	var _gridW = invColumns * pitchX - padding;
	var _gridH = invRows * pitchY - padding;
	gridX = camera_get_view_x(view_camera) + ((camera_get_view_width(view_camera) - _gridW) /2) + xOffsetInv;
	gridY = camera_get_view_y(view_camera) + ((camera_get_view_height(view_camera) - _gridH) /2) + yOffsetInv;

	var _showCrafting = (activeChest == noone) && craftingOpen;

	if (_showCrafting)
	{
		var _craftGridW = craftColumns * pitchX - padding;
		var _craftGridH = craftRows * pitchY - padding;
		craftGridX = camera_get_view_x(view_camera) + ((camera_get_view_width(view_camera) - _craftGridW) /2) + xOffsetCraft;
		craftGridY = camera_get_view_y(view_camera) + ((camera_get_view_height(view_camera) - _craftGridH) /2) + yOffsetCraft;

		outputSlotX = craftGridX + (craftColumns * pitchX) + outputGapX;
		outputSlotY = craftGridY + (_craftGridH - slotH) / 2;
	}

	if (activeChest != noone)
	{
		var _chestGridW = activeChest.chestColumns * pitchX - padding;
		var _chestGridH = activeChest.chestRows * pitchY - padding;
		chestGridX = gridX + (_gridW - _chestGridW) / 2; // centered over the player inventory
		chestGridY = gridY - _chestGridH - 16; // stacked above the player inventory
	}
}

// Top left pixel pos of a given slot (call after gridX/gridY are set each frame
function getSlotPos(_row, _column)
{
	return [gridX + _column * pitchX, gridY + _row * pitchY];
}

function getCraftSlotPos(_row, _column)
{
	return [craftGridX + _column * pitchX, craftGridY + _row * pitchY];
}

function getChestSlotPos(_row, _column)
{
	return [chestGridX + _column * pitchX, chestGridY + _row * pitchY];
}

function drawItemAt(_item, _sx, _sy)
{
	draw_sprite(_item.SlotSprite, 0, _sx + (slotW / 2), _sy + (slotH / 2));
	
	if (_item.Count > 1)
	{
		draw_set_halign(fa_right);
		draw_set_valign(fa_bottom);
		draw_text(_sx + slotW, _sy + slotH, string(_item.Count));
		draw_set_halign(fa_left);
		draw_set_valign(fa_top);
	}
}

function getSlotDragColour(_grid, _row, _col, _isHovered)
{
	if (dragMode == eDragMode.EVEN)
	{
		for (var k = 0; k < array_length(dragSlots); k++)
		{
			var _s = dragSlots[k];
			if (_s.grid == _grid && _s.row == _row && _s.col == _col)
			{
				return c_ltgrey;
			}
		}
	}
	
	return _isHovered ? c_ltgrey : c_white;
}


// Applies stats from whatever's in the active hotbar slot, every frame,
// open or closed. Only one item can be "held" now, so anything the current
// item ISN'T falls back to its bare-hand/unarmed default.
function updateHotbarEquip()
{
	var _item = inventory[invRows - 1][hotbarIndex];
	var _type = (_item != noone) ? _item.ItemType : "none";
	
	objPlayer.swordPower	= (_type == "melee")	? _item.Stats.damageMultiplier	: 0;
	objPlayer.rangedPower	= (_type == "ranged")	? _item.Stats.damageMultiplier	: 0;
	objPlayer.magicPower	= (_type == "magic")	? _item.Stats.damageMultiplier	: 0;
	objPlayer.BreakSpeed	= (_type == "tools")	? _item.Stats.BreakSpeed		: 0;
	
	objPlayer.equippedItemType = _type;
	objPlayer.heldHotbarItem = _item; // useful later for a "use held item" action
}