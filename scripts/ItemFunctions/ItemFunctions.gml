//ItemFunctions.gml



function addItemToInventory(_item)
{
	return objInventoryManager.addItemToGrid(_item, objInventoryManager.inventory, objInventoryManager.invRows, objInventoryManager.invColumns, objInventoryManager.getInvRowOrder());
}



function dropItemSlot(_array, row, column, _amount = 1, _instaCollect = false)
{
	var _item = _array[row][column];
	if (_item == noone) return;
	
	var _dropAmount = min(_amount, _item.Count);
	var _dropItem = cloneItem(_item, _dropAmount);
	
	var _gem = instance_create_layer(objPlayerSpecialHitbox.x, objPlayerSpecialHitbox.y, "Instances", objItemGem, { item: _dropItem });
	with (_gem)
	{
		direction = point_direction(objPlayerSpecialHitbox.x, objPlayerSpecialHitbox.y, mouse_x, mouse_y);
		speed = 2.2;
		item = _dropItem;
		
		if _instaCollect {alarm[0] = 0}
	}
	
	_item.Count -= _dropAmount;
	if (_item.Count <= 0) _array[row][column] = noone;
}

function dropItemLoot(_item, _amount = 1, _asStack = false, _instaCollect = false)
{
	if (_asStack)
	{
		var _dropItem = cloneItem(_item, _amount); // one gem carrying the full count
		var _gem = instance_create_layer(x, y, "Instances", objItemGem, { item: _dropItem });
		with (_gem)
		{
			direction = random_range(0, 359);
			speed = random_range(1.2, 2);
			
			if _instaCollect {alarm[0] = 0}
		}
		return;
	}
	
	for (var i = 0; i < _amount; i++)
	{
		var _dropItem = cloneItem(_item);
		var _gem = instance_create_layer(x, y, "Instances", objItemGem, { item: _dropItem });
		with (_gem)
		{
			direction = random_range(0, 359);
			speed = random_range(1.2, 2);
			
			if _instaCollect {alarm[0] = 0}
		}
	}
}
function dropItemHeld(_amount = 1, _instaCollect = false)
{
	var _item = objInventoryManager.heldItem;
	if (_item == noone) return;
	
	var _dropAmount = min(_amount, _item.Count);
	var _dropItem = cloneItem(_item, _dropAmount);
	
	var _gem = instance_create_layer(objPlayerSpecialHitbox.x, objPlayerSpecialHitbox.y, "Instances", objItemGem, { item: _dropItem });
	with (_gem)
	{
		direction = point_direction(objPlayerSpecialHitbox.x, objPlayerSpecialHitbox.y, mouse_x, mouse_y);
		speed = 2.2;
		
		item = _dropItem;
		if _instaCollect {alarm[0] = 0}
	}
	
	_item.Count -= _dropAmount;
	if (_item.Count <= 0) objInventoryManager.heldItem = noone;
}

// Pulls ONE unit of the first item found in a chest, as its own single-count
// item struct. Shrinks/clears the source slot. Returns noone if empty.
function extractItemFromContainer(_container)
{
	for (var i = 0; i < _container.chestRows; i++)
	{
		for (var j = 0; j < _container.chestColumns; j++)
		{
			var _slotItem = _container.containerInventory[i][j];
			if (_slotItem == noone) continue;
			
			var _extracted = cloneItem(_slotItem, 1);
			_slotItem.Count -= 1;
			if (_slotItem.Count <= 0) _container.containerInventory[i][j] = noone;
			
			return _extracted;
		}
	}
	return noone;
}

// Inserts one unit of _item into a chest - tops up a matching stack first,
// falls back to the first empty slot. Returns false if there's no room.
function insertItemIntoContainer(_container, _item)
{
	var _rows = _container.chestRows;
	var _cols = _container.chestColumns;
	var _arr = _container.containerInventory;
	
	for (var i = 0; i < _rows; i++)
	{
		for (var j = 0; j < _cols; j++)
		{
			var _slotItem = _arr[i][j];
			if (_slotItem == noone) continue;
			if (_slotItem.ItemID != _item.ItemID) continue;
			if (_slotItem.Count >= _slotItem.MaxStack) continue;
			
			_slotItem.Count += 1;
			return true;
		}
	}
	
	for (var i = 0; i < _rows; i++)
	{
		for (var j = 0; j < _cols; j++)
		{
			if (_arr[i][j] != noone) continue;
			
			_arr[i][j] = cloneItem(_item, 1);
			return true;
		}
	}
	
	return false;
}

// CRAFTING
function init_recipes()
{
	global.recipeList = [
		{
			shaped: true,
			pattern: [
				[noone, "burger", noone],
				["burger", noone, "burger"],
				[noone, "burger", noone]
			],
			result: "apple",
			resultCount: 4
		},
	
		{
			shaped: true,
			pattern: [
				["wood", "wood", "wood"],
				[noone, "stick", noone],
				[noone, "stick", noone]
			],
			result: "pickaxe_wooden",
			resultCount: 1
		},
	
		{
			shaped: true,
			pattern: [
				["rock", "rock", "rock"],
				[noone, "stick", noone],
				[noone, "stick", noone]
			],
			result: "pickaxe_stone",
			resultCount: 1
		},
	
		{
			shaped: true,
			pattern: [
				["iron_bar", "iron_bar", "iron_bar"],
				[noone, "stick", noone],
				[noone, "stick", noone]
			],
			result: "pickaxe_iron",
			resultCount: 1
		},
	
		{
			shaped: true,
			pattern: [
				[noone, "wood", noone],
				[noone, "wood", noone],
				[noone, "stick", noone]
			],
			result: "sword_wooden",
			resultCount: 1
		},
	
		{
			shaped: true,
			pattern: [
				[noone, "rock", noone],
				[noone, "rock", noone],
				[noone, "stick", noone]
			],
			result: "sword_stone",
			resultCount: 1
		},
			
		{
			shaped: true,
			pattern: [
				[noone, "iron_bar", noone],
				[noone, "iron_bar", noone],
				[noone, "stick", noone]
			],
			result: "sword_iron",
			resultCount: 1
		},
	
		{
			shaped: true,
			pattern: [
				[noone, "gold_bar", noone],
				[noone, "gold_bar", noone],
				[noone, "stick", noone]
			],
			result: "sword_gold",
			resultCount: 1
		},
		
		{
			shaped: false,
			ingredients: ["apple"],
			result: "burger",
			resultCount: 1
		},
		
		{
			shaped: true,
			pattern: [
				[noone, noone, noone],
				[noone, "wood", noone],
				[noone, "wood", noone]
			],
			result: "stick",
			resultCount: 4
		},
		
		{
			shaped: true,
			pattern: [
				[noone, noone, noone],
				["wood", "wood", noone],
				["wood", "wood", noone]
			],
			result: "craftingtable",
			resultCount: 1
		},
		
		{
			shaped: true,
			pattern: [
				["iron_bar", noone, "iron_bar"],
				["iron_bar", noone,	"iron_bar"],
				["iron_bar", "iron_bar", "iron_bar"]
			],
			result: "trashcan",
			resultCount: 1
		},
		
		{
			shaped: true,
			pattern: [
				["iron_bar", "iron_bar", "iron_bar"],
				["conductive_powder", "conductive_powder",	"conductive_powder"],
				["iron_bar", "iron_bar", "iron_bar"]
			],
			result: "conveyor",
			resultCount: 3
		},
	];
}

#region Crafting helpers

function getPatternBounds(_pattern, _rows, _cols)
{
	var _minRow = _rows, _maxRow = -1, _minCol = _cols, _maxCol = -1;
	
	for (var i = 0; i < _rows; i++)
	{
		for (var j = 0; j < _cols; j++)
		{
			if (_pattern[i][j] != noone)
			{
				_minRow = min(_minRow, i);
				_maxRow = max(_maxRow, i);
				_minCol = min(_minCol, j);
				_maxCol = max(_maxCol, j);
			}
		}
	}
	
	return { minRow: _minRow, maxRow: _maxRow, minCol: _minCol, maxCol: _maxCol };
}

function matchShapedAtOffset(_pattern, _bounds, _rowOffset, _colOffset, _rows, _cols)
{
	for (var i = 0; i < _rows; i++)
	{
		for (var j = 0; j < _cols; j++)
		{
			var _cell = objInventoryManager.craftInventory[i][j];
			var _cellID = (_cell == noone) ? noone : _cell.ItemID;
			
			// map this grid cell back into the recipe's own bounding box
			var _pRow = i - _rowOffset + _bounds.minRow;
			var _pCol = j - _colOffset + _bounds.minCol;
			
			var _expected = noone;
			if (_pRow >= _bounds.minRow && _pRow <= _bounds.maxRow &&
			    _pCol >= _bounds.minCol && _pCol <= _bounds.maxCol)
			{
				_expected = _pattern[_pRow][_pCol];
			}
			
			if (_cellID != _expected) return false;
		}
	}
	return true;
}

function matchShaped(_recipe)
{
	var _rows = objInventoryManager.craftRows;
	var _cols = objInventoryManager.craftColumns;
	var _bounds = getPatternBounds(_recipe.pattern, _rows, _cols);
	
	var _shapeH = _bounds.maxRow - _bounds.minRow + 1;
	var _shapeW = _bounds.maxCol - _bounds.minCol + 1;
	
	for (var _rowOffset = 0; _rowOffset <= _rows - _shapeH; _rowOffset++)
	{
		for (var _colOffset = 0; _colOffset <= _cols - _shapeW; _colOffset++)
		{
			if (matchShapedAtOffset(_recipe.pattern, _bounds, _rowOffset, _colOffset, _rows, _cols))
			{
				return true;
			}
		}
	}
	return false;
}

function matchShapeless(_recipe)
{
	var _gridIDs = [];
	
	for (var i = 0; i < objInventoryManager.craftRows; i++)
	{
		for (var j = 0; j < objInventoryManager.craftColumns; j++)
		{
			var _cell = objInventoryManager.craftInventory[i][j];
			if (_cell != noone) array_push(_gridIDs, _cell.ItemID);
		}
	}
	
	if (array_length(_gridIDs) != array_length(_recipe.ingredients)) return false;
	
	var _recipeIDs = array_create(array_length(_recipe.ingredients));
	array_copy(_recipeIDs, 0, _recipe.ingredients, 0, array_length(_recipe.ingredients));
	
	array_sort(_gridIDs, true);
	array_sort(_recipeIDs, true);
	
	for (var k = 0; k < array_length(_gridIDs); k++)
	{
		if (_gridIDs[k] != _recipeIDs[k]) return false;
	}
	return true;
}


function checkForRecipe()
{
	for (var r = 0; r < array_length(global.recipeList); r++)
	{
		var _recipe = global.recipeList[r];
		var _isMatch = _recipe.shaped ? matchShaped(_recipe) : matchShapeless(_recipe);
		
		if (_isMatch)
		{
			var _resultItem = global.itemDictionary[$ _recipe.result];
			return cloneItem(_resultItem, _recipe.resultCount); // fresh clone, correct quantity — never the shared template
		}
	}
	return noone;
}

function consumeCraftIngredients()
{
	// one craft = one unit consumed from every occupied slot that contributed to the match
	for (var i = 0; i < objInventoryManager.craftRows; i++)
	{
		for (var j = 0; j < objInventoryManager.craftColumns; j++)
		{
			var _cell = objInventoryManager.craftInventory[i][j];
			if (_cell == noone) continue;
			
			_cell.Count -= 1;
			if (_cell.Count <= 0) objInventoryManager.craftInventory[i][j] = noone;
		}
	}
}

function cloneItem(_templateItem, _count = 1)
{
	var _newItem = variable_clone(_templateItem);
	_newItem.Count = _count;
	return _newItem;
}

function sortInventory()
{
	var _items = [];
	
	// pull everything out, merging same-ID stacks into one running total
	for (var i = 0; i < objInventoryManager.invRows; i++)
	{
		for (var j = 0; j < objInventoryManager.invColumns; j++)
		{
			var _slot = objInventoryManager.inventory[i][j];
			if (_slot == noone) continue;
			
			var _merged = false;
			for (var k = 0; k < array_length(_items); k++)
			{
				if (_items[k].ItemID == _slot.ItemID)
				{
					_items[k].Count += _slot.Count;
					_merged = true;
					break;
				}
			}
			if (!_merged) array_push(_items, cloneItem(_slot, _slot.Count));
			
			objInventoryManager.inventory[i][j] = noone;
		}
	}
	
	// alphabetical by display name
	array_sort(_items, function(_a, _b)
	{
		if (_a.ItemName == _b.ItemName) return 0;
		return (_a.ItemName < _b.ItemName) ? -1 : 1;
	});
	
	// lay back down, re-splitting anything over MaxStack
	var _row = 0;
	var _col = 0;
	
	for (var k = 0; k < array_length(_items); k++)
	{
		var _remaining = _items[k].Count;
		
		while (_remaining > 0)
		{
			var _stackAmount = min(_remaining, _items[k].MaxStack);
			objInventoryManager.inventory[_row][_col] = cloneItem(_items[k], _stackAmount);
			_remaining -= _stackAmount;
			
			_col += 1;
			if (_col >= objInventoryManager.invColumns)
			{
				_col = 0;
				_row += 1;
				if (_row >= objInventoryManager.invRows) return; // shouldn't happen — same items, same grid
			}
		}
	}
}

function quickMoveCraftSlot(_slot)
{
	var _item = getSlotItem(_slot);
	if (_item == noone) return;
	
	setSlotItem(_slot, noone); // detach first — addItemToInventory may store this exact reference
	
	var _fullyMoved = addItemToInventory(_item);
	
	if (!_fullyMoved)
	{
		// inventory's full — whatever's left goes back where it came from
		setSlotItem(_slot, _item);
	}
}

#endregion


#region Item Stats

global.SwordStats = {
	stick : {damageMultiplier: 0.5, textCol: c_white },
	swordWooden : {damageMultiplier: 0.8, textCol: c_white },
	swordStone : {damageMultiplier: 1.2, textCol: c_white },
	swordIron : { damageMultiplier: 1.4, textCol: c_white },
	swordGold : { damageMultiplier: 1.5, textCol: c_white },
	swordPlatinum : { damageMultiplier: 1.8, textCol: c_aqua },
	swordDiamond : { damageMultiplier: 2, textCol: c_red },
	swordPalladium : { damageMultiplier: 2.3, textCol: c_orange },
	swordSorium : { damageMultiplier: 2.6, textCol: c_fuchsia },
	swordGodlike : { damageMultiplier: 99, textCol: c_black }
};


global.ToolStats = {
	pickaxeWooden : {BreakSpeed: 0.4, textCol: c_white },
	pickaxeStone : {BreakSpeed: 0.8, textCol: c_white },
	pickaxeIron : { BreakSpeed: 1.2, textCol: c_white },
	pickaxeGold : { BreakSpeed: 1.5, textCol: c_white },
	pickaxePlatinum : { BreakSpeed: 2, textCol: c_aqua },
	pickaxeDiamond : { BreakSpeed: 2.6, textCol: c_red },
	pickaxePalladium : { BreakSpeed: 3, textCol: c_orange },
	pickaxeSorium : { BreakSpeed: 4, textCol: c_fuchsia },
	pickaxeGodlike : { BreakSpeed: 99, textCol: c_black }
};

#endregion

#region Chest Loot



global.chestLootTables = {
	chestCommon : [
		{ itemId: "wood",        chance: 0.85, min: 2, max: 6 },
		{ itemId: "stick",       chance: 0.6,  min: 1, max: 3 },
		{ itemId: "apple",       chance: 0.4,  min: 1, max: 2 },
		{ itemId: "iron_bar",    chance: 0.2,  min: 1, max: 2 },
		{ itemId: "sword_wooden", chance: 0.08, min: 1, max: 1 },
	],
	
	chestRare : [
		{ itemId: "iron_bar",		chance: 0.9, min: 3, max: 6 },
		{ itemId: "burger",			chance: 0.2, min: 1, max: 3 },
		{ itemId: "sword_iron",		chance: 0.5, min: 1, max: 1 },
		{ itemId: "gold_bar",		chance: 0.9, min: 3, max: 6 }
	],
};


// Attempts to place whatever's in the given hotbar slot as a world tile.
// Returns true if it placed (and consumed one item), false otherwise.
function tryPlaceHeldItem(_item, _worldX, _worldY)
{
	if (_item == noone) return false;
	if (_item.ItemType != "block") return false;
	if (!instance_exists(objGridSystem)) return false;
	
	var _pos = objGridSystem.worldToTile(_worldX, _worldY);
	var _placed = objGridSystem.placeTile(_pos.row, _pos.col, _item.ItemID);
	
	if (_placed)
	{
		_item.Count -= 1;
	}
	
	return _placed;
}

function getItemsByType(_type)
{
	var _result = [];
	var _inv = objInventoryManager.inventory;

	for (var i = 0; i < array_length(_inv); i++)
	{
		var _row = _inv[i];
		for (var j = 0; j < array_length(_row); j++)
		{
			var _item = _row[j];
			if (_item != noone && _item.ItemType == _type)
			{
				array_push(_result, _item);
			}
		}
	}

	return _result;
}


function generateChestLoot(_tableId, _grid, _rows, _cols)
{
	var _table = global.chestLootTables[$ _tableId];
	if (is_undefined(_table))
	{
		show_debug_message("generateChestLoot: no loot table found for " + _tableId);
		return;
	}
	
	// track which slots are still free so items don't stack on top of each other
	var _emptySlots = [];
	for (var i = 0; i < _rows; i++)
	{
		for (var j = 0; j < _cols; j++)
		{
			array_push(_emptySlots, [i, j]);
		}
	}
	
	for (var k = 0; k < array_length(_table); k++)
	{
		var _entry = _table[k];
		
		if (array_length(_emptySlots) <= 0) break;      // chest is full
		if (random(1) > _entry.chance) continue;         // this roll failed
		
		var _pickIndex = irandom(array_length(_emptySlots) - 1);
		var _pos = _emptySlots[_pickIndex];
		array_delete(_emptySlots, _pickIndex, 1);
		
		var _itemDef = global.itemDictionary[$ _entry.itemId];
		var _count = irandom_range(_entry.min, _entry.max);
		
		_grid[_pos[0]][_pos[1]] = cloneItem(_itemDef, _count);
	}
}


#endregion


#region Enemy Loot

function generateEnemyLoot(_enemy)
{
	var _table = global.chestLootTables[$ _tableId];
	if (is_undefined(_table))
	{
		show_debug_message("generateChestLoot: no loot table found for " + _tableId);
		return;
	}
	
	// track which slots are still free so items don't stack on top of each other
	var _emptySlots = [];
	for (var i = 0; i < _rows; i++)
	{
		for (var j = 0; j < _cols; j++)
		{
			array_push(_emptySlots, [i, j]);
		}
	}
	
	for (var k = 0; k < array_length(_table); k++)
	{
		var _entry = _table[k];
		
		if (array_length(_emptySlots) <= 0) break;      // chest is full
		if (random(1) > _entry.chance) continue;         // this roll failed
		
		var _pickIndex = irandom(array_length(_emptySlots) - 1);
		var _pos = _emptySlots[_pickIndex];
		array_delete(_emptySlots, _pickIndex, 1);
		
		var _itemDef = global.itemDictionary[$ _entry.itemId];
		var _count = irandom_range(_entry.min, _entry.max);
		
		_grid[_pos[0]][_pos[1]] = cloneItem(_itemDef, _count);
	}
}


function inventoryHasSpaceForItem(_item)
{
	for (var i = 0; i < objInventoryManager.invRows; i++)
	{
		for (var j = 0; j < objInventoryManager.invColumns; j++)
		{
			var _slot = objInventoryManager.inventory[i][j];
			
			if (_slot == noone) return true; // empty slot — always fits
			if (_slot.ItemID == _item.ItemID && _slot.Count < _slot.MaxStack) return true; // room to merge
		}
	}
	return false;
}

#endregion
